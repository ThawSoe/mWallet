import 'package:flutter/material.dart';
import 'package:nsb/constants/rout_path.dart' as routes;
import 'package:nsb/global.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferSuccessPage extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;
  final String value3;

  TransferSuccessPage(
      {Key key, this.value, this.value1, this.value2, this.value3})
      : super(key: key);

  @override
  _TransferSuccessPageState createState() => _TransferSuccessPageState();
}

class _TransferSuccessPageState extends State<TransferSuccessPage> {
  String checklang = '';
  List textMyan = [
    "ငွေလွှဲခြင်းရလဒ်",
    "လုပ်ဆောင်မှုအောင်မြင်ပါသည်",
    "ကျပ်",
    "လုပ်ဆောင်ခဲ့သည်ရက်",
    "အမှတ်စဥ်",
    "အမည်",
    "ပိတ်မည်"
  ];
  List textEng = [
    "Transfer Success",
    "Success",
    "MMK",
    "Date",
    "Transcation No",
    "Transfer To",
    "Close"
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        //Application Bar
        elevation: 0.0,
        backgroundColor: colorgreen,
        centerTitle: true,
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
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
      ),
      body: Container(
        color: Colors.white,
        child: new Form(
          child: new ListView(
            children: <Widget>[
              Center(
                child: new Container(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: new Image.asset(
                  'assets/images/correct6.png',
                  width: 80.0,
                  height: 80.0,
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                  child: Text((checklang == "Eng") ? textEng[1] : textMyan[1],
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold))),
              SizedBox(height: 30.0),
              Center(
                  child: Text("${widget.value}" + ".00 MMK",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w500))),
              SizedBox(height: 40.0),
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 3.0,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                        width: 170.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              (checklang == "Eng") ? textEng[3] : textMyan[3],
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              widget.value2,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      // new Row(
                      //   children: <Widget>[
                      //     Padding(
                      //       padding:
                      //           const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
                      //       child: new Text(
                      //           (checklang == "Eng") ? textEng[3] : textMyan[3],
                      //           style: TextStyle(
                      //             fontSize: 15.0,
                      //           )),
                      //     ),
                      //     Padding(
                      //       padding:
                      //           const EdgeInsets.fromLTRB(200.0, 10.0, 20.0, 0.0),
                      //       child: new Text("${widget.value2}",
                      //           style: TextStyle(
                      //               fontSize: 18.0, fontWeight: FontWeight.bold)),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 40.0,
                        width: 170.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              (checklang == "Eng") ? textEng[4] : textMyan[4],
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              widget.value1,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      // new Row(
                      //   children: <Widget>[
                      //     Padding(
                      //       padding:
                      //           const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
                      //       child: new Text(
                      //           (checklang == "Eng") ? textEng[4] : textMyan[4],
                      //           style: TextStyle(
                      //             fontSize: 15.0,
                      //           )),
                      //     ),
                      //     Padding(
                      //       padding:
                      //           const EdgeInsets.fromLTRB(170.0, 10.0, 20.0, 0.0),
                      //       child: new Text("${widget.value1}",
                      //           style: TextStyle(
                      //               fontSize: 18.0, fontWeight: FontWeight.bold)),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 40.0,
                        width: 170.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              (checklang == "Eng") ? textEng[5] : textMyan[5],
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            Text(
                              widget.value3,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      // new Row(
                      //   children: <Widget>[
                      //     Padding(
                      //       padding:
                      //           const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
                      //       child: new Text(
                      //           (checklang == "Eng") ? textEng[5] : textMyan[5],
                      //           style: TextStyle(
                      //             fontSize: 15.0,
                      //           )),
                      //     ),
                      //     Padding(
                      //       padding:
                      //           const EdgeInsets.fromLTRB(140.0, 10.0, 20.0, 0.0),
                      //       child: new Text("${widget.value3}",
                      //           style: TextStyle(
                      //               fontSize: 18.0, fontWeight: FontWeight.bold)),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 40.0, width: 170.0),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: Container(
                  width: 300,
                  height: 50,
                  child: RaisedButton(
                    splashColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: colorgreen,
                    elevation: 10.0,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WalletPage()),
                      );
                    },
                    child: (checklang == "Eng")
                        ? Text(
                            (checklang == "Eng") ? textEng[6] : textMyan[6],
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          )
                        : Text(
                            (checklang == "Eng") ? textEng[6] : textMyan[6],
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                    textColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
