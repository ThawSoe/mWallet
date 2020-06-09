import 'package:flutter/material.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkynetPayParViewSuccess extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;
  final String value3;
  final String value4;
  final String value5;

  SkynetPayParViewSuccess(
      {Key key,
      this.value,
      this.value1,
      this.value2,
      this.value3,
      this.value4,
      this.value5})
      : super(key: key);
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<SkynetPayParViewSuccess> {
  double c;

  String checklang = '';
  List textMyan = [
    "အသေးစိတ်အချက်အလက်",
    "အမှတ်စဉ်",
    "ကဒ်နံပါတ်​",
    "​ဇာတ်ကားနာမည်",
    "ငွေပမာဏ",
    "ဝန်​ဆောင်ခ",
    "စုစုပေါင်း ငွေပမာဏ",
    'လုပ်ဆောင်ခဲ့သည့်ရက်',
    "ပိတ်မည်",
  ];
  List textEng = [
    "Skynet Payment Success",
    "Bank Reference No.",
    "Card No.",
    "Movie Name",
    "Amount",
    "Bank Charges",
    "Total Amount",
    "Transaction Date",
    "CLOSE",
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

  @override
  void initState() {
    super.initState();
    checkLanguage();
    plus();
  }

  plus() {
    double a = double.parse("${widget.value3}");
    double b = double.parse("${widget.value4}");
    c = a + b;
    print(c);
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
        fontFamily: 'Montserrat', fontSize: 19.0, color: Colors.black);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Title is here',
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child: new Text(checklang == "Eng" ? textEng[0] : textMyan[0])),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.91,
                  height: 100,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15)),
                      color: Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text(
                        'Transaction with Reference Number\n ${widget.value} is in Accepted state.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    // height: MediaQuery.of(context).size.height * 1,
                    // width: MediaQuery.of(context).size.width * 1,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.91,
                  // height: 80,
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
                          child: Text(
                            checklang == "Eng" ? textEng[1] : textMyan[1],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, left: 10),
                          child: Text(
                            "${widget.value}",
                            style: style,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.91,
                  // height: 80,
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
                          child: Text(
                            checklang == "Eng" ? textEng[2] : textMyan[2],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, left: 10),
                          child: Text(
                            "${widget.value1}",
                            style: style,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.91,
                  // height: 80,
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
                          child: Text(
                            checklang == "Eng" ? textEng[3] : textMyan[3],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, left: 10),
                          child: Text(
                            "${widget.value2}",
                            style: style,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.91,
                  // height: 80,
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
                          child: Text(
                              checklang == "Eng" ? textEng[4] : textMyan[4],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              )),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, left: 10),
                          child: Text(
                            "${widget.value3}",
                            style: style,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.91,
                  // height: 80,
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
                          child: Text(
                              checklang == "Eng" ? textEng[5] : textMyan[5],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              )),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, left: 10),
                          child: Text(
                            "${widget.value4}",
                            style: style,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.91,
                  // height: 80,
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
                          child: Text(
                              checklang == "Eng" ? textEng[6] : textMyan[6],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              )),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, left: 10),
                          child: Text(
                            "$c",
                            style: style,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.91,
                  // height: 80,
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
                          child: Text(
                              checklang == "Eng" ? textEng[7] : textMyan[7],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              )),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 15.0, left: 10),
                          child: Text(
                            "${widget.value5}",
                            style: style,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WalletPage()),
                    );
                  },
                  child: Text(checklang == "Eng" ? textEng[8] : textMyan[8],
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      )),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
