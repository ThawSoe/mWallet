import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/global.dart';
import 'package:nsb/model/ReadMessageRequest.dart';
import 'package:nsb/model/ReadMessageResponse.dart';
import 'package:nsb/pages/MeterBill/meterBillConfirm.dart';
import 'package:nsb/pages/Transfer/transferconfirm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nsb/framework/http_service.dart' as http;

class MeterBillPage extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;
  MeterBillPage({Key key, this.value, this.value1, this.value2})
      : super(key: key);

  @override
  _MeterBillPageState createState() => _MeterBillPageState();
}

class _MeterBillPageState extends State<MeterBillPage> {
  String alertmsg = "";
  String rkey = "";
  bool _isLoading;
  final myControllerno = TextEditingController();
  final myControllername = TextEditingController();
  final myControlleramout = TextEditingController();
  final myControllerref = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  String checklang = '';
  bool _isvalidate=false;
  List textMyan = [
    "ငွေပေးသွင်းရန်",
    "ဖုန်းနံပါတ်",
    "အမည်",
    "ငွေပမာဏ",
    "ပေးသွင်းမည်",
    "ငွေပမာဏရိုက်​ထည့်​ပါ"
  ];
  List textEng = ["Payment", "Phone Number", "Name", "Amount", "Pay", "Please Fill amount"];
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void initState() {
    checkLanguage();
    myControllerno.text = widget.value2;
    myControllername.text = widget.value;
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

  Widget build(BuildContext context) {
    final titleField = new Container(
        child: Row(children: <Widget>[
      Text("Merchant Name:  ",
          style: TextStyle(fontSize: 15, color: Colors.white,fontWeight: FontWeight.w300)),
      Text(
        "${widget.value}",
        style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.w500),
      ),
    ]));

    final loginField = new TextFormField(
      controller: myControllerno,
      keyboardType: TextInputType.number,
      enabled: false,
      decoration: InputDecoration(
        labelText: (checklang == "Eng") ? textEng[1] : textMyan[1],
        hasFloatingPlaceholder: true,
        labelStyle: (checklang == "Eng")
            ? TextStyle(fontSize: 15, color: colorblack, height: 0,fontWeight: FontWeight.w300)
            : TextStyle(fontSize: 14, color: colorblack, height: 0),
        fillColor: colorblack,
      ),
    );

    final passwordField = new TextFormField(
      controller: myControllername,
      enabled: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: (checklang == "Eng") ? textEng[2] : textMyan[2],
        hasFloatingPlaceholder: true,
        labelStyle: (checklang == "Eng")
            ? TextStyle(fontSize: 15, color: colorblack, height: 0,fontWeight: FontWeight.w300)
            : TextStyle(fontSize: 14, color: colorblack, height: 0),
        fillColor: colorblack,
      ),
    );

    final passwordField2 = new TextFormField(
      controller: myControlleramout,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        suffixText: "MMK",
        errorText: _isvalidate ? checklang=="Eng" ? textEng[5] : textMyan[5] :null,
        labelText: (checklang == "Eng") ? textEng[3] : textMyan[3],
        hasFloatingPlaceholder: true,
        labelStyle: (checklang == "Eng")
            ? TextStyle(fontSize: 15, color: colorblack, height: 0,fontWeight: FontWeight.w300)
            : TextStyle(fontSize: 14, color: colorblack, height: 0),
        fillColor: colorblack,
      ),
    );

    final transferbutton = new RaisedButton(
      onPressed: () async {
        this.alertmsg = '';
        final prefs = await SharedPreferences.getInstance();
        String userID = prefs.getString('userId');
        String sessionID = prefs.getString('sessionID');
        setState(() {
        myControlleramout.text.isEmpty ? _isvalidate=true : _isvalidate=false;
        });
        if(_isvalidate==false){
        ReadMessageRequest readMessageRequest = new ReadMessageRequest(
          userID: userID,
          sessionID: sessionID,
          type: "1",
          merchantID: "${widget.value1}",
        );
        ReadMessageResponse readMessageResponse = await goLogin(
            '$link' + '/service002/readMessageSetting',
            readMessageRequest.toMap());
        if (readMessageResponse.code == '0000') {
          print(readMessageResponse.toString());
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => new meterBillConfirmPage(
                  value: myControlleramout.text,
                  value1: "${widget.value}",
                  value2: "${widget.value1}"));
          Navigator.of(context).push(route);
        }
        }
      },
      color: colorgreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      textColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width*0.99,
        height: 43.0,
        child: Center(
           child: (checklang == "Eng")
              ? Text(
                  (checklang == "Eng") ? textEng[4] : textMyan[4],
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                )
              : Text(
                  (checklang == "Eng") ? textEng[4] : textMyan[4],
                  style: TextStyle(fontSize: 14),
                ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: new AppBar(
          elevation: 2.0,
          backgroundColor: colorgreen,
          centerTitle: true,
          title: Text(
              (checklang == "Eng") ? textEng[0] : textMyan[0],
              style: TextStyle(
                  fontSize: 19.0,
                  color: Colors.white,
                  height: 1.0,
                  fontWeight: FontWeight.w500),
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
                    Center(
                      child: new Container(
                        height: 80,
                        color: colorgreen,
                        padding: EdgeInsets.only(left: 30.0, right: 10.0),
                        child: titleField,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: loginField,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: passwordField,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: passwordField2,
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
                      height: 20,
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
