import 'package:flutter/material.dart';
import 'package:nsb/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contact> {
  final String phone = "tel:09955795474";
  final String url = "http://www.mit.com.mm";
  String checklang = '';
  List textMyan = [
    "ဆက်သွယ်ရန်",
    "NSB မှကြိုဆိုပါသည်။",
    "၆၅၆ မဟာသုခိတာလမ်း၊ အင်းစိန်မြို့နယ်၊ ရန်ကုန်၊ မြန်မာ"
  ];
  List textEng = [
    "Contact Us",
    "Welcome to mWallet",
    "656 Maha Thukhita Road,\nInsein Township, Yangon, Myanmar"
  ];

  @override
  void initState() {
    checkLanguage();
    super.initState();
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

  _openPhone() async {
    print('Open Click');
    if (await canLaunch(phone)) {
      launch(phone);
    } else {
      print('Phone CAN NOT BE LAUNCHED');
    }
  }

  _openURL() async {
    print('Open Click');
    if (await canLaunch(url)) {
      launch(url);
    } else {
      print('URL CAN NOT BE LAUNCHED');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorgreen,
          title: (checklang == "Eng")
              ? Text(
                  (checklang == "Eng") ? textEng[0] : textMyan[0],
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                )
              : Text(
                  (checklang == "Eng") ? textEng[0] : textMyan[0],
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                    child: (checklang == "Eng")
                        ? Text(
                            (checklang == "Eng") ? textEng[1] : textMyan[1],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300),
                          )
                        : Text(
                            (checklang == "Eng") ? textEng[1] : textMyan[1],
                            style: TextStyle(fontSize: 14),
                          ),
                  ),
                ),
                new Card(
                  elevation: 10,
                  child: new Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width * 0.99,
                    decoration: new BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/location.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                new Card(
                  elevation: 3,
                  child: Column(
                    children: <Widget>[
                      new Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: colorgreen,
                              ),
                              Padding(padding: EdgeInsets.only(left: 15)),
                              Expanded(
                                child: (checklang == "Eng")
                                    ? Text(
                                        (checklang == "Eng")
                                            ? textEng[2]
                                            : textMyan[2],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
                                      )
                                    : Text(
                                        (checklang == "Eng")
                                            ? textEng[2]
                                            : textMyan[2],
                                        style: TextStyle(fontSize: 14),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Row(
                            children: <Widget>[
                              Icon(
                                Icons.public,
                                color: colorgreen,
                              ),
                              FlatButton(
                                child: Text(
                                  "http://www.mit.com.mm",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.black,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      fontWeight: FontWeight.w400),
                                ),
                                onPressed: () {
                                  _openURL();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Row(
                            children: <Widget>[
                              Icon(
                                Icons.phone,
                                color: colorgreen,
                              ),
                              FlatButton(
                                  onPressed: () {
                                    _openPhone();
                                  },
                                  child: Text(
                                    "09955795474",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.black),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      new Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Row(
                            children: <Widget>[
                              Icon(
                                Icons.mail,
                                color: colorgreen,
                              ),
                              Padding(padding: EdgeInsets.only(left: 15)),
                              Text(
                                'Fax: 01-123456789',
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
