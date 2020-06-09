import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/constants/rout_path.dart' as routes;
import 'package:nsb/global.dart';
import 'package:nsb/model/GoTransferRequest.dart';
import 'package:nsb/model/GoTransferResponse.dart';
import 'package:nsb/model/ReadMessageRequest.dart';
import 'package:nsb/model/ReadMessageResponse.dart';
import 'package:nsb/pages/Scan/ScanPaymentSuccess.dart';
import 'package:nsb/utils/crypt_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nsb/framework/http_service.dart' as http;

class ScanPaymentConfirm extends StatefulWidget {
  final String value1;
  final String value2;
  final String value3;
  final String value4;

  ScanPaymentConfirm(
      {Key key, this.value1, this.value2, this.value3, this.value4})
      : super(key: key);

  @override
  _TransferConfirmPageState createState() => _TransferConfirmPageState();
}

class _TransferConfirmPageState extends State<ScanPaymentConfirm> {
  String alertmsg = "";
  String rkey = "";
  String password = "";
  bool isLoading = false;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  String checklang = '';
  List textMyan = [
    "အတည်​ပြုခြင်​း",
    "​ငွှေလွှဲသူ",
    "အမည်​",
    "​ငွေပမာဏ",
    "အကြောင်းအရာ",
    "​ပယ်​ဖျက်​မည်​",
    "လုပ်​​ဆောင်​မည်​"
  ];
  List textEng = [
    "Confirmation",
    "Payee",
    "Name",
    "Amount",
    "Reference",
    "Cancel",
    "Confirm"
  ];

  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    checklang = prefs.getString("Lang");
    // print(lang);
    if (checklang == "" || checklang == null || checklang.length == 0) {
      checklang = "Eng";
    } else {
      checklang = checklang;
    }
    setState(() {});
  }

  void initState() {
    super.initState();
    checkLanguage();
  }

  snackbartrue(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      backgroundColor: colorgreen,
      duration: Duration(seconds: 2),
    ));
  }
  snackbarfalse(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      backgroundColor: colorerror,
      duration: Duration(seconds: 2),
    ));
  }

  Widget build(BuildContext context) {

    final PhoneField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 2.5, 0.0, 0.0),
          child: Text(
            checklang == "Eng" ? textEng[1] : textMyan[1],
            style: TextStyle(
                fontSize: 14, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 6.5, 0.0, 0.0),
          child: Text("${widget.value1}",
              style: TextStyle(fontSize: 15, color: colorblack,fontWeight: FontWeight.w500)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));

    final NameField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 2.5, 0.0, 0.0),
          child: Text(
            checklang == "Eng" ? textEng[2] : textMyan[2],
            style: TextStyle(
                fontSize: 14, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 6.5, 0.0, 0.0),
          child: Text("${widget.value2}",
              style: TextStyle(fontSize: 15, color: colorblack,fontWeight: FontWeight.w500)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));
    final AmountField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 2.5, 0.0, 0.0),
          child: Text(
            checklang == "Eng" ? textEng[3] : textMyan[3],
            style: TextStyle(
                fontSize: 14, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 6.5, 0.0, 0.0),
          child: Text("${widget.value3}",
              style: TextStyle(fontSize: 15, color: colorblack,fontWeight: FontWeight.w500)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));
    final RefField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 2.5, 0.0, 0.0),
          child: Text(
            checklang == "Eng" ? textEng[4] : textMyan[4],
            style: TextStyle(
                fontSize: 14, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 6.5, 0.0, 0.0),
          child: Text("${widget.value4}",
              style: TextStyle(fontSize: 15, color: colorblack,fontWeight: FontWeight.w500)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));

    final cancelbutton = new OutlineButton(
      splashColor: colorblack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: () async {
        this.alertmsg = '';
        Navigator.pop(context);
      },
      color: colorgreen,
      textColor: colorgreen,
      borderSide: BorderSide(color: colorgreen),
      child: Container(
        // width: 130.0,
        height: 43.0,
        child: Center(
            child: Text(checklang == "Eng" ? textEng[5] : textMyan[5],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
      ),
    );

    final transferbutton = new RaisedButton(
      splashColor: colorblack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: () async {
        setState(() {
          isLoading = true;
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
        GoTransferRequest goTransferRequest = new GoTransferRequest(
            token: sessionID,
            senderCode: userID,
            receiverCode: "${widget.value1}",
            fromName: username,
            toName: "${widget.value2}",
            amount: "${widget.value3}",
            prevBalance: "",
            password: res,
            iv: iv,
            dm: dm,
            salt: salt,
            appType: "wallet");
        GoTransferResponse goTransferResponse = await goOpenAccount(
            '$link' + '/payment/goTransfer', goTransferRequest.toMap());
        if (goTransferResponse.code == '0000') {
          setState(() {
            isLoading = false;
          });
          this.alertmsg = "";
          print(goTransferResponse.toString());
           Future.delayed(const Duration(milliseconds: 2000), () {
             var route = new MaterialPageRoute(
              builder: (BuildContext context) => new ScanPaymentSuccess(
                  value: "${widget.value3}",
                  value1: goTransferResponse.bankRefNumber,
                  value2: goTransferResponse.transactionDate,
                  value3: goTransferRequest.toName));
          Navigator.of(context).push(route);
                  });
          snackbartrue(goTransferResponse.desc);
        } else {
          snackbarfalse(goTransferResponse.desc);
          final form = _formKey.currentState;
          form.validate();
          setState(() {
            isLoading = false;
          });
        }
      },
      color: colorgreen,
      textColor: Colors.white,
      child: Container(
        // width: 130.0,
        height: 43.0,
        child: Center(
            child: Text(checklang == "Eng" ? textEng[6] : textMyan[6],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
      ),
    );

    var paybody = new Form(
      key: _formKey,
      child: new ListView(
        children: <Widget>[
          SizedBox(height: 5.0),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 15.0, right: 10.0),
                    ),
                  ),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 15.0, right: 10.0),
                      child: PhoneField,
                    ),
                  ),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 15.0, right: 10.0),
                      child: NameField,
                    ),
                  ),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 15.0, right: 10.0),
                      child: AmountField,
                    ),
                  ),
                  widget.value4 =="" ? Container() :
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 15.0, right: 10.0),
                      child: RefField,
                    ),
                  ),
                  SizedBox(
                     height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: cancelbutton,
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: transferbutton,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
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
          paybody,
          Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                ),
              ))
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: bgcolor,
      appBar: new AppBar(
          centerTitle: true,
          backgroundColor: colorgreen,
          title: Text(
              checklang == "Eng" ? textEng[0] : textMyan[0],
              style: TextStyle(
                  fontSize: 19.0,
                  color: Colors.white,
                  height: 1.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
      body: isLoading ? bodyProgress : paybody,
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
