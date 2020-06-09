import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/pages/MeterBill/meterBillSuccess.dart';
import 'package:nsb/pages/Transfer/transfersuccess.dart';
import 'package:nsb/pages/UtilityPayment/UtilityPaymentSuccess.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/pages/skyNet/skynetPayParViewSuccess.dart';
import 'package:nsb/pages/skyNet/skynetSuccess.dart';
import 'package:shared_preferences/shared_preferences.dart';

class skynetPayParViewConfirm extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;
  final String value3;
  final String value4;
  final String value5;
  final String value6;
  final String value7;
  final String value8;

  skynetPayParViewConfirm(
      {Key key,
      this.value,
      this.value1,
      this.value2,
      this.value3,
      this.value4,
      this.value5,
      this.value6,
      this.value7,
      this.value8})
      : super(key: key);

  @override
  _skynetConfirmPageState createState() => _skynetConfirmPageState();
}

class _skynetConfirmPageState extends State<skynetPayParViewConfirm> {
  String alertmsg = "";
  String rkey = "";
  List contactList = new List();
  String refno;
  double c;
  bool isLoading=false;
  String trandate;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String checklang = '';
  List textMyan = [
    "အတည်ပြုခြင်း",
    "ကဒ်နံပါတ်​",
    "​ဇာတ်ကားနာမည်",
    "ငွေပမာဏ",
    "ဝန်​ဆောင်ခ",
    "စုစုပေါင်း ငွေပမာဏ",
    "ပယ်ဖျက်မည်",
    "လုပ်ဆောင်မည်",
  ];
  List textEng = [
    "Confirmation",
    "Your Card No.",
    "Movie Name",
    "Amount",
    "Bank Charges",
    "Total Amount",
    "CANCEL",
    "CONFIRM",
  ];

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

  void initState() {
    super.initState();
    checkLanguage();
    plus();
  }

  plus() {
    double a = double.parse("${widget.value2}");
    double b = double.parse("${widget.value3}");
    c = a + b;
    print(c);
  }

  void _method1() {
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
          child: Text(checklang == "Eng" ? textEng[1] : textMyan[1],
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

    final moviename = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 5),
          child: Text(checklang == "Eng" ? textEng[2] : textMyan[2],
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

    final amount = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 5),
          child: Text(
            checklang == "Eng" ? textEng[3] : textMyan[3],
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

    final bankcharge = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 5),
          child: Text(
            checklang == "Eng" ? textEng[4] : textMyan[4],
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

    final totalamount = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 5),
          child: Text(checklang == "Eng" ? textEng[5] : textMyan[5],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              )),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('$c', style: style),
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
            child: Text(checklang == "Eng" ? textEng[6] : textMyan[6],
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
        String url = '$link'+
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
            "${widget.value2}" +
            '", "bankCharges":"' +
            "${widget.value3}" +
            '", "amount":"' +
            '$c' +
            '", "cardNo":"' +
            "${widget.value}" +
            '", "subscriptionno":"' +
            "${widget.value4}" +
            '","packagetype":"' +
            "ppv" +
            '","moviename":"' +
            "${widget.value1}" +
            '","moviecode":"' +
            "${widget.value5}" +
            '","startdate":"' +
            "${widget.value6}" +
            '","enddate":"' +
            "${widget.value7}" +
            '","usage_service_catalog_identifier__id":"' +
            "${widget.value8}" +
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
            trandate = data["transactionDate"];
            refno = data["bankRefNumber"];
          });
          if (data["code"] == Constants.responseCode_Success) {
            isLoading=false;
            alertmsg = data["desc"];
            this._method1();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SkynetPayParViewSuccess(
                          value: '$refno',
                          value1: "${widget.value}",
                          value2: "${widget.value1}",
                          value3: "${widget.value2}",
                          value4: "${widget.value3}",
                          value5: '$trandate',
                        )));
          } else {
            isLoading=false;
            this.alertmsg = data["desc"];
            this._method1();
          }
          print(contactList);
        } else {
          isLoading=false;
          print("Connection Fail");
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
          child: Text(checklang == "Eng" ? textEng[7] : textMyan[7],
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              )),
        ),
      ),
    );

      var skybody= new Form(
        key: _formKey,
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 5.0),
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 5.0),
              height: 580,
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
                        child: moviename,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: amount,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: bankcharge,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: totalamount,
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
          checklang == "Eng" ? textEng[0] : textMyan[0],
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading ? bodyProgress : skybody,
    );
  }
}
