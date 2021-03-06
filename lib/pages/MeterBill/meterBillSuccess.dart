import 'package:flutter/material.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeterBillSuccessPage extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;
  final String value3;
  final String value4;
  MeterBillSuccessPage(
      {Key key, this.value, this.value1, this.value2, this.value3, this.value4})
      : super(key: key);

  @override
  _MeterBillSuccessPageState createState() => _MeterBillSuccessPageState();
}

class _MeterBillSuccessPageState extends State<MeterBillSuccessPage> {
  String alertmsg = "";
  String rkey = "";
  final myControllerno = TextEditingController();
  final myControllername = TextEditingController();
  final myControlleramout = TextEditingController();
  final myControllerref = TextEditingController();
  String checklang = '';
  List textMyan = [
    "ငွေပေးချေမှုရလဒ်",
    "ငွေပေးချေမှု အောင်မြင်ပါသည်",
    "အမှတ်စဥ်",
    "အမည်",
    "ငွေပမာဏ",
    "လုပ်ဆောင်ခဲ့သည့်ရက်",
    "ပိတ်မည်"
  ];
  List textEng = [
    "Transaction Success",
    "Payment Successful",
    "Transcation No.",
    "Name",
    "Amount",
    "Transaction Date",
    "Close"
  ];
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void initState() {
    checkLanguage();
    super.initState();
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

  Widget build(BuildContext context) {
    final titleField = new Container(
        child: Row(children: <Widget>[
      Text(
        (checklang == "Eng") ? textEng[1] : textMyan[1],
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    ]));

    final loginField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(4, 2, 5, 10),
          child: Text(
            (checklang == "Eng") ? textEng[2] : textMyan[2],
            style: TextStyle(
                fontSize: 15, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Container(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          child: Text("${widget.value}",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colorblack)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));

    final passwordField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(4, 2, 5, 10),
          child: Text(
            (checklang == "Eng") ? textEng[3] : textMyan[3],
            style: TextStyle(
                fontSize: 15, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          child: Text("${widget.value4}",
              style: TextStyle(
                  fontSize: 15,
                  color: colorblack,
                  fontWeight: FontWeight.w500)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));

    final passwordField2 = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(4, 2, 5, 10),
          child: Text(
            (checklang == "Eng") ? textEng[4] : textMyan[4],
            style: TextStyle(
                fontSize: 15, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          child: Text("${widget.value2}" + ".00 MMK",
              style: TextStyle(
                  fontSize: 15,
                  color: colorblack,
                  fontWeight: FontWeight.w500)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));

    final transactiondate = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(4, 2, 5, 10),
          child: Text(
            (checklang == "Eng") ? textEng[5] : textMyan[5],
            style: TextStyle(
                fontSize: 15, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text("${widget.value3}",
              style: TextStyle(
                  fontSize: 15,
                  color: colorblack,
                  fontWeight: FontWeight.w500)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));

    final transferbutton = new RaisedButton(
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WalletPage()),
        );
      },
      color: colorgreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      textColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.99,
        height: 43.0,
        child: Center(
            child: Text((checklang == "Eng") ? textEng[6] : textMyan[6],
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500))),
      ),
    );

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: new AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: colorgreen,
        title: Text(
          (checklang == "Eng") ? textEng[0] : textMyan[0],
          style: TextStyle(
              fontSize: 19.0,
              color: Colors.white,
              height: 1.0,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: new Form(
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
                    Center(
                      child: new Container(
                        height: 80,
                        color: colorgreen,
                        padding: EdgeInsets.only(left: 30.0, right: 10.0),
                        child: titleField,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: loginField,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: passwordField,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: passwordField2,
                      ),
                    ),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: transactiondate,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: new Container(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: transferbutton,
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
