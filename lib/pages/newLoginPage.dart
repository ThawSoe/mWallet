import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/Test.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/constants/rout_path.dart' as routes;
import 'package:nsb/framework.dart/popUp.dart';
import 'package:nsb/global.dart';
import 'package:nsb/main.dart';
import 'package:nsb/model/Otp.dart';
import 'package:nsb/model/OtpResponse.dart';
import 'package:nsb/model/WalletResponseData.dart';
import 'package:nsb/framework/http_service.dart' as http;
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/pages/exchangerate/exchangerate.dart';
import 'package:nsb/pages/faq/faq.dart';
import 'package:nsb/pages/newOtpPage.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:device_id/device_id.dart';

class NewLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NewLoginPageState();
}

class NewLoginPageState extends State<NewLoginPage> {
  final myController = TextEditingController();
  bool _validate = false;
  bool isLoading = false;
  String _textString = 'Get OTP';
  String alertmsg = "";
  String rkey = "";
  String data = "";
  String checklang = "";
  String phoneNo = "";
  List textMyan = [
    "ကုဒ်ရယူပါ",
    "ဝင်​ရန်​",
    "တည်​​နေရာ",
    "​ငွေလွှဲနှုန်း",
    "​မေးခွန်း",
    "ဆက်​သွယ်​ရန်​",
    "ဖုန်းနံပါတ်​ရိုက်​ထည့်ပါ",
    "တစ်​ခါသုံးကုဒ်​နံပါတ်​ သင့်ဖုန်းသို့​ပေးပို့ပါမည်​"
  ];
  List textEng = [
    "Get OTP",
    "Login",
    "Location",
    "Exchange Rate",
    "FAQ",
    "Contact Us",
    "Please enter phone number",
    "One-Time Password(OTP) will be sent to this phone number."
  ];
  String deviceId = "";

  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  // 3. variable for track whether your device support local authentication means
  //    have fingerprint or face recognization sensor or not
  bool _hasFingerPrintSupport = false;
  // 4. we will set state whether user authorized or not
  String _authorizedOrNot = "Not Authorized";
  // 5. list of avalable biometric authentication supports of your device will be saved in this array
  List<BiometricType> _availableBuimetricType = List<BiometricType>();

  void initState() {
    checkLanguage();
    super.initState();
    _getDeviceId();
  }

  snackbartrue(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      elevation: 5.0,
      backgroundColor: colorgreen,
      duration: Duration(seconds: 2),
    ));
  }

  snackbarfalse(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      elevation: 5.0,
      backgroundColor: colorerror,
      duration: Duration(seconds: 2),
    ));
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

  void _doSomething(String text) {
    setState(() {
      _textString = text;
    });
  }

  Future<void> _getBiometricsSupport() async {
    // 6. this method checks whether your device has biometric support or not
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e.toString());
      snackbarfalse(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _hasFingerPrintSupport = hasFingerPrintSupport;
    });
  }

  Future<void> _getAvailableSupport() async {
    // 7. this method fetches all the available biometric supports of the device
    List<BiometricType> availableBuimetricType = List<BiometricType>();
    try {
      availableBuimetricType =
          await _localAuthentication.getAvailableBiometrics();
    } catch (e) {
      print(e.toString());
      snackbarfalse(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _availableBuimetricType = availableBuimetricType;
    });
  }

  Future<void> _authenticateMe() async {
    // 8. this method opens a dialog for fingerprint authentication.
    //    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate for Testing", // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true, // native process
      );
    } catch (e) {
      print(e.toString());
      snackbarfalse(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _authorizedOrNot = authenticated ? "Authorized" : "Not Authorized";
      if (_authorizedOrNot == "Authorized") {
        fingerPrintLogin();
      } else {}
    });
  }

  _getDeviceId() async {
    String device_id = await DeviceId.getID;
    deviceId = device_id;
    // var imei = await ImeiPlugin.getImei();
    //  var platformImei = await ImeiPlugin.getImei( shouldShowRequestPermissionRationale: false );
    //  var idunique = await ImeiPlugin.getId();
    print("DeviceID $deviceId");
    // print("IMEI $platformImei");
  }

  fingerPrintLogin() async {
    String url =
        '$linkapi' + "/AppService/module001/service001/checkDeviceIdV2";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "deviceID": "' + deviceId + '"}';
    http.Response response = await http
        .post(url, headers: headers, body: json)
        .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      String body = response.body;
      var data = jsonDecode(body);
      print(data);
      // if (data["messageCode"] == "0000") {
      //   snackbartrue(data['messageDesc']);
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => WalletPage()));
      // } else {
      //   snackbarfalse(data['messageDesc']);
      //   final form = _formKey.currentState;
      //   form.validate();
      // }
      if (data['code'] == "0000") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WalletPage()));
      } else {
        snackbarfalse(data['desc']);
        setState(() {});
      }
      setState(() {});
    }
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontFamily: 'Montserrat', fontSize: 15.0);
    final passwordField = Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 00.0, 0.0),
        child: SizedBox(
          height: 45.0,
          width: MediaQuery.of(context).size.width * 0.99,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(25.0)),
            child: new Text(
              (checklang == "Eng") ? textEng[0] : textMyan[0],
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            textColor: Colors.white,
            onPressed: () async {
              this.alertmsg = '';
              setState(() {
                myController.text.isEmpty
                    ? _validate = true
                    : _validate = false;
                phoneNo = myController.text;
                if (phoneNo.indexOf("7") == 0 && phoneNo.length == 9) {
                  phoneNo = '+959' + this.phoneNo;
                } else if (phoneNo.indexOf("9") == 0 && phoneNo.length == 9) {
                  phoneNo = '+959' + phoneNo;
                } else if (phoneNo.indexOf("+") != 0 &&
                    phoneNo.indexOf("7") != 0 &&
                    phoneNo.indexOf("9") != 0 &&
                    (phoneNo.length == 8 ||
                        phoneNo.length == 9 ||
                        phoneNo.length == 7)) {
                  this.phoneNo = '+959' + this.phoneNo;
                } else if (phoneNo.indexOf("09") == 0 &&
                    (phoneNo.length == 10 ||
                        phoneNo.length == 11 ||
                        phoneNo.length == 9)) {
                  phoneNo = '+959' + phoneNo.substring(2);
                } else if (phoneNo.indexOf("959") == 0 &&
                    (phoneNo.length == 11 ||
                        phoneNo.length == 12 ||
                        phoneNo.length == 10)) {
                  phoneNo = '+959' + phoneNo.substring(3);
                }
              });
              print('Phone no: ' + phoneNo);
              myController.text = phoneNo;
              if (myController.text == "" || myController.text == null) {
              } else {
                isLoading = true;
                Otp otp = new Otp(userID: phoneNo, type: '11', deviceID: '');
                OtpResponse res = await goLoginOTP(
                        '$link' + '/service001/getLoginOTP', otp.toMap())
                    .catchError(((Object error) {
                  print(error.toString());
                  snackbarfalse(error.toString());
                }));
                if (res.code == Constants.responseCode_Success) {
                  setState(() {
                    isLoading = false;
                  });
                  snackbartrue(res.desc);
                  this.rkey = res.rKey;
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new NewOtpPage(
                            value: myController.text, value1: rkey));
                    Navigator.of(context).push(route);
                  });
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  snackbarfalse(res.desc);
                  final form = _formKey.currentState;
                  form.validate();
                }
              }
            },
            color: _validate ? Colors.red : colorgreen,
          ),
        ));

    // final fingerprint = Padding(
    //   padding: EdgeInsets.fromLTRB(0.0, 20.0, 00.0, 0.0),
    //   child: SizedBox(
    //     height: 45.0,
    //     width: MediaQuery.of(context).size.width * 0.99,
    //     child: new RaisedButton(
    //       elevation: 5.0,
    //       onPressed: () {
    //         _getBiometricsSupport();
    //         _getAvailableSupport();
    //         BackButtonInterceptor.add(myInterceptor);
    //         _authenticateMe();
    //       },
    //       shape: new RoundedRectangleBorder(
    //           borderRadius: new BorderRadius.circular(10.0)),
    //       child: Icon(
    //         Icons.fingerprint,
    //         color: colorblack,
    //       ),
    //     ),
    //   ),
    // );

    var body = new Form(
      key: _formKey,
      child: Container(
        color: colorwhite,
        child: new ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: colorgreen, offset: Offset(0, 5), blurRadius: 3)
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: colorgreen,
                  foregroundColor: colorblack,
                  backgroundImage: AssetImage('assets/images/sss.png'),
                  radius: 50.0,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Center(
                child: Text(
              // checklang == "Eng" ? textEng[7] : textMyan[7],
              "Welcome from mWallet",
              style: TextStyle(
                  fontSize: 18.0,
                  color: colorblack,
                  fontWeight: FontWeight.w500,
                  wordSpacing: 1),
              textAlign: TextAlign.center,
            )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Center(
                child: Text(
              // checklang == "Eng" ? textEng[7] : textMyan[7],
              "Enter your mobile number. we will send \n you OTP to verify.",
              style: TextStyle(
                  fontSize: 16.0,
                  color: colorblack,
                  fontWeight: FontWeight.w400,
                  wordSpacing: 1),
              textAlign: TextAlign.center,
            )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 35.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Container(
                            //     width: MediaQuery.of(context).size.width * 0.18,
                            //     child: TextFormField(
                            //         obscureText: false,
                            //         style: style,
                            //         enabled: false,
                            //         decoration: InputDecoration(
                            //           contentPadding: new EdgeInsets.symmetric(
                            //               vertical: 14.0, horizontal: 10.0),
                            //           fillColor: colorblack,
                            //           hintText: "+959",
                            //           hintStyle: TextStyle(color: colorblack),
                            //           border: OutlineInputBorder(
                            //             borderSide: BorderSide(
                            //                 color: colorgreen, width: 1),
                            //             borderRadius: BorderRadius.circular(10.0),
                            //           ),
                            //         ))),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: TextFormField(
                                    textAlign: TextAlign.center,
                                    controller: myController,
                                    obscureText: false,
                                    autofocus: true,
                                    enabled: isLoading == true ? false : true,
                                    style: style,
                                    keyboardType: TextInputType.number,
                                    onChanged: (text) {
                                      _doSomething(text);
                                      text.toString().isEmpty
                                          ? _validate = true
                                          : _validate = false;
                                      setState(() {});
                                    },
                                    cursorColor: colorgreen,
                                    cursorWidth: 2.0,
                                    decoration: InputDecoration(
                                      focusColor: colorgreen,
                                      suffixIcon: Icon(Icons.check_circle,
                                          color: myController.text == ""
                                              ? colorwhite
                                              : colorgreen,
                                          size: 30),
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 10.0),
                                      errorText: _validate
                                          ? checklang == "Eng"
                                              ? textEng[6]
                                              : textMyan[6]
                                          : null,
                                      errorStyle: TextStyle(
                                          fontSize: 14,
                                          color: colorerror,
                                          fontWeight: FontWeight.w400,
                                          wordSpacing: 1),
                                      fillColor: colorblack,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: colorgreen,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorgreen),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    )))
                          ],
                        ),
                        passwordField,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              splashColor: colorblack,
              icon: Icon(Icons.fingerprint, size: 50, color: colorgreen),
              onPressed: () {
                _getBiometricsSupport();
                _getAvailableSupport();
                BackButtonInterceptor.add(myInterceptor);
                _authenticateMe();
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              child: Center(
                  child: Text(
                "Login with TouchID",
                style: TextStyle(
                    color: colorblack,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't not have an account ? ",
                    style: TextStyle(
                        color: colorgreen,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemsWidget()));
                    },
                    child: Text("Register Here",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: colorgreen,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic)),
                  )
                ],
              ),
            ),
            // Center(
            //   child: new Container(
            //     height: 40,
            //     padding: EdgeInsets.only(left: 30.0, right: 30.0),
            //     child: logincode,
            //   ),
            // ),
            // SizedBox(height: 20.0),
            // Center(
            //   child: Row(
            //     children: <Widget>[
            //       Container(
            //         padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
            //         width: MediaQuery.of(context).size.width * 0.60,
            //         child: passwordField,
            //       ),
            //       Container(
            //         padding: EdgeInsets.fromLTRB(40.0, 0.0, 20.0, 0.0),
            //         width: MediaQuery.of(context).size.width * 0.30,
            //         child: fingerprint,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      // ),
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

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        key: _scaffoldkey,
        appBar: new AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: new Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          elevation: 0.0,
          // backgroundColor: Color.fromRGBO(79, 255, 0, 0),
          backgroundColor: colorgreen,
          title: new Center(
            child: new Text(
              'mWallet',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  height: 1.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              elevation: 7,
              offset: Offset(0, 45),
              color: Colors.white,
              onSelected: (result) async {
                var selected = result;
                final prefs = await SharedPreferences.getInstance();
                if (selected == "Eng") {
                  setState(() {
                    checklang = "Eng";
                    prefs.setString("Lang", checklang);
                  });
                } else if (selected == "Myan") {
                  setState(() {
                    checklang = "Myan";
                    prefs.setString("Lang", checklang);
                  });
                } else if (selected == "Change") {
                  setState(() {
                    print("Change Language");
                  });
                } else {
                  print(selected);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 'Eng',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Container(
                        //     width: 30.0,
                        //     child: Image.asset('assets/images/eng.png')),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            "English",
                            style: TextStyle(color: colorblack),
                          ),
                        ),
                        Container(
                          child: Icon(
                            Icons.done_all,
                            color: checklang == "Eng" ? colorgreen : colorwhite,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Myan',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Container(
                        //     width: 30.0,
                        //     child: Image.asset('assets/images/myan.png')),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            "မြန်မာ",
                            style: TextStyle(color: colorblack),
                          ),
                        ),
                        Container(
                          child: Icon(
                            Icons.done_all,
                            color:
                                checklang == "Myan" ? colorgreen : colorwhite,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'PlayStore',
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            "Version 1.0.15",
                            style: TextStyle(color: colorgreen),
                          ),
                        )
                      ],
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        body: isLoading ? bodyProgress : body,
        drawer: _drawer(),
      ),
    );
  }

  Widget _drawer() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: new SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: new ListView(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(top: 30.0),
              ),
              _Login(),
              // Padding(padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),),
              // Divider(color: Colors.lightBlue,thickness: 1),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              _Location(),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              _ExchangeRate(),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              _Faq(),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
              _ContactUs(),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
              ),
            ],
          )),
    );
  }

  Widget _Login() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Container(
        // decoration: new BoxDecoration(
        //   image: new DecorationImage(
        //     image: new AssetImage('assets/images/bgcolor.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        height: 50.0,
        child: new RaisedButton(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
              side: BorderSide(color: colorgreen, width: 2.0)),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewLoginPage()));
          },
          color: colorwhite,
          textColor: colorgreen,
          child: Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                ),
              ),
              Icon(
                Icons.lock,
                color: colorgreen,
              ),
              new Padding(
                  padding: EdgeInsets.only(
                right: 15.0,
              )),
              (checklang == "Eng")
                  ? Text(
                      (checklang == "Eng") ? textEng[1] : textMyan[1],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          wordSpacing: 1),
                    )
                  : Text(
                      (checklang == "Eng") ? textEng[1] : textMyan[1],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          wordSpacing: 1),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _Faq() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Container(
        height: 50.0,
        child: new RaisedButton(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
              side: BorderSide(color: colorgreen, width: 2.0)),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FAQ()));
          },
          color: colorwhite,
          textColor: colorgreen,
          child: Row(
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.only(
                left: 10.0,
              )),
              Icon(
                Icons.message,
                color: colorgreen,
              ),
              new Padding(
                  padding: EdgeInsets.only(
                right: 15.0,
              )),
              Text(
                checklang == "Eng" ? textEng[4] : textMyan[4],
                style: TextStyle(
                    // decoration: new BoxDecoration(
                    //   image: new DecorationImage(
                    //     image: new AssetImage('assets/images/three.png'),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    color: colorgreen,
                    fontWeight: FontWeight.w400,
                    wordSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _Location() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Container(
        height: 50.0,
        child: new RaisedButton(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
              side: BorderSide(color: colorgreen, width: 2.0)),
          onPressed: () async {
            Navigator.of(context).pushNamed(routes.LocationPageRoute);
          },
          color: colorwhite,
          child: Row(
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.only(
                left: 10.0,
              )),
              Icon(
                Icons.location_on,
                color: colorgreen,
              ),
              new Padding(
                  padding: EdgeInsets.only(
                right: 15.0,
              )),
              Text(
                checklang == "Eng" ? textEng[2] : textMyan[2],
                style: TextStyle(
                    color: colorgreen,
                    fontWeight: FontWeight.w400,
                    wordSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ExchangeRate() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Container(
        height: 50.0,
        child: new RaisedButton(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
              side: BorderSide(color: colorgreen, width: 2.0)),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Exchanerate()));
          },
          color: colorwhite,
          child: Row(
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.only(
                left: 10.0,
              )),
              Icon(
                Icons.money_off,
                color: colorgreen,
              ),
              new Padding(
                  padding: EdgeInsets.only(
                right: 15.0,
              )),
              Text(
                checklang == "Eng" ? textEng[3] : textMyan[3],
                style: TextStyle(
                    color: colorgreen,
                    fontWeight: FontWeight.w400,
                    wordSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ContactUs() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Container(
        height: 50.0,
        child: new RaisedButton(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
              side: BorderSide(color: colorgreen, width: 2.0)),
          onPressed: () async {
            Navigator.of(context).pushNamed(routes.ContactPageRoute);
          },
          color: colorwhite,
          child: Row(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                ),
              ),
              Icon(
                Icons.import_contacts,
                color: colorgreen,
              ),
              new Padding(
                  padding: EdgeInsets.only(
                right: 15.0,
              )),
              Text(
                checklang == "Eng" ? textEng[5] : textMyan[5],
                style: TextStyle(
                    color: colorgreen,
                    fontWeight: FontWeight.w400,
                    wordSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<WalletResponseData> goLogin(url, Map jsonMap) async {
    WalletResponseData p = new WalletResponseData();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = WalletResponseData.fromJson(json.decode(body.toString()));
    } catch (e) {
      p.messageCode = Constants.responseCode_Error;
      p.messageDesc = e.toString();
    }
    print(p.toMap());
    return p;
  }

  Future<OtpResponse> goLoginOTP(url, Map jsonMap) async {
    OtpResponse p = new OtpResponse();
    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = OtpResponse.fromJson(json.decode(body.toString()));
    } catch (e) {
      p.code = Constants.responseCode_Error;
      p.desc = e.toString();
    }
    print(p.toMap());
    return p;
  }
}

// import android.os.Bundle

// import io.flutter.app.FlutterActivity
// import io.flutter.plugins.GeneratedPluginRegistrant

// class MainActivity: FlutterActivity() {
//   override fun onCreate(savedInstanceState: Bundle?) {
//     super.onCreate(savedInstanceState)
//     GeneratedPluginRegistrant.registerWith(this)
//   }
// }