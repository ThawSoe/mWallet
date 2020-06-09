import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/UtilityPayment/UtilityPaymentSuccess.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utilitypayment.dart';
import 'package:http/http.dart' as http;

class UtilityPaymentConfirm extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;
  final String value3;
  final String value4;
  final String value5;
  final String value6;
  final String value7;
  final String value8;
  final String value9;
  final String value10;
  final String value11;
  final String value12;
  final String value13;

  UtilityPaymentConfirm(
      {Key key,
      this.value,
      this.value1,
      this.value2,
      this.value3,
      this.value4,
      this.value5,
      this.value6,
      this.value7,
      this.value8,
      this.value9,
      this.value10,
      this.value11,
      this.value12,
      this.value13})
      : super(key: key);
  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<UtilityPaymentConfirm> {
  String alertmsg = "";
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String checklang = '';
  bool isLoading = false;
  List textMyan = [
    "အတည်ပြုခြင်း",
    "အမှတ်စဥ်",
    "ဘေလ်နံပါတ်",
    "အမည်",
    "အခွန် ငွေပမာဏ",
    "ဒဏ်ကြေး",
    "ကော်မရှင် ငွေပမာဏ",
    "စုစုပေါင်း ငွေပမာဏ",
    "အခွန်ဌာန",
    "အခွန် အမျိုးအစား",
    "ကုန်ဆုံမည့် ရက်စွဲ",
    "နောက်ကျသည့် ရက်ပေါင်း",
    "ပယ်ဖျက်မည်",
    "လုပ်ဆောင်မည်"
  ];
  List textEng = [
    "Confirmation",
    "Reference Number",
    "Bill ID",
    "Customer Name",
    "Bill Amount",
    "Penalty Amount",
    "Commission Amount",
    "Total Amount",
    "Department Name",
    "Tax Description",
    "Due Date",
    "Belated Days",
    "CANCEL",
    "SUBMIT"
  ];

  void _method1() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
        content: new Text(this.alertmsg), duration: Duration(seconds: 2)));
  }

  @override
  void initState() {
    checkLanguage();
    super.initState();
  }

  Future _checking() async {
    setState(() {
      isLoading = false;
    });
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
    final style = TextStyle(
        fontFamily: 'Montserrat', fontSize: 15.0, color: Colors.black);

    var utilitybody = SingleChildScrollView(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 8.0, left: 10),
                      child: (checklang == "Eng")
                          ? Text(
                              (checklang == "Eng") ? textEng[1] : textMyan[1],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              (checklang == "Eng") ? textEng[1] : textMyan[1],
                              style: TextStyle(fontSize: 14),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                      child: Text("${widget.value1}", style: style),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 8.0, left: 10),
                      // child: Text(
                      //   'Bill ID',
                      //   style: TextStyle(
                      //       fontSize: 15, fontWeight: FontWeight.w300),
                      // ),
                      child: (checklang == "Eng")
                          ? Text(
                              (checklang == "Eng") ? textEng[2] : textMyan[2],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              (checklang == "Eng") ? textEng[2] : textMyan[2],
                              style: TextStyle(fontSize: 14),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                      child: Text("${widget.value2}", style: style),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 8.0, left: 10),
                      child: (checklang == "Eng")
                          ? Text(
                              (checklang == "Eng") ? textEng[3] : textMyan[3],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              (checklang == "Eng") ? textEng[3] : textMyan[3],
                              style: TextStyle(fontSize: 14),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                      child: Text("${widget.value3}", style: style),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 8.0, left: 10),
                      child: (checklang == "Eng")
                          ? Text(
                              (checklang == "Eng") ? textEng[4] : textMyan[4],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              (checklang == "Eng") ? textEng[4] : textMyan[4],
                              style: TextStyle(fontSize: 14),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                      child: Text("${widget.value4}", style: style),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 8.0, left: 10),
                      child: (checklang == "Eng")
                          ? Text(
                              (checklang == "Eng") ? textEng[5] : textMyan[5],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              (checklang == "Eng") ? textEng[5] : textMyan[5],
                              style: TextStyle(fontSize: 14),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                      child: Text("${widget.value5}", style: style),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 8.0, left: 10),
                      child: (checklang == "Eng")
                          ? Text(
                              (checklang == "Eng") ? textEng[6] : textMyan[6],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              (checklang == "Eng") ? textEng[6] : textMyan[6],
                              style: TextStyle(fontSize: 14),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                      child: Text("${widget.value6}", style: style),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 8.0, left: 10),
                      child: (checklang == "Eng")
                          ? Text(
                              (checklang == "Eng") ? textEng[7] : textMyan[7],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              (checklang == "Eng") ? textEng[7] : textMyan[7],
                              style: TextStyle(fontSize: 14),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                      child: Text("${widget.value7}", style: style),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 8.0, left: 10),
                      child: (checklang == "Eng")
                          ? Text(
                              (checklang == "Eng") ? textEng[8] : textMyan[8],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              (checklang == "Eng") ? textEng[8] : textMyan[8],
                              style: TextStyle(fontSize: 14),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                      child: Text("${widget.value8}", style: style),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 8.0, left: 10),
                      child: (checklang == "Eng")
                          ? Text(
                              (checklang == "Eng") ? textEng[9] : textMyan[9],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              (checklang == "Eng") ? textEng[9] : textMyan[9],
                              style: TextStyle(fontSize: 14),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                      child: Text("${widget.value9}", style: style),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 8.0, left: 10),
                      child: (checklang == "Eng")
                          ? Text(
                              (checklang == "Eng") ? textEng[10] : textMyan[10],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              (checklang == "Eng") ? textEng[10] : textMyan[10],
                              style: TextStyle(fontSize: 14),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                      child: Text("${widget.value10}", style: style),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.91,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 8.0, left: 10),
                      child: (checklang == "Eng")
                          ? Text(
                              (checklang == "Eng") ? textEng[11] : textMyan[11],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
                            )
                          : Text(
                              (checklang == "Eng") ? textEng[11] : textMyan[11],
                              style: TextStyle(fontSize: 14),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, left: 10),
                      child: Text("${widget.value11}", style: style),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          utilitybody,
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
        backgroundColor: colorgreen,
        centerTitle: true,
        title: (checklang == "Eng")
            ? Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 19, color: Colors.white),
              )
            : Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
      body: isLoading ? bodyProgress : utilitybody,
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context, UtilityPayment());
                },
                child: (checklang == "Eng")
                    ? Text(
                        (checklang == "Eng") ? textEng[12] : textMyan[12],
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      )
                    : Text(
                        (checklang == "Eng") ? textEng[12] : textMyan[12],
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                color: Colors.white,
                textColor: Colors.blue,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: RaisedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final prefs = await SharedPreferences.getInstance();
                  String userID = prefs.getString('userId');
                  String sessionID = prefs.getString('sessionID');
                  String username = prefs.getString('name');
                  String sKey = prefs.getString('sKey');
                  String url = '$link' + "/payment/goMerchantPayment";
                  Map<String, String> headers = {
                    "Content-type": "application/json"
                  };
                  String json = '{ "senderCode": "' +
                      userID +
                      '", "token":"' +
                      sessionID +
                      '", "currentAmount":"' +
                      "${widget.value4}" +
                      '", "bankCharges":"' +
                      "${widget.value6}" +
                      '", "amount":"' +
                      "${widget.value7}" +
                      '", "penalty":"' +
                      "${widget.value5}" +
                      '", "refNo":"' +
                      "${widget.value1}" +
                      '", "billId":"' +
                      "${widget.value2}" +
                      '", "fromName":"' +
                      username +
                      '", "toName":"' +
                      "${widget.value8}" +
                      '", "cusName":"' +
                      "${widget.value3}" +
                      '", "taxDesc":"' +
                      "${widget.value9}" +
                      '", "dueDate":"' +
                      "${widget.value10}" +
                      '", "vendorCode":"' +
                      "${widget.value13}" +
                      '", "merchantID":"' +
                      "${widget.value12}" +
                      '", "belateday":"' +
                      "${widget.value11}" +
                      '"}';
                  http.Response response =
                      await http.post(url, headers: headers, body: json);
                  int statusCode = response.statusCode;
                  print(statusCode);
                  if (statusCode == 200) {
                    setState(() {
                      isLoading = false;
                    });
                    String body = response.body;
                    print(body);
                    var data = jsonDecode(body);
                    print(data);
                    setState(() {});
                    if (data["code"] == "0000") {
                      setState(() {
                        isLoading = false;
                      });
                      this.alertmsg = data["desc"];
                      this._method1();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UtilityPaymentSuccess(
                                  value: "${widget.value7}",
                                  value1: data["bankRefNumber"],
                                  value2: data["transactionDate"],
                                  value3: "${widget.value3}",
                                  value4: "${widget.value1}",
                                  value5: "${widget.value2}")));
                    } else {
                      this.alertmsg = data["desc"];
                      this._method1();
                      setState(() {
                        isLoading = true;
                        new Future.delayed(new Duration(seconds: 1), _checking);
                      });
                    }
                  } else {
                    print("Connection Fail");
                    setState(() {
                      isLoading = true;
                    });
                  }
                },
                child: (checklang == "Eng")
                    ? Text(
                        (checklang == "Eng") ? textEng[13] : textMyan[13],
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      )
                    : Text(
                        (checklang == "Eng") ? textEng[13] : textMyan[13],
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                color: colorgreen,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
