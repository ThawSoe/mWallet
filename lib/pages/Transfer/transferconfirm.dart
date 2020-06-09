import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/constants/rout_path.dart' as routes;
import 'package:nsb/global.dart';
import 'package:nsb/model/GoTransferRequest.dart';
import 'package:nsb/model/GoTransferResponse.dart';
import 'package:nsb/pages/Transfer/transfersuccess.dart';
import 'package:nsb/utils/crypt_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nsb/framework/http_service.dart' as http;

class TransferConfirmPage extends StatefulWidget {
  final String value1;
  final String value2;
  final String value3;
  final String value4;

  TransferConfirmPage(
      {Key key, this.value1, this.value2, this.value3, this.value4})
      : super(key: key);

  @override
  _TransferConfirmPageState createState() => _TransferConfirmPageState();
}

class _TransferConfirmPageState extends State<TransferConfirmPage> {
  String alertmsg = "";
  String rkey = "";
  String password = "";
  bool isLoading = false;
  String checklang = '';
  final myControlleramout = TextEditingController();
  final myControllerref = TextEditingController();
  final myControllerphone = TextEditingController();
  final myControllername = TextEditingController();
  List textMyan = [
    "အတည်ပြုခြင်း",
    "ဖုန်းနံပါတ်",
    "အမည်",
    "ငွေပမာဏ",
    "အကြောင်းအရာ",
    "ပယ်ဖျက်မည်",
    "လုပ်ဆောင်မည်",
    "ကျပ်"
  ];
  List textEng = [
    "Transfer Confirm",
    "Phone Number",
    "Name",
    "Amount",
    "Reference",
    "Cancel",
    "Confirm",
    "MMK"
  ];
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void initState() {
    myControlleramout.text = widget.value3;
    myControllerref.text = widget.value4;
    myControllerphone.text = widget.value2;
    myControllername.text = widget.value1;
    checkLanguage();
    super.initState();
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

    final phoneNumber = new TextFormField(
      controller: myControllerphone,
      readOnly: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        // icon: const Icon(Icons.attach_money),
        labelText: (checklang == "Eng") ? textEng[1] : textMyan[1],
        hasFloatingPlaceholder: true,
        labelStyle: (checklang == "Eng")
            ? TextStyle(
                fontSize: 15,
                color: colorblack,
                height: 0,
                fontWeight: FontWeight.w300)
            : TextStyle(fontSize: 14, color: colorblack, height: 0),
        fillColor: colorblack,
      ),
    );

    final name = new TextFormField(
      controller: myControllername,
      readOnly: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: (checklang == "Eng") ? textEng[2] : textMyan[2],
        hasFloatingPlaceholder: true,
        labelStyle: (checklang == "Eng")
            ? TextStyle(
                fontSize: 15,
                color: colorblack,
                height: 0,
                fontWeight: FontWeight.w300)
            : TextStyle(fontSize: 14, color: Colors.black, height: 0),
        fillColor: colorblack,
      ),
    );

    final amount = new TextFormField(
      controller: myControlleramout,
      readOnly: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: (checklang == "Eng") ? textEng[3] : textMyan[3],
        hasFloatingPlaceholder: true,
        labelStyle: (checklang == "Eng")
            ? TextStyle(
                fontSize: 15,
                color: colorblack,
                height: 0,
                fontWeight: FontWeight.w300)
            : TextStyle(fontSize: 14, color: colorblack, height: 0),
        fillColor: colorblack,
      ),
    );

    final reference = new TextFormField(
      controller: myControllerref,
      readOnly: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: (checklang == "Eng") ? textEng[4] : textMyan[4],
        hasFloatingPlaceholder: true,
        labelStyle: (checklang == "Eng")
            ? TextStyle(
                fontSize: 15,
                color: colorblack,
                height: 0,
                fontWeight: FontWeight.w300)
            : TextStyle(fontSize: 14, color: colorblack, height: 0),
        fillColor: colorblack,
      ),
    );

    final cancelbutton = new OutlineButton(
      highlightedBorderColor: colorgreen,
      disabledBorderColor: colorgreen,
      splashColor: colorblack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: () async {
        this.alertmsg = '';
        Navigator.pop(context);
      },
      textColor: colorgreen,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: 43.0,
        child: Center(
          child: (checklang == "Eng")
              ? Text(
                  (checklang == "Eng") ? textEng[5] : textMyan[5],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                )
              : Text(
                  (checklang == "Eng") ? textEng[5] : textMyan[5],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
        ),
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
            receiverCode: "${widget.value2}",
            fromName: username,
            toName: "${widget.value1}",
            amount: "${widget.value3}",
            prevBalance: "",
            password: res,
            iv: iv,
            dm: dm,
            salt: salt,
            appType: "wallet");
        GoTransferResponse goTransferResponse = await goOpenAccount(
            '$link' + '/payment/goTransfer', goTransferRequest.toMap())
            .catchError((Object error){
              snackbarfalse(error.toString());
            });
        if (goTransferResponse.code == '0000') {
          isLoading = false;
          this.alertmsg = "";
          print(goTransferResponse.toString());
          var date = new DateFormat.yMMMMd('en_US')
              .format(DateTime.parse(goTransferResponse.transactionDate));
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => new TransferSuccessPage(
                  value: "${widget.value3}",
                  value1: goTransferResponse.bankRefNumber,
                  value2: date,
                  value3: goTransferRequest.toName));
          Navigator.of(context).push(route);
          snackbartrue(goTransferResponse.desc);
          setState(() {});
        } else {
          isLoading = false;
          snackbarfalse(goTransferResponse.desc);
          setState(() {});
          final form = _formKey.currentState;
          form.validate();
        }
      },
      color: colorgreen,
      textColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: 43.0,
        child: Center(
          child: (checklang == "Eng")
              ? Text(
                  (checklang == "Eng") ? textEng[6] : textMyan[6],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                )
              : Text(
                  (checklang == "Eng") ? textEng[6] : textMyan[6],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );

    var body = Container(
      color: bgcolor,
      key: _formKey,
      child: new ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          SizedBox(height: 10.0),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 3.0,
            child: Column(
              children: <Widget>[
                // SizedBox(height: 20.0),
                Center(
                  child: new Container(
                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                  ),
                ),
                SizedBox(height: 30.0),
                Center(
                  child: new Container(
                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                    child: phoneNumber,
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: new Container(
                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                    child: name,
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: new Container(
                    padding: EdgeInsets.only(left: 15.0, right: 10.0),
                    child: amount,
                  ),
                ),
                SizedBox(height: 20.0),
                widget.value4 == "" || widget.value4 == null
                    ? Container()
                    : Center(
                        child: new Container(
                          padding: EdgeInsets.only(left: 15.0, right: 10.0),
                          child: reference,
                        ),
                      ),
                widget.value4 == "" || widget.value4 == null
                    ? Container()
                    : SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Container(
                      // padding: EdgeInsets.only(left: 12.0),
                      child: cancelbutton,
                    ),
                    new Container(
                      // padding: EdgeInsets.only(left: 14.0),
                      child: transferbutton,
                    )
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          body,
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
      backgroundColor: Colors.white,
      appBar: new AppBar(
        //Application Bar
        elevation: 0.0,
        backgroundColor: colorgreen,
        centerTitle: true,
        title: (checklang == "Eng")
            ? Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              )
            : Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
      ),
      body: isLoading ? bodyProgress : body,
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