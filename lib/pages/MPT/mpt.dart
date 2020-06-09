import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:native_contact_picker/native_contact_picker.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/pages/MPT/mptcomfirm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MPTPage extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;
  MPTPage({Key key, this.value, this.value1, this.value2}) : super(key: key);
  @override
  _MPTPageState createState() => _MPTPageState();
}

class _MPTPageState extends State<MPTPage> {
  final myphno = TextEditingController();
  final tophno = TextEditingController();
  final desc = TextEditingController();
  final NativeContactPicker _contactPicker = new NativeContactPicker();
  List amountList = ["1000", "3000", "5000", "10000", "30000"];
  String amount = '';
  String userID = '';
  String sId = '';
  String merchantID = '';
  String operatorType = "MPT";
  String checklang = '';
  bool _isvalidate = false;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List textMyan = [
    "ဖုန်းငွေဖြည့်သွင်းခြင်း",
    "အကောင့်နံပါတ်",
    "အော်ပရေတာ အမျိုးအစား",
    "ဖုန်းနံပါတ်",
    "ငွေပမာဏ",
    "ပြန်ရမည့်ငွေ :",
    "အကြောင်းအရာ",
    "ပြန်စမည်",
    "ထည့်သွင်းမည်",
    "ဖုန်းနံပါတ်​ရိုက်​ထည့်ပါ",
  ];
  List textEng = [
    "Mobile Top Up",
    "Mobile Number",
    "Choose Operator Type",
    "Phone Number",
    "Amount",
    "Cash Back :",
    "Description",
    "RESET",
    "SUBMIT",
    "Please enter phone number"
  ];

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

  @override
  void initState() {
    super.initState();
    myphno.text = "${widget.value2}";
    amount = amountList[0];
    checkLanguage();
  }

  readPayment() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    final url = '$link' + '/service002/readMessageSetting';
    var body = jsonEncode({
      "userID": userID,
      "sessionID": sessionID,
      "type": "1",
      "merchantID": "${widget.value1}"
    });

    http.post(Uri.encodeFull(url), body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    }).then((dynamic res) {
      var result = json.decode(res.body);
      print(result);
      if (result['code'] == "0000") {
        // snackbartrue("Successfully !");
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MptConfirm(
                      phno: userID,
                      type: "${widget.value}",
                      tophno: tophno.text,
                      amount: amount,
                      desc: desc.text,
                      merchantId: "${widget.value1}")));
        });
      } else {
        snackbarfalse(result['desc']);
      }
    }).catchError((error) {
      print("ServiceError" + error.code.toString());
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          checklang == "Eng" ? textEng[0] : textMyan[0],
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        backgroundColor: Color.fromRGBO(40, 103, 178, 1),
        centerTitle: true,
      ),
      body: ListView(
        key: _formKey,
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Card(
            elevation: 5.0,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 20),
                  child: TextFormField(
                    controller: myphno,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: checklang == "Eng" ? textEng[1] : textMyan[1],
                      hasFloatingPlaceholder: true,
                      labelStyle: (checklang == "Eng")
                          ? TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                              height: 0,
                              fontWeight: FontWeight.w300)
                          : TextStyle(
                              fontSize: 16, color: Colors.grey, height: 0),
                      fillColor: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Text(
                            checklang == "Eng" ? textEng[2] : textMyan[2],
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.only(left: 20.0, right: 10.0),
                          child: Card(
                            elevation: 10.0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: MediaQuery.of(context).size.height * 0.10,
                              child: Image.asset('assets/images/MPT.jpg'),
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  child: TextFormField(
                    controller: tophno,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () async {
                          var contact = await _contactPicker.selectContact();
                          print(contact);
                          var index = contact.toString().indexOf(':');
                          var value = contact.toString().substring(index + 1);
                          setState(() {
                            tophno.text = value.toString().replaceAll(" ", "");
                          });
                        },
                        icon: Icon(
                          Icons.account_circle,
                          size: 30,
                        ),
                        color: Colors.blue,
                      ),
                      labelText: checklang == "Eng" ? textEng[3] : textMyan[3],
                      errorText: _isvalidate
                          ? checklang == "Eng" ? textEng[9] : textMyan[9]
                          : null,
                      errorStyle: TextStyle(
                          wordSpacing: 1,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.red),
                      hasFloatingPlaceholder: true,
                      labelStyle: (checklang == "Eng")
                          ? TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              height: 0,
                              fontWeight: FontWeight.w300)
                          : TextStyle(
                              fontSize: 15, color: Colors.grey, height: 0),
                      fillColor: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        checklang == "Eng" ? textEng[4] : textMyan[4],
                        style: TextStyle(color: Colors.grey),
                      )),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  child: DropdownButton(
                    isExpanded: true,
                    items: amountList.map((location) {
                      return DropdownMenuItem(
                        child: Container(
                          width: 80,
                          child: Text(location),
                        ),
                        value: location.toString(),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        amount = newValue;
                        print(amount);
                      });
                    },
                    value: amount.toString(),
                    underline: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.green))),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        checklang == "Eng" ? textEng[5] : textMyan[5],
                        style: TextStyle(color: Colors.green),
                      )),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  child: TextFormField(
                    controller: desc,
                    decoration: InputDecoration(
                      labelText: checklang == "Eng" ? textEng[6] : textMyan[6],
                      hasFloatingPlaceholder: true,
                      labelStyle: (checklang == "Eng")
                          ? TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                              height: 0,
                              fontWeight: FontWeight.w300)
                          : TextStyle(
                              fontSize: 16, color: Colors.grey, height: 0),
                      fillColor: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                            child: (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[7]
                                        : textMyan[7],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[7]
                                        : textMyan[7],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
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
                              connectivityResult == ConnectivityResult.wifi) {
                            if (tophno.text == "" ||
                                tophno.text == null ||
                                tophno.text.isEmpty) {
                              _isvalidate = true;
                            } else {
                              _isvalidate = false;
                              readPayment();
                            }
                            setState(() {});
                          } else {
                            snackbarfalse("No Internet Connection !");
                          }
                        },
                        color: Color.fromRGBO(40, 103, 178, 1),
                        textColor: Colors.white,
                        child: Container(
                          width: 130.0,
                          height: 43.0,
                          child: Center(
                            child: (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[8]
                                        : textMyan[8],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[8]
                                        : textMyan[8],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 90)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
