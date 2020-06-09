import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/global.dart';
import 'package:nsb/model/GoMerchantPaymentRequest.dart';
import 'package:nsb/model/GoTransferResponse.dart';
import 'package:nsb/pages/MeterBill/meterBillSuccess.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/utils/crypt_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nsb/framework/http_service.dart' as http;

class meterBillConfirmPage extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;

  meterBillConfirmPage({Key key, this.value, this.value1, this.value2})
      : super(key: key);
  @override
  _meterBillConfirmPageState createState() => _meterBillConfirmPageState();
}

class _meterBillConfirmPageState extends State<meterBillConfirmPage> {
  String alertmsg = "";
  String rkey = "";
  String password = "";
  bool isLoading = false;
  String checklang = '';
  List textMyan = [
    "အတည်ပြုခြင်း",
    "MerchantID",
    "အမည်",
    "ငွေပမာဏ",
    "ပယ်ဖျက်မည်",
    "ပေးသွင်းမည်",
    "ကျပ်"
  ];
  List textEng = [
    "Transfer Confirm",
    "MerchantID",
    "Name",
    "Amount",
    "Cancel",
    "Pay",
    "MMK"
  ];
  final myControllerno = TextEditingController();
  final myControllername = TextEditingController();
  final myControlleramout = TextEditingController();
  final myControllerref = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void initState() {
    checkLanguage();
    super.initState();
  }

  void _method1() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
        content: new Text(this.alertmsg),backgroundColor: Colors.blueAccent, duration: Duration(seconds: 1)));
  }

  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    checklang = prefs.getString("Lang");
    if (checklang == "" || checklang == null || checklang.length == 0) {
      checklang = "Eng";
    } else {
      checklang = checklang;
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    final titleField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 15),
          child: Text(
            (checklang == "Eng") ? textEng[1] : textMyan[1],
            style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          child: Text("${widget.value2}",
              style: TextStyle(fontSize: 15, color: colorblack)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));

    final passwordField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 0, 15),
          child: Text(
            (checklang == "Eng") ? textEng[2] : textMyan[2],
            style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          child: Text("${widget.value1}",
              style: TextStyle(fontSize: 15, color: colorblack)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));

    final passwordField2 = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 0, 15),
          child: Text(
            (checklang == "Eng") ? textEng[3] : textMyan[3],
            style: TextStyle(fontSize: 12,fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          child: Text("${widget.value}" + ".00 MMK",
              style: TextStyle(fontSize: 15, color: colorblack)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));

    final cancelbutton = new OutlineButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: () async {
        this.alertmsg = '';
        Navigator.pop(context);
      },
      borderSide: BorderSide(
        color: colorgreen
      ),
      color: colorgreen,
      textColor: colorgreen,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.33,
        height: 43.0,
        child: Center(
          child: (checklang == "Eng")
              ? Text(
                  (checklang == "Eng") ? textEng[4] : textMyan[4],
                  style: TextStyle(fontSize: 15,),
                )
              : Text(
                  (checklang == "Eng") ? textEng[4] : textMyan[4],
                  style: TextStyle(fontSize: 14),
                ),
        ),
      ),
    );

    final transferbutton = new RaisedButton(
      onPressed: () async {
        setState(() {
          isLoading=true;
        });
        final prefs = await SharedPreferences.getInstance();
        String userID = prefs.getString('userId');
        String username = prefs.getString('name');
        String sessionID = prefs.getString('sessionID');
        final iv = AesUtil.random(16);
        print("iv :" + iv);
        final dm = AesUtil.random(16);
        print("dm :" + dm);
        final salt = AesUtil.random(16);
        print("salt :" + salt);
        String res = AesUtil.encrypt(salt, iv, this.password);
        print("res is :" + res);
        GoMerchantPaymentRequest goTransferRequest =
            new GoMerchantPaymentRequest(
                token: sessionID,
                senderCode: userID,
                merchantID: "${widget.value2}",
                fromName: username,
                amount: "${widget.value}",
                prevBalance: "",
                password: res,
                iv: iv,
                dm: dm,
                salt: salt);
        GoTransferResponse goTransferResponse = await goOpenAccount(
            '$link' + '/payment/goMerchantPayment',
            goTransferRequest.toMap());
        if (goTransferResponse.code == '0000') {
          setState(() {
            isLoading=false;
          });
          this.alertmsg = "";
          print(goTransferResponse);
          print(goTransferResponse.toString());
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => new MeterBillSuccessPage(
                  value: goTransferResponse.bankRefNumber,
                  value1: goTransferRequest.fromName,
                  value2: "${widget.value}",
                  value3: goTransferResponse.transactionDate,
                  value4: "${widget.value1}"));
          Navigator.of(context).push(route);
          this.alertmsg = goTransferResponse.desc;
          this._method1();
        } else {
          this.alertmsg = goTransferResponse.desc;
          this._method1();
          final form = _formKey.currentState;
          form.validate();
          setState(() {
            isLoading=false;
          });
        }
      },
      color: colorgreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      textColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.33,
        height: 43.0,
        child: Center(
          child: (checklang == "Eng")
              ? Text(
                  (checklang == "Eng") ? textEng[5] : textMyan[5],
                  style: TextStyle(fontSize: 15),
                )
              : Text(
                  (checklang == "Eng") ? textEng[5] : textMyan[5],
                  style: TextStyle(fontSize: 14),
                ),
        ),
      ),
    );

    var billbody = new Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0,
                child: Column(
                  children: <Widget>[
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: titleField,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: passwordField,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: passwordField2,
                      ),
                    ),
                    SizedBox(height:20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Container(
                          child: cancelbutton,
                        ),
                        new Container(
                          child: transferbutton,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          billbody,
          Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: colorgreen,
                ),
              ))
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: bgcolor,
      appBar: new AppBar(
        elevation: 2.0,
        backgroundColor: colorgreen,
        centerTitle: true, 
        title: (checklang == "Eng")
            ? Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 19, color: Colors.white,fontWeight: FontWeight.w500),
              )
            : Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
      body: isLoading ? bodyProgress : billbody
    );
  }

  Future<GoTransferResponse> goOpenAccount(url, Map jsonMap) async {
    GoTransferResponse p = new GoTransferResponse();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = GoTransferResponse.fromJson(json.decode(body.toString()));
    } catch (e) {
      p.code = Constants.responseCode_Error;
      p.desc = e.toString();
    }
    print(p.toMap());
    return p;
  }
}
