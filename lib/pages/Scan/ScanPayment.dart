import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nsb/constants/rout_path.dart' as routes;
import 'package:nsb/global.dart';
import 'package:nsb/pages/Scan/ScanPaymentConfirm.dart';
import 'package:nsb/framework/http_service.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ScanPayment extends StatefulWidget {
  final String value;

  ScanPayment({Key key, this.value}) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<ScanPayment> {
  String alertmsg = "";
  String rkey = "";
  bool _isLoading;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  String ph, name, amount, ref;
  var results;
  String checklang = '';
  List textMyan = [
    "​ငွေ​ပေးသွင်းရန်​",
    "ဖုန်းနံပါတ် / ​စာရင်းနံပါတ်",
    "အမည်​",
    "​ငွေပမာဏ",
    "အကြောင်းအရာ",
    "​ပေးသွင်းမည်​"
  ];
  List textEng = ["Payment", "Payee", "Name", "Amount", "Reference", "Pay"];

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
    this._isLoading = false;
    super.initState();
    checkLanguage();
    results = jsonDecode(widget.value);
    print(results);
    ph = results["pay"];
    name = results["ref"];
    amount = results["amt"];
    ref = results["name"];
  }

  Widget build(BuildContext context) {

    final PhoneField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
          child: Text(
            checklang == "Eng" ? textEng[1] : textMyan[1],
            style: TextStyle(
                fontSize: 14, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0.0, 0),
          child:
              Text("$ph", style: TextStyle(fontSize: 15, color: colorblack,fontWeight: FontWeight.w500)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));

    final NameField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
          child: Text(
            checklang == "Eng" ? textEng[2] : textMyan[2],
            style: TextStyle(
                fontSize: 14, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0.0, 0.0),
          child: Text("$name",
              style: TextStyle(fontSize: 15, color: colorblack,fontWeight:FontWeight.w500)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));
    final AmountField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
          child: Text(
            checklang == "Eng" ? textEng[3] : textMyan[3],
            style: TextStyle(
                fontSize: 14, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0.0, 0.0),
          child: Text("$amount",
              style: TextStyle(fontSize: 15, color: colorblack,fontWeight: FontWeight.w500)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));
    final RefField = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
          child: Text(
            checklang == "Eng" ? textEng[4] : textMyan[4],
            style: TextStyle(
                fontSize: 14, color: colorblack, fontWeight: FontWeight.w300),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0.0, 0.0),
          child:
              Text("$ref", style: TextStyle(fontSize: 15, color: colorblack,fontWeight: FontWeight.w500)),
        ),
      ),
      Divider(
        color: Colors.blue,
        indent: 20,
        endIndent: 20,
      )
    ]));

    final transferbutton = new RaisedButton(
      splashColor: colorblack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: () async {
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new ScanPaymentConfirm(
                  value1: ph,
                  value2: name,
                  value3: amount,
                  value4: ref,
                ));
        Navigator.of(context).push(route);
      },
      color: colorgreen,
      textColor: Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        height: 43,
        child: Center(
            child: Text(checklang == "Eng" ? textEng[5] : textMyan[5],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
      ),
    );

    return Scaffold(
      backgroundColor: bgcolor,
      appBar: new AppBar(
          centerTitle: true,
          elevation: 2.0,
          backgroundColor: colorgreen,
          title: Text(
            checklang == "Eng" ? textEng[0] : textMyan[0],
            style: TextStyle(
              fontSize: 19.0,
              color: Colors.white,
              height: 1.0,
              fontWeight: FontWeight.w500,
            ),
          )),
      body: new Form(
        key: _formKey,
        child: new ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            SizedBox(height: 10.0),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10.0,
              child: Column(
                children: <Widget>[
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    ),
                  ),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: PhoneField,
                    ),
                  ),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: NameField,
                    ),
                  ),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: AmountField,
                    ),
                  ),
                  results["name"] == "" || results["name"] == null
                      ? Container()
                      : Center(
                          child: new Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: RefField,
                          ),
                        ),
                  SizedBox(height: 5.0),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: transferbutton,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
