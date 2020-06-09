import 'package:flutter/material.dart';
import 'package:nsb/constants/rout_path.dart' as routes;
import 'package:nsb/pages/Wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MPTSuccessPage extends StatefulWidget {
  final String amount;
  final String date;
  final String tno;
  final String toname;

  MPTSuccessPage(
      {Key key, this.amount, this.date, this.tno, this.toname})
      : super(key: key);

  @override
  _TransferSuccessPageState createState() => _TransferSuccessPageState();
}

class _TransferSuccessPageState extends State<MPTSuccessPage> {
 
  String checklang = '';
  List textMyan = [
    "ငွေပေးချေမှု ရလဒ်",
    "လုပ်ဆောင်မှုအောင်မြင်ပါသည်",
    "လုပ်ဆောင်ခဲ့သည်ရက်",
    "အမှတ်စဥ်",
    "အမည်",
    "ပိတ်မည်"
  ];
  List textEng = [
    "Payment Success",
    "Success",
    "Date",
    "Transcation No.",
    "Name",
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
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(40, 103, 178, 1),
        centerTitle: true,
        title: (checklang == "Eng")
            ? Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.w300),
              )
            : Text(
                (checklang == "Eng") ? textEng[0] : textMyan[0],
                style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.w300),
              ),
      ),
      body: new Form(
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
                        fontSize: 15.0, fontWeight: FontWeight.w400))),
            SizedBox(height: 30.0),
            Center(
                child: Text("${widget.amount}" + ".00 MMK",
                    style: TextStyle(
                        fontSize: 25.0, fontWeight: FontWeight.w400))),
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
                            (checklang == "Eng") ? textEng[2] : textMyan[2],
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            "${widget.date}",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w400),
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
                            (checklang == "Eng") ? textEng[3] : textMyan[3],
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          Text(
                            "${widget.tno}",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
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
                            "${widget.toname}",
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
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
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                  color: Color.fromRGBO(40, 103, 178, 1),
                  elevation: 5.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WalletPage()),
                    );
                  },
                  child: (checklang == "Eng")
                      ? Text(
                          (checklang == "Eng") ? textEng[5] : textMyan[5],
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),
                        )
                      : Text(
                          (checklang == "Eng") ? textEng[5] : textMyan[5],
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),
                        ),
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
