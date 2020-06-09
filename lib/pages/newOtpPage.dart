import 'dart:convert';
import 'package:condition/condition.dart';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/constants/rout_path.dart' as routes;
import 'package:nsb/framework.dart/popUp.dart';
import 'package:nsb/global.dart';
import 'package:nsb/model/CheckOTPRequestData.dart';
import 'package:nsb/model/Otp.dart';
import 'package:nsb/model/OtpResponse.dart';
import 'package:nsb/model/WalletResponseData.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/pages/signUp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nsb/framework/http_service.dart' as http;
// import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';

class NewOtpPage extends StatefulWidget {
  final String value;
  final String value1;

  NewOtpPage({Key key, this.value, Key key1, this.value1}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new NewOtpPageState();
}

class NewOtpPageState extends State<NewOtpPage> {
  final myPwdController = TextEditingController();
  String alertmsg = "";
  bool _isvalidate = false;
  String rkey = "";
  bool isLoading = false;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String checklang = '';
  List textMyan = [
    "သင်၏ကုဒ်ကိုရိုက်ထည့်ပါ",
    "သင်၏ဖုန်းနံပါတ်သို့ကုဒ်ပို့ပြီးပါပြီ",
    "အတည်ပြုကုဒ်",
    "၀င်ရန်",
    "OTP ကုဒ်​ရိုက်​ထည့်ပါ"
  ];
  List textEng = [
    "Enter Your OTP",
    "The OTP is already sent to your phone number",
    "OTP",
    "Next",
    "Please enter OTP Code"
  ];

  void initState() {
    checkLanguage();
    super.initState();
  }

  snackbartrue(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      backgroundColor: Colors.blueAccent,
      duration: Duration(seconds: 2),
    ));
  }

  snackbarfalse(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      backgroundColor: Colors.red,
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

  Verification(value) async {
    isLoading = true;
    this.alertmsg = '';
    CheckOTPRequestData otp = new CheckOTPRequestData(
        deviceID: '',
        fcmToken: "",
        otpCode: value,
        rKey: "${widget.value1}",
        sessionID: '',
        userID: "${widget.value}");

    WalletResponseData res1 =
        await goLogin('$link' + '/service001/login', otp.toMap())
            .catchError((Object error) {
      print(error.toString());
      snackbarfalse(error.toString());
    });
    if (res1.messageCode == Constants.responseCode_Success) {
      setState(() {
        isLoading = false;
      });
      snackbartrue(res1.messageDesc);
      print(res1.toString());
      final prefs = await SharedPreferences.getInstance();
      final key = 'sKey';
      final sKey = res1.sKey;
      prefs.setString(key, sKey);
      print('saved  Data $sKey');
      final key1 = 'accountNo';
      final accountNo = res1.accountNo;
      prefs.setString(key1, accountNo);
      final key3 = 'sessionID';
      final sessionID = res1.sessionID;
      prefs.setString(key3, sessionID);
      final key4 = 'userId';
      final userId = "${widget.value}";
      prefs.setString(key4, userId);
      final key2 = 'name';
      final name = res1.name;
      prefs.setString(key2, name);
      print('saved  name $name');
      final userData = 'userData';
      final WalletResponseData response = res1;
      prefs.setString(userData, json.encode(response.toJson()));
      Map responseData = json.decode(prefs.getString(userData));
      WalletResponseData store = WalletResponseData.fromJson(responseData);
      print(store.accountNo);
      print("ez");
      _scaffoldkey.currentState.removeCurrentSnackBar();
      var route = new MaterialPageRoute(
          builder: (BuildContext context) =>
              new WalletPage(value: "${widget.value}", value1: name));
      Navigator.of(context).push(route);
    } else if (res1.messageCode == '0009') {
      snackbartrue(res1.messageDesc);
      final prefs = await SharedPreferences.getInstance();
      final sessionID = res1.sessionID;
      prefs.setString('sessionID', sessionID);
      prefs.getString('sessionID');
      final userId = res1.userId;
      prefs.setString('userId', userId);
      prefs.getString('userId');
      final sKey = res1.sKey;
      prefs.setString('sKey', sKey);
      prefs.getString('sKey');
      final accNo = res1.accountNo;
      prefs.setString('accountNo', accNo);
      prefs.getString('accountNo');
      print('saved  Data $sessionID');
      print(res1.messageCode);
      var route = new MaterialPageRoute(
          builder: (BuildContext context) =>
              new SignUpPage(value: "${widget.value}", value1: sessionID));
      Navigator.of(context).push(route);
    } else {
      print('OTP Error');
      setState(() {
        isLoading = false;
      });
      snackbarfalse(res1.messageDesc);
      final form = _formKey.currentState;
      form.validate();
    }
  }

  Future _login() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //---------------------- For simple design --------------------
    final style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
    final passwordField = TextField(
      controller: myPwdController,
      autofocus: true,
      obscureText: false,
      style: style,
      enabled: isLoading == true ? false : true,
      keyboardType: TextInputType.number,
      onChanged: (text) {
        text.toString().isEmpty ? _isvalidate = true : _isvalidate = false;
        setState(() {});
      },
      cursorColor: colorgreen,
      cursorWidth: 2.0,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.lock),
        focusColor: colorgreen,
        errorText:
            _isvalidate ? checklang == "Eng" ? textEng[4] : textMyan[4] : null,
        errorStyle: (checklang == "Eng")
            ? TextStyle(
                fontSize: 14, color: Colors.red, fontWeight: FontWeight.w400)
            : TextStyle(
                fontSize: 13,
                color: Colors.red,
                fontWeight: FontWeight.w400,
                wordSpacing: 1),
        // hintText: (checklang == "Eng") ? textEng[2] : textMyan[2],
        contentPadding:
            new EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0),
        // hintStyle:
        //     TextStyle(fontSize: 12, color: Color.fromARGB(100, 90, 90, 90)),
        fillColor: Colors.black,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorgreen,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorgreen),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

    final loginButon = Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 00.0, 0.0),
        child: SizedBox(
            height: 45.0,
            width: MediaQuery.of(context).size.width,
            child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0)),
              color: colorgreen,
              child: (checklang == "Eng")
                  ? Text(
                      (checklang == "Eng") ? textEng[3] : textMyan[3],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )
                  : Text(
                      (checklang == "Eng") ? textEng[3] : textMyan[3],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
              textColor: Colors.white,
              onPressed: () async {
                myPwdController.text.isEmpty
                    ? _isvalidate = true
                    : _isvalidate = false;
                setState(() {});
                if (myPwdController.text == "" ||
                    myPwdController.text == null) {
                } else {
                  isLoading = true;
                  this.alertmsg = '';
                  CheckOTPRequestData otp = new CheckOTPRequestData(
                      deviceID: '',
                      fcmToken: "",
                      otpCode: myPwdController.text,
                      rKey: "${widget.value1}",
                      sessionID: '',
                      userID: "${widget.value}");

                  WalletResponseData res1 =
                      await goLogin('$link' + '/service001/login', otp.toMap());
                  if (res1.messageCode == Constants.responseCode_Success) {
                    setState(() {
                      isLoading = false;
                    });
                    snackbartrue(res1.messageDesc);
                    print(res1.toString());
                    final prefs = await SharedPreferences.getInstance();
                    final key = 'sKey';
                    final sKey = res1.sKey;
                    prefs.setString(key, sKey);
                    print('saved  Data $sKey');
                    final key1 = 'accountNo';
                    final accountNo = res1.accountNo;
                    prefs.setString(key1, accountNo);
                    final key3 = 'sessionID';
                    final sessionID = res1.sessionID;
                    prefs.setString(key3, sessionID);
                    final key4 = 'userId';
                    final userId = "${widget.value}";
                    prefs.setString(key4, userId);
                    final key2 = 'name';
                    final name = res1.name;
                    prefs.setString(key2, name);
                    print('saved  name $name');
                    final userData = 'userData';
                    final WalletResponseData response = res1;
                    prefs.setString(userData, json.encode(response.toJson()));
                    Map responseData = json.decode(prefs.getString(userData));
                    WalletResponseData store =
                        WalletResponseData.fromJson(responseData);
                    print(store.accountNo);
                    print("ez");
                    _scaffoldkey.currentState.removeCurrentSnackBar();
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new WalletPage(
                            value: "${widget.value}", value1: name));
                    Navigator.of(context).push(route);
                  } else if (res1.messageCode == '0009') {
                    snackbartrue(res1.messageDesc);
                    final prefs = await SharedPreferences.getInstance();
                    final sessionID = res1.sessionID;
                    prefs.setString('sessionID', sessionID);
                    prefs.getString('sessionID');
                    final userId = res1.userId;
                    prefs.setString('userId', userId);
                    prefs.getString('userId');
                    final sKey = res1.sKey;
                    prefs.setString('sKey', sKey);
                    prefs.getString('sKey');
                    final accNo = res1.accountNo;
                    prefs.setString('accountNo', accNo);
                    prefs.getString('accountNo');
                    print('saved  Data $sessionID');
                    print(res1.messageCode);
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new SignUpPage(
                            value: "${widget.value}", value1: sessionID));
                    Navigator.of(context).push(route);
                  } else {
                    print('OTP Error');
                    setState(() {
                      isLoading = false;
                    });
                    snackbarfalse(res1.messageDesc);
                    final form = _formKey.currentState;
                    form.validate();
                  }
                }
              },
            )));

    // final size = MediaQuery.of(context).size;

    // var body = new Form(
    //   key: _formKey,
    //   child: new ListView(
    //     children: <Widget>[
    //       Container(
    //         height: checklang == "Eng" ? 500 : 530,
    //           child: ListView(
    //             padding: EdgeInsets.all(5.0),
    //             children: <Widget>[
    //               Center(
    //                 child: new Container(
    //                   padding: EdgeInsets.only(left: 30.0, right: 30.0),
    //                 ),
    //               ),
    //               SizedBox(height: 10.0),
    //               // new Container(
    //               //   child: new Image.asset(
    //               //     'assets/images/mit.png',
    //               //     width: size.width,
    //               //     height: MediaQuery.of(context).size.height * 0.20,
    //               //   ),
    //               // ),
    //               // SizedBox(height: 20.0),
    //               // Center(
    //               //   child: (checklang == "Eng")
    //               //       ? Text((checklang == "Eng") ? textEng[0] : textMyan[0],
    //               //           style: TextStyle(fontSize: 30.0))
    //               //       : Text((checklang == "Eng") ? textEng[0] : textMyan[0],
    //               //           style: TextStyle(fontSize: 25.0)),
    //               // ),
    //               // SizedBox(height: 15.0),
    //               // Center(
    //               //     child: Text(
    //               //   (checklang == "Eng") ? textEng[1] : textMyan[1],
    //               // )),
    //               // SizedBox(height: 30.0),
    //               Center(
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     Container(
    //                       width: 180,
    //                       child: passwordField,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(height: 20.0),
    //               Center(
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     Container(
    //                       width: 280,
    //                       child: loginButon,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //       ),
    //     ],
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
              "Enter OTP",
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
              "We have sent you an SMS on ${widget.value} \n with 6 digits verification code.",
              style: TextStyle(
                  fontSize: 16.0,
                  color: colorblack,
                  fontWeight: FontWeight.w400,
                  wordSpacing: 1),
              textAlign: TextAlign.center,
            )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
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
                        // VerificationCodeInput(
                        //   autofocus: true,
                        //   // itemDecoration: BoxDecoration(shape: BoxShape.circle,color: colorgreen),
                        //   textStyle: TextStyle(
                        //       color: colorblack, fontWeight: FontWeight.w400),
                        //   itemSize: 50,
                        //   keyboardType: TextInputType.number,
                        //   length: 6,
                        //   onCompleted: (String value) {
                        //     print(value);
                        //     Verification(value);
                        //   },
                        // ),
                        passwordField,
                        loginButon
                      ],
                    ),
                  ),
                ),
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
            //Application Bar
            elevation: 0.0,
            backgroundColor: colorgreen,
            title: Text(
              "mWallet",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: isLoading ? bodyProgress : body),
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
