import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/pages/MeterBill/meterBillSuccess.dart';
import 'package:nsb/pages/Transfer/transfersuccess.dart';
import 'package:nsb/pages/UtilityPayment/UtilityPaymentSuccess.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/pages/skyNet/skynetSuccess.dart';
import 'package:shared_preferences/shared_preferences.dart';

class skynetConfirmPage extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;
  final String value3;
  final String value4;
  final String value5;
  final String value6;

  skynetConfirmPage(
      {Key key,
      this.value,
      this.value1,
      this.value2,
      this.value3,
      this.value4,
      this.value5,
      this.value6})
      : super(key: key);

  @override
  _skynetConfirmPageState createState() => _skynetConfirmPageState();
}

class _skynetConfirmPageState extends State<skynetConfirmPage> {
  String alertmsg = "";
  String rkey = "";
  bool isLoading = false;
  double c;
  List contactList = new List();
  String refno;
  String tranno;
  final myControllerno = TextEditingController();
  final myControllername = TextEditingController();
  final myControlleramout = TextEditingController();
  final myControllerref = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String checklang = '';
  List textMyan = ["အတည်ပြုခြင်း", "ကဒ်နံပါတ်​", "ပက်​ကေ့နာမည်", "​ဘောက်ချာ အမျိုးအစား", "ငွေပမာဏ", "ဝန်​ဆောင်ခ", "စုစုပေါင်း ငွေပမာဏ", "ပယ်ဖျက်မည်", "လုပ်ဆောင်မည်"];
  List textEng = ["Confirmation" ,"Your Card No.", "Package Name", "Voucher Type", "Amount", "Bank Charges", "Total Amount", "CANCEL", "CONFIRM"];

  void initState() {
    super.initState();
    checkLanguage();
    plus();
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

  plus() {
    double a = double.parse("${widget.value3}");
    double b = double.parse("${widget.value4}");
    c = a + b;
    print(c);
  }

  void _method1() {
    print("Snack Bar");
    print(this.alertmsg);
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
        content: new Text(this.alertmsg),backgroundColor: Colors.blueAccent, duration: Duration(seconds: 1)));
  }

  Widget build(BuildContext context) {
    final style = TextStyle(
        fontFamily: 'Montserrat', fontSize: 19.0, color: Colors.black);
    final cardNo = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 5),
          child: Text(checklang=="Eng" ? textEng[1] :textMyan[1],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              )),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "${widget.value}",
            style: style,
          ),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final expiraryDate = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 5),
          child: Text(checklang=="Eng" ? textEng[2] :textMyan[2],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              )),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "${widget.value1}",
            style: style,
          ),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final packageType = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 5),
          child: Text(
            checklang=="Eng" ? textEng[3] :textMyan[3],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "${widget.value2}",
            style: style,
          ),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final availablePackage = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 5),
          child: Text(
            checklang=="Eng" ? textEng[4] :textMyan[4],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "${widget.value3}",
            style: style,
          ),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final duration = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 5),
          child: Text(
            checklang=="Eng" ? textEng[5] :textMyan[5],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            "${widget.value4}",
            style: style,
          ),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final Amount = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 5),
          child: Text(checklang=="Eng" ? textEng[6] :textMyan[6],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              )),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text("$c", style: style),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final cancelbutton = new RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: () async {
        this.alertmsg = '';
        Navigator.pop(context);
      },
      color: Colors.grey[300],
      textColor: Colors.white,
      child: Container(
        width: 120.0,
        height: 38.0,
        child: Center(
            child: Text(checklang=="Eng" ? textEng[7] :textMyan[7],
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ))),
      ),
    );

    final transferbutton = new RaisedButton(
      onPressed: () async {
        setState(() {
          isLoading=true;
        });
        final prefs = await SharedPreferences.getInstance();
        String userID = prefs.getString('userId');
        String sessionID = prefs.getString('sessionID');
        String username = prefs.getString('name');
        String a = "M00012";
        String b = "SkyNet";
        String c = "${widget.value3}";
        String d = "${widget.value4}";
        String e = "${widget.value5}";
        String f = "${widget.value}";
        String g = "${widget.value1}";
        String h = "${widget.value2}";
        String i = "${widget.value6}";
        String j = "normal";
        String url = '$link' +
            "/payment/goMerchantPayment";
        Map<String, String> headers = {"Content-type": "application/json"};
        String json = '{ "token": "' +
            sessionID +
            '", "senderCode":"' +
            userID +
            '", "merchantID":"' +
            a +
            '", "fromName":"' +
            username +
            '", "toName":"' +
            b +
            '", "currentAmount":"' +
            c +
            '", "bankCharges":"' +
            d +
            '", "amount":"' +
            e +
            '", "cardNo":"' +
            f +
            '", "packageName":"' +
            g +
            '", "voucherType":"' +
            h +
            '", "subscriptionno":"' +
            i +
            '", "packagetype":"' +
            j +
            '"}';
        http.Response response =
            await http.post(url, headers: headers, body: json);
        int statusCode = response.statusCode;
        print(statusCode);
        if (statusCode == 200) {
          String body = response.body;
          print(body);
          var data = jsonDecode(body);
          print(data);
          setState(() {
            contactList = data["data"];
            refno = data["bankRefNumber"];
            tranno = data["transactionDate"];
          });
          if (data["code"] == Constants.responseCode_Success) {
            setState(() {
              isLoading=false;
            });
            this.alertmsg = data["desc"];
            this._method1();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SkynetSuccessPage(
                          value: '$refno',
                          value1: "${widget.value}",
                          value2: "${widget.value1}",
                          value3: "${widget.value2}",
                          value4: "${widget.value3}",
                          value5: "${widget.value4}",
                          value7: '$tranno',
                        )));
          } else {
            this.alertmsg = data["desc"];
            this._method1();
            setState(() {
              isLoading=false;
            });
          }
          print(contactList);
        } else {
          print("Connection Fail");
          setState(() {
              isLoading=false;
            });
        }
      },
      color: Color.fromRGBO(40, 103, 178, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      textColor: Colors.white,
      child: Container(
        width: 120.0,
        height: 38.0,
        child: Center(
          child: Text(checklang=="Eng" ? textEng[8] :textMyan[8],
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              )),
        ),
      ),
    );

    var skybody = new Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 5.0),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 5.0),
              height: 600,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0,
                child: ListView(
                  padding: EdgeInsets.all(2.0),
                  children: <Widget>[
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: cardNo,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: expiraryDate,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: packageType,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: availablePackage,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: duration,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Amount,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.only(left: 26.0),
                          child: cancelbutton,
                        ),
                        new Container(
                          padding: EdgeInsets.only(left: 26.0),
                          child: transferbutton,
                        )
                      ],
                    ),
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
          skybody,
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
      backgroundColor: Colors.grey[200],
      appBar: new AppBar(
        //Application Bar
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(40, 103, 178, 1),
        title: Text(
          checklang== "Eng" ? textEng[0] :textMyan[0],
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading ? bodyProgress : skybody,
    );
  }
}
