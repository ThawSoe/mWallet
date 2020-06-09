import 'dart:convert';
import 'dart:core';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/model/OpenAccountRequest.dart';
import 'package:nsb/model/RegisterUser.dart';
import 'package:nsb/model/RegisterUserResponse.dart';
import 'package:nsb/model/OpenAccountResponse.dart';
import 'package:nsb/model/WalletResponseData.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/utils/crypt_helper.dart';
import 'package:flutter/material.dart';
import 'package:nsb/framework/http_service.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nsb/constants/rout_path.dart' as routes;

class SignUpPage extends StatefulWidget {
  final String value;
  final String value1;

  SignUpPage({Key key, this.value, Key key1, this.value1}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FocusNode focusNode1;
  FocusNode focusNode2;
  FocusNode focusNode3;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String password = "";
  String confirmPassword = "";
  final phoneNo = TextEditingController();
  final names = TextEditingController();

  @override
  void initState() {
    phoneNo.text = '${widget.value}';
    super.initState();

    focusNode1 = FocusNode();
    focusNode2 = FocusNode();
    focusNode3 = FocusNode();
  }

  String name = '';
  int rKey;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  // @override
  // void dispose() {
  //   focusNode1.dispose();
  //   focusNode2.dispose();
  //   focusNode3.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                ClipPath(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.20,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromRGBO(40, 103, 178, 1),
                  ),
                  clipper: RoundedClipper(60),
                ),
                ClipPath(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromRGBO(40, 103, 178, 1),
                  ),
                  clipper: RoundedClipper(50),
                ),
                Positioned(
                    top: 10,
                    left: -30,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).size.height * 0.15) / 2),
                          color:
                              Color.fromRGBO(40, 103, 178, 1).withOpacity(0)),
                      child: Center(
                        child: Container(
                          child: GestureDetector(
                              onTap: () {
                                print("pressed");
                                Navigator.pop(context);
                              },
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: Icon(Icons.arrow_back,
                                      color: Color.fromRGBO(40, 103, 178, 1)))),
                        ),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15 - 50),
                  height: MediaQuery.of(context).size.height * 0.33,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height * 0.80) - 22,
            margin: EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Phone.No';
                      }
                    },
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Phone No",
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.022,
                          horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                    controller: phoneNo,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(focusNode1);
                    },
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Name';
                      }
                    },
                    onSaved: (String value) {
                      name = value;
                    },
                    obscureText: false,
                    controller: names,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Name",
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.022,
                          horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(focusNode1);
                    },
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  TextFormField(
                    validator: validatePassword,
                    onSaved: (String val) {
                      password = val;
                    },
                    focusNode: focusNode2,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Password",
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.022,
                          horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(focusNode3);
                    },
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  TextFormField(
                    validator: validatePassword,
                    onSaved: (String val) {
                      confirmPassword = val;
                    },
                    focusNode: focusNode3,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.022,
                          horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Container(
                    child: GestureDetector(
                        onTap: () async {
                          print("pressed");
                          _validateInputs();
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          _formKey.currentState.save();
                          print(phoneNo);
                          print('My Name: ' + name);
                          RegisterUser registeruser = new RegisterUser(
                              t1: phoneNo.text,
                              t2: name,
                              t3: 'DC001',
                              t4: '',
                              t9: '010',
                              t16: '',
                              t20: '');
                          print(registeruser.toString());
                          RegisterUserResponse response = await goLoginOTP(
                              '$linkapi' + '/chatting/api/v1/service001/registerUser',
                              registeruser.toMap());
                          if (response.syskey > 0) {
                            this.rKey = response.syskey;
                            final iv = AesUtil.random(16);
                            print("iv :" + iv);
                            final dm = AesUtil.random(16);
                            print("dm :" + dm);
                            final salt = AesUtil.random(16);
                            print("salt :" + salt);
                            String res =
                                AesUtil.encrypt(salt, iv, this.password);
                            print("res is :" + res);
                            final prefs = await SharedPreferences.getInstance();
                            String session = prefs.getString('sessionID');
                            print('Session ID Test: ' + session);
                            final key4 = 'userId';
                            final userId = phoneNo.text;
                            prefs.setString(key4, userId);
                            final key2 = 'name';
                            final name = names.text;
                            prefs.setString(key2, name);
                            print('saved  name $name');
                            OpenAccountRequest request = new OpenAccountRequest(
                                userID: this.phoneNo.text,
                                name: this.name,
                                nrc: "",
                                sessionID: '${widget.value1}',
                                sKey: response.syskey,
                                institutionCode: "",
                                field1: "",
                                field2: "",
                                region: 'All',
                                alreadyRegister: "",
                                deviceId: "",
                                regionNumber: "",
                                appVersion: "",
                                fcmToken: "",
                                phoneType: 'Android',
                                password:
                                    AesUtil.encrypt(salt, iv, this.password),
                                iv: iv,
                                dm: dm,
                                salt: salt);
                            OpenAccountResponse resAccount =
                                await goOpenAccount(
                                    '$link' +
                                        '/service001/openAccount',
                                    request.toMap());
                            if (resAccount.messageCode == '0000') {
                              print(resAccount.toString());
                              var route = new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new WalletPage(
                                          value: resAccount.userId,
                                          value1: name));
                              Navigator.of(context).push(route);
                            }
                            print(resAccount.toString());
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.065,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(40, 103, 178, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _value1 = false;
  bool _autoValidate = false;
  void _value1Changed(bool value) => setState(() => _value1 = value);
  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.length < 6)
      return 'Password must be atleast 6 digits';
    else
      return null;
  }

  Future<RegisterUserResponse> goLoginOTP(url, Map jsonMap) async {
    RegisterUserResponse p = new RegisterUserResponse();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = RegisterUserResponse.fromJson(json.decode(body.toString()));
    } catch (e) {}
    print(p.toMap());
    return p;
  }

  Future<OpenAccountResponse> goOpenAccount(url, Map jsonMap) async {
    OpenAccountResponse p = new OpenAccountResponse();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      print(body);
      p = OpenAccountResponse.fromJson(json.decode(body.toString()));
    } catch (e) {}
    print(p.toMap());
    return p;
  }
}

class RoundedClipper extends CustomClipper<Path> {
  var differenceInHeights = 0;
  RoundedClipper(int differenceInHeights) {
    this.differenceInHeights = differenceInHeights;
  }

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - differenceInHeights);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
