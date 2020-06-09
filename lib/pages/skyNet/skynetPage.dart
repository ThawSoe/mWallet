import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/pages/skyNet/skynetBeneficiary.dart';
import 'package:nsb/pages/skyNet/skynetConfirm.dart';
import 'package:nsb/pages/skyNet/skynetDetailPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class skynetPage extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;
  skynetPage({Key key, this.value, this.value1, this.value2}) : super(key: key);
  @override
  _skynetPageState createState() => _skynetPageState();
}

class _skynetPageState extends State<skynetPage> {
  String checklang = '';
  bool _isvalidate=false;
  var code;
  List textMyan = ["Skynet ငွေပေးချေမှု", "ကဒ်နံပါတ်","ကဒ်နံပါတ်ရိုက်​ထည့်​ပါ"];
  List textEng = ["Skynet Payment", "Card No", "Please Fill Card No"];
  final myControllerno = TextEditingController();
  @override
  void initState() {
    checkLanguage();
    super.initState();
    // if("${widget.value}" == "null"){
    //   myControllerno.text="";
    // }else{
    // myControllerno.text="${widget.value}";
    // }
    if(myControllerno.text == "null"){
      myControllerno.text="";
    }else{
      myControllerno.text = "${widget.value}";
    }
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
  
    _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Warning! "),
          content: new Text("Invalid Card No !"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

    getConfirm() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    String url = '$linkapi'+
        "/AppService/module001/serviceskynet/getServiceAndVoucher";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "userid": "' +
        userID +
        '", "sessionid":"' +
        sessionID +
        '", "cardno":"' +
        myControllerno.text +
        '"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      String body = response.body;
      var data = jsonDecode(body);
      setState(() {
        code= data["code"];
        if(code=="0000"){
             Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        skynetDetailPage(value: myControllerno.text)),
              );
        }
        else{
           this._showDialog();
        }
      });
    } else {
      print("Connection Fail");
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordField2 = new TextFormField(
      controller: myControllerno,
      style: TextStyle(
          fontFamily: 'Montserrat', fontSize: 19.0, color: Colors.black),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: (checklang == "Eng") ? textEng[1] : textMyan[1],
          hasFloatingPlaceholder: true,
          errorText: _isvalidate ? checklang=="Eng" ?textEng[2] : textMyan[2] : null,
          errorStyle: TextStyle(color: Colors.red,fontSize: 14,fontWeight: FontWeight.w400),
          labelStyle: (checklang == "Eng")
              ? TextStyle(fontSize: 18, color: Colors.black, height: 0)
              : TextStyle(fontSize: 17, color: Colors.black, height: 0),
          fillColor: Colors.black87,
          suffixIcon: IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () async{
              setState(() {
              myControllerno.text.isEmpty ? _isvalidate=true : _isvalidate=false;
              });
              if(_isvalidate==false){
              getConfirm();
              }

            },
            iconSize: 25,
            icon: Icon(
              Icons.check_circle_outline,
              color: Color.fromRGBO(40, 103, 178, 1),
              size: 40,
            ),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(40, 103, 178, 1),
        title: Text(
          (checklang == "Eng") ? textEng[0] : textMyan[0],
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SkynetBeneficiary()));
            },
            iconSize: 25,
            icon: Icon(
              Icons.view_list,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: new Form(
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              height: 130,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0,
                child: ListView(
                  padding: EdgeInsets.all(5.0),
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 22.0, right: 10.0),
                        child: passwordField2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 540,
              width: 500,
              child: new Image.asset('assets/images/skynetinfo3.png'),
            ),
          ],
        ),
      ),
    );
  }
}
