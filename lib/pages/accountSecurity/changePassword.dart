import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/utils/crypt_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;

  ChangePassword({Key key, this.value, this.value1, this.value2})
      : super(key: key);
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final myoldpas = TextEditingController();
  final mynewpass = TextEditingController();
  final myconfirmpass = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String alertmsg = "";
  String password = "";
  String checklang = '';
  bool isLoading = false;
  List textMyan = [
    "လျှို့၀ှက်နံပါတ် ပြောင်းမည်",
    "လျှို့၀ှက်နံပါတ်အဟောင်း*",
    "လျှို့၀ှက်နံပါတ်အသစ်*",
    "လျှို့၀ှက်နံပါတ်အသစ်အတည်ပြု*",
    "အတည်ပြု"
  ];
  List textEng = [
    "Change Password",
    "Old Password *",
    "New Password *",
    "Confirm Password *",
    "Change"
  ];

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
    final oldPsw = new TextFormField(
      controller: myoldpas,
      keyboardType: TextInputType.number,
      obscureText: true,
      textInputAction: TextInputAction.next,
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
    final newPsw = new TextFormField(
      controller: mynewpass,
      keyboardType: TextInputType.number,
      obscureText: true,
      textInputAction: TextInputAction.next,
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
    final confirmPsw = new TextFormField(
      controller: myconfirmpass,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      obscureText: true,
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

    final changebutton = new RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: () async {
        if (mynewpass.text == myconfirmpass.text) {
          setState(() {
            isLoading = true;
          });
          final prefs = await SharedPreferences.getInstance();
          String userID = prefs.getString('userId');
          String sessionID = prefs.getString('sessionID');
          final iv = AesUtil.random(16);
          final dm = AesUtil.random(16);
          final salt = AesUtil.random(16);
          String res = AesUtil.encrypt(salt, iv, myoldpas.text);
          String newres = AesUtil.encrypt(salt, iv, mynewpass.text);
          String url = '$link' + "/service001/changePassword";
          Map<String, String> headers = {"Content-type": "application/json"};
          String json = '{ "password": "' +
              res +
              '", "newpassword":"' +
              newres +
              '", "userid":"' +
              userID +
              '", "sessionid":"' +
              sessionID +
              '", "iv":"' +
              iv +
              '", "dm":"' +
              dm +
              '", "salt":"' +
              salt +
              '"}';
          print(json);
          http.Response response =
              await http.post(url, headers: headers, body: json);
          int statusCode = response.statusCode;
          print(statusCode);
          // if (statusCode == 200) {
          String body = response.body;
          var data = jsonDecode(body);
          print(data);
          if (data["msgCode"] == "0000") {
            setState(() {
              isLoading = false;
              snackbartrue("Updated Successfully !");
              Future.delayed(const Duration(milliseconds: 2000), () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WalletPage()));
              });
            });
          } else {
            snackbarfalse(data["msgDesc"]);
            setState(() {
              isLoading = false;
            });
          }
        } else {
          snackbarfalse("Password must be same");
          setState(() {
            isLoading = false;
          });
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
                  (checklang == "Eng") ? textEng[4] : textMyan[4],
                  style: TextStyle(fontSize: 15),
                )
              : Text(
                  (checklang == "Eng") ? textEng[4] : textMyan[4],
                  style: TextStyle(fontSize: 14),
                ),
        ),
      ),
    );

    var pswchange = new Form(
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
                  SizedBox(height: 10.0),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: oldPsw,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: newPsw,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: confirmPsw,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 15.0, right: 10.0),
                      child: changebutton,
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 15.0, right: 10.0),
                      child: Center(
                          child: Text(
                              'Require Minimum Length ${widget.value} , Maximum Length ${widget.value1} , Number ${widget.value2}',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.blue))),
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
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          pswchange,
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
        body: isLoading ? bodyProgress : pswchange
        // body: new Form(
        //   key: _formKey,
        //   child: new ListView(
        //     children: <Widget>[
        //       SizedBox(height: 10.0),
        //       Container(
        //         padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        //         height: 440,
        //         child: Card(
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10.0),
        //           ),
        //           elevation: 3.0,
        //           child: ListView(
        //             padding: EdgeInsets.all(5.0),
        //             children: <Widget>[
        //               SizedBox(height: 10.0),
        //               Center(
        //                 child: new Container(
        //                   padding: EdgeInsets.only(left: 10.0, right: 10.0),
        //                   child: oldPsw,
        //                 ),
        //               ),
        //               SizedBox(height: 20.0),
        //               Center(
        //                 child: new Container(
        //                   padding: EdgeInsets.only(left: 10.0, right: 10.0),
        //                   child: newPsw,
        //                 ),
        //               ),
        //               SizedBox(height: 20.0),
        //               Center(
        //                 child: new Container(
        //                   padding: EdgeInsets.only(left: 10.0, right: 10.0),
        //                   child: confirmPsw,
        //                 ),
        //               ),
        //               SizedBox(height: 30.0),
        //               Center(
        //                 child: new Container(
        //                   padding: EdgeInsets.only(left: 15.0, right: 10.0),
        //                   child: changebutton,
        //                 ),
        //               ),
        //               SizedBox(height: 40.0),
        //               Center(
        //                 child: new Container(
        //                   padding: EdgeInsets.only(left: 15.0, right: 10.0),
        //                   child: Center(
        //                       child: Text(
        //                           'Require Minimum Length ${widget.value} , Maximum Length ${widget.value1} , Number ${widget.value2}',
        //                           style: TextStyle(
        //                               fontSize: 13,
        //                               fontWeight: FontWeight.w300,
        //                               color: Colors.blue))),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}
