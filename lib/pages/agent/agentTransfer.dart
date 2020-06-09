import 'dart:convert';
import 'package:nsb/Link.dart';
import 'package:nsb/framework/http_service.dart' as http;
import 'package:flutter/material.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/global.dart';
import 'package:nsb/model/ReadMessageRequest.dart';
import 'package:nsb/model/ReadMessageResponse.dart';
import 'package:nsb/pages/Transfer/transferconfirm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgentTransfer extends StatefulWidget {
  final String value1;
  final String value2;

  AgentTransfer({Key key, this.value1, Key key1, this.value2})
      : super(key: key);

  @override
  _AgentTransferState createState() => _AgentTransferState();
}

class _AgentTransferState extends State<AgentTransfer> {
  String alertmsg = "";
  String rkey = "";
  final myControllerPh = TextEditingController();
  final myControllerName = TextEditingController();
  final myControlleramout = TextEditingController();
  final myControllerref = TextEditingController();

  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String checklang = '';
  bool _isvalidate = false;
  List textMyan = [
    "ငွေလွှဲရန်",
    "ကိုယ်စားလှယ် ဖုန်းနံပါတ်",
    "ကိုယ်စားလှယ်အမည်",
    "ငွေပမာဏ",
    "အကြောင်းအရာ",
    "ငွေလွှဲမည်",
    "​ငွေပမာဏရိုက်​ထည့်​ပါ"
  ];
  List textEng = [
    "Transfer",
    "Agent Mobile Number",
    "Agent Name",
    "Amount",
    "Reference",
    "Transfer",
    "Please Fill amount"
  ];

  void initState() {
    checkLanguage();
    super.initState();
    myControllerPh.text = widget.value1;
    myControllerName.text = widget.value2;
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

  @override
  Widget build(BuildContext context) {
    final phoneNumber = new TextFormField(
      controller: myControllerPh,
      enabled: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
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
      controller: myControllerName,
      enabled: false,
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
            : TextStyle(fontSize: 14, color: colorblack, height: 0),
        fillColor: colorblack,
      ),
    );

    final amount = new TextFormField(
      controller: myControlleramout,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        suffixText: "MMK",
        errorText:
            _isvalidate ? checklang == "Eng" ? textEng[6] : textMyan[6] : null,
        errorStyle: TextStyle(
            wordSpacing: 1,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.red),
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
      // keyboardType: TextInputType.number,
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

    final transferbutton = new RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: () async {
        this.alertmsg = '';
        final prefs = await SharedPreferences.getInstance();
        String userID = prefs.getString('userId');
        String sessionID = prefs.getString('sessionID');
        myControlleramout.text.isEmpty
            ? _isvalidate = true
            : _isvalidate = false;
        setState(() {});
        if (myControlleramout.text == "" || myControlleramout.text == null) {
        } else {
          ReadMessageRequest readMessageRequest = new ReadMessageRequest(
            userID: userID,
            sessionID: sessionID,
            type: "12",
            merchantID: "",
          );
          ReadMessageResponse readMessageResponse = await goLogin(
                  '$link' + '/service002/readMessageSetting',
                  readMessageRequest.toMap())
              .catchError((Object error) {
            print(error.toString());
            snackbarfalse(error.toString());
          });
          if (readMessageResponse.code == '0000') {
            print(readMessageResponse.toString());
            var route = new MaterialPageRoute(
                builder: (BuildContext context) => new TransferConfirmPage(
                    value1: "${widget.value2}",
                    value2: "${widget.value1}",
                    value3: myControlleramout.text,
                    value4: myControllerref.text));
            Navigator.of(context).push(route);
          }
        }
      },
      color: colorgreen,
      textColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.99,
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

    return Scaffold(
      backgroundColor: bgcolor,
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
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
      body: new Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: phoneNumber,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: name,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: amount,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: reference,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: transferbutton,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<ReadMessageResponse> goLogin(url, Map jsonMap) async {
    ReadMessageResponse p = new ReadMessageResponse();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = ReadMessageResponse.fromJson(json.decode(body.toString()));
    } catch (e) {
      p.otpCode = Constants.responseCode_Error;
      p.otpMessage = e.toString();
    }
    print(p.toMap());
    return p;
  }
}
