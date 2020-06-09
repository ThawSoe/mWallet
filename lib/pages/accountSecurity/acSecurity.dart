import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/accountSecurity/changePassword.dart';
import 'package:nsb/pages/accountSecurity/resetAlert.dart';
import 'package:nsb/pages/accountSecurity/resetPassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AcSecurityPage extends StatefulWidget {
  @override
  _AcSecurityPageState createState() => _AcSecurityPageState();
}

class _AcSecurityPageState extends State<AcSecurityPage> {
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String alertmsg = "";
  String checklang = '';
  List textMyan = [
    "အကောင့်လုံခြုံရေး",
    "လျှို့၀ှက်နံပါတ် ပြောင်းမည်",
    "လျှို့၀ှက်နံပါတ် မေ့သွားခြင်း"
  ];
  List textEng = ["Account Security", "Change Password", "Reset Password"];
  int minlength, maxlength, number;

  void _method1() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
        content: new Text(this.alertmsg), duration: Duration(seconds: 2)));
  }

  @override
  void initState() {
    checkLanguage();
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
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
      body: Container(
        key: _formKey,
        color: Colors.white,
        child: Column(children: <Widget>[
          ListTile(
            title: (checklang == "Eng")
                ? Text(
                    (checklang == "Eng") ? textEng[1] : textMyan[1],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                : Text(
                    (checklang == "Eng") ? textEng[1] : textMyan[1],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
            // title: Text("Change Password",
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.w300,
            //     )),
            trailing: Icon(Icons.chevron_right, color: colorgreen),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              String userID = prefs.getString('userId');
              String sessionID = prefs.getString('sessionID');
              String url = '$link' + "/service001/readPswPolicy";
              Map<String, String> headers = {
                "Content-type": "application/json"
              };
              String json = '{ "userID": "' +
                  userID +
                  '", "sessionID": "' +
                  sessionID +
                  '","pswminlength":"","pswmaxlength":"","spchar":"","upchar":"","lowerchar":"","pswno":"","msgCode":"","msgDesc":"" }';
              http.Response response =
                  await http.post(url, headers: headers, body: json);
              int statusCode = response.statusCode;
              if (statusCode == 200) {
                String body = response.body;
                var data = jsonDecode(body);
                print(data);
                if (data["msgCode"] == "0000") {
                  setState(() {
                    minlength = data["pswminlength"];
                    maxlength = data["pswmaxlength"];
                    number = data["pswno"];
                    // this.alertmsg = data["msgDesc"];
                    // this._method1();
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new ChangePassword(
                              value: '$minlength',
                              value1: '$maxlength',
                              value2: '$number',
                            ));
                    Navigator.of(context).push(route);
                  });
                } else {
                  this.alertmsg = data["msgDesc"];
                  this._method1();
                }
              } else {
                print("Connection Fail");
              }
            },
          ),
          Divider(
            color: Colors.blue,
            indent: 20,
            endIndent: 20,
          ),
          // ListTile(
          //   title: (checklang == "Eng")
          //       ? Text(
          //           (checklang == "Eng") ? textEng[2] : textMyan[2],
          //           style: TextStyle(
          //             fontSize: 15,
          //             fontWeight: FontWeight.w300,
          //           ),
          //         )
          //       : Text(
          //           (checklang == "Eng") ? textEng[2] : textMyan[2],
          //           style: TextStyle(
          //             fontSize: 14,
          //             fontWeight: FontWeight.w300,
          //           ),
          //         ),
          //   trailing: Icon(Icons.chevron_right,
          //       color: colorgreen),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => ResetAlert()),
          //     );
          //   },
          // ),
          // Divider(
          //   color: Colors.blue,
          //   indent: 20,
          //   endIndent: 20,
          // ),
        ]),
      ),
    );
  }
}
