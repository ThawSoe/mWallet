import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/pages/MPT/mptsuccess.dart';
import 'package:nsb/utils/crypt_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MptConfirm extends StatefulWidget {
  final String phno;
  final String type;
  final String tophno;
  final String amount;
  final String desc;
  final String merchantId;
  MptConfirm({Key key, this.phno, this.type, this.tophno,this.amount,this.desc,this.merchantId}) : super(key: key);
  @override
  _MptConfirmState createState() => _MptConfirmState();
}

class _MptConfirmState extends State<MptConfirm> {
  final myphno = TextEditingController();
  final mytype = TextEditingController();
  final mytophno = TextEditingController();
  final myamount = TextEditingController();
  final mydesc = TextEditingController();
  String checklang = '';
  bool isLoading = false;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String password = "";
  List textMyan = [
    "Topup Confirm",
    "အကောင့်နံပါတ်",
    "အော်ပရေတာ အမျိုးအစား",
    "ငွေဖြည့်မည့် ဖုန်းနံပါတ်",
    "ငွေပမာဏ",
    "အကြောင်းအရာ",
    "ပယ်ဖျက်မည်",
    "အတည်ပြုမည်"
  ];
  List textEng = [
    "Topup Confirm",
    "Mobile Number",
    "Operator Type",
    "Topup Mobile Number",
    "Amount",
    "Description",
    "CANCEL",
    "CONFIRM"
  ];

  checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    checklang = prefs.getString("Lang");
    print("Language $checklang");
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

  confirmTopup() async {
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
    final url = '$link' +
        '/payment/goMptTopup';
    var body = jsonEncode({
      "token": sessionID,
      "senderCode": userID,
      "merchantID": "${widget.merchantId}",
      "fromName": username,
      "toName": "${widget.type}",
      "amount": "${widget.amount}",
      "prevBalance": "",
      "password": res,
      "iv": iv,
      "dm": dm,
      "salt": salt
    });
    print(body);
    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(res.body);
      print(result);
      if (result['code'] == "0000") {
        isLoading = false;
        setState(() {
        });
        snackbartrue(result['desc']);
        var date =  new DateFormat.yMMMMd('en_US').format(DateTime.parse(result['transactionDate']) );
        print(date);
        Future.delayed(const Duration(milliseconds: 2000), (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MPTSuccessPage(
          amount : "${widget.amount}",date : date,tno : result['bankRefNumber'],toname : "${widget.type}"
        )));
        });
      } else {
        isLoading = false;
        setState(() {
        });
        snackbarfalse(result['desc']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkLanguage();
    myphno.text = "${widget.phno}";
    mytype.text = "${widget.type}";
    mytophno.text = "${widget.tophno}";
    myamount.text = "${widget.amount}";
    mydesc.text = "${widget.desc}";
  }

  @override
  Widget build(BuildContext context) {
    
    var body = new ListView(
        key: _formKey,
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Card(
            elevation: 5.0,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0,top: 20.0),
                  child: TextFormField(
                    controller: myphno,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
                      hasFloatingPlaceholder: true,
                      labelStyle:
                          (checklang == "Eng")
                          ? TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                              height: 0,
                              fontWeight: FontWeight.w300)
                          :
                          TextStyle(fontSize: 16, color: Colors.grey, height: 0),
                      fillColor: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height:20),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  child: TextFormField(
                    controller: mytype,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: checklang == "Eng" ? textEng[2] : textMyan[2],
                      hasFloatingPlaceholder: true,
                      labelStyle:
                          (checklang == "Eng")
                          ? TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                              height: 0,
                              fontWeight: FontWeight.w300)
                          :
                          TextStyle(fontSize: 16, color: Colors.grey, height: 0),
                      fillColor: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height:20),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  child: TextFormField(
                    controller: mytophno,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: checklang == "Eng" ? textEng[3] : textMyan[3],
                      hasFloatingPlaceholder: true,
                      labelStyle:
                          (checklang == "Eng")
                          ? TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                              height: 0,
                              fontWeight: FontWeight.w300)
                          :
                          TextStyle(fontSize: 16, color: Colors.grey, height: 0),
                      fillColor: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height:20),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  child: TextFormField(
                    controller: myamount,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: checklang == "Eng" ? textEng[4] : textMyan[4],
                      hasFloatingPlaceholder: true,
                      labelStyle:
                          (checklang == "Eng")
                          ? TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                              height: 0,
                              fontWeight: FontWeight.w300)
                          :
                          TextStyle(fontSize: 16, color: Colors.grey, height: 0),
                      fillColor: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height:20),
                "${widget.desc}"=="" ? Container():
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  child: TextFormField(
                    controller: mydesc,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: checklang == "Eng" ? textEng[5] : textMyan[5],
                      hasFloatingPlaceholder: true,
                      labelStyle:
                          (checklang == "Eng")
                          ? TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                              height: 0,
                              fontWeight: FontWeight.w300)
                          :
                          TextStyle(fontSize: 16, color: Colors.grey, height: 0),
                      fillColor: Colors.black87,
                    ),
                  ),
                ),
                "${widget.desc}"=="" ? Container():
                SizedBox(height:20),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        color: Colors.grey,
                        textColor: Colors.white,
                        child: Container(
                          width: 130.0,
                          height: 43.0,
                          child: Center(
                            child: 
                            (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng") ? textEng[6] : textMyan[6],
                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
                                  )
                                : Text(
                                    (checklang == "Eng") ? textEng[6] : textMyan[6],
                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
                                  ),
                          ),
                        ),
                      ),

                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () async {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi){
                                confirmTopup();
                              }else{
                                snackbarfalse("No Internet Connection !");
                              }
                        },
                        color: Color.fromRGBO(40, 103, 178, 1),
                        textColor: Colors.white,
                        child: Container(
                          width: 130.0,
                          height: 43.0,
                          child: Center(
                            child: 
                            (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng") ? textEng[7] : textMyan[7],
                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
                                  )
                                : Text(
                                    (checklang == "Eng") ? textEng[7] : textMyan[7],
                                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
                                  ),
                          ),
                        ),
                      ),
                    SizedBox(height:90)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
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
                  backgroundColor: Colors.amber,
                ),
              ))
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(checklang == "Eng" ? textEng[0]:textMyan[0],
        style: TextStyle(fontWeight: FontWeight.w300)) ,
        backgroundColor: Color.fromRGBO(40, 103, 178, 1),
        centerTitle: true,
      ),
      body: isLoading ? bodyProgress : body,
    );
  }
}