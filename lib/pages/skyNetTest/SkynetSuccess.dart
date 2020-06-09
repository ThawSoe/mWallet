import 'package:flutter/material.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkynetSuccess extends StatefulWidget {
  final String payandmonth;
  final String cardNo;
  final String movieName;
  final String amount;
  final String bankcharges;
  final String totalamount;
  final String packageName;
  final String voucherType;
  final String startDate;
  final String endDate;
  final String mName;
  final String mID;
  final String subscriptionno;
  final String movieID;

  SkynetSuccess({
    Key key,
    this.payandmonth,
    this.subscriptionno,
    this.movieID,
    this.startDate,
    this.endDate,
    this.mName,
    this.mID,
    this.cardNo,
    this.movieName,
    this.amount,
    this.bankcharges,
    this.totalamount,
    this.packageName,
    this.voucherType,
  }) : super(key: key);

  @override
  _SkynetSuccessState createState() => _SkynetSuccessState();
}

class _SkynetSuccessState extends State<SkynetSuccess> {
  String checklang = '';
  List textMyan = [
    "အသေးစိတ်အချက်အလက်",
    "အမှတ်စဥ်",
    "ကဒ်နံပါတ်",
    "ပက်ကေ့နာမည်",
    "ဘောက်ချာအမျိုးအစား",
    "ငွေပမာဏ",
    "၀န်ဆောင်ခ",
    "စုစုပေါင်း ပမာဏ",
    "လုပ်ဆောင်ခဲ့သည့်ရက်",
    "ပိတ်မည်",
    "ဇာတ်ကားနာမည်"
  ];
  List textEng = [
    "Skynet Payment Success",
    "Bank Reference",
    "Card No.",
    "Package Name",
    "Voucher Type",
    "Amount",
    "Bank Charges",
    "Total Amount",
    "Transaction Date",
    "Close",
    "Movie Name"
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
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colorgreen,
          title: (checklang == "Eng")
              ? Text(
                  (checklang == "Eng") ? textEng[0] : textMyan[0],
                  style: TextStyle(fontSize: 19, color: Colors.white,fontWeight: FontWeight.w500),
                )
              : Text(
                  (checklang == "Eng") ? textEng[0] : textMyan[0],
                  style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.w500),
                ),
          centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 5),
            Image.asset(
              'assets/images/correct6.png',
              height: 70,
              width: 80,
            ),
            SizedBox(height: 15),
            Text(
              "Success",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            SizedBox(height: 25),
            Text(
              widget.totalamount + " MMK",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 25),
            Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[2]
                                        : textMyan[2],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[2]
                                        : textMyan[2],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                            SizedBox(height: 10),
                            Text(
                              widget.cardNo,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            )
                          ]),
                    ),
                    (widget.payandmonth == "2")
                        ? Container(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0.5),
                              ),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[10]
                                        : textMyan[10],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[10]
                                        : textMyan[10],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    widget.movieName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ]),
                          )
                        : Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(16),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (checklang == "Eng")
                                          ? Text(
                                              (checklang == "Eng")
                                                  ? textEng[3]
                                                  : textMyan[3],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey),
                                            )
                                          : Text(
                                              (checklang == "Eng")
                                                  ? textEng[3]
                                                  : textMyan[3],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                      SizedBox(height: 10),
                                      Text(
                                        widget.packageName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      )
                                    ]),
                              ),
                              Container(
                                padding: EdgeInsets.all(16),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      (checklang == "Eng")
                                          ? Text(
                                              (checklang == "Eng")
                                                  ? textEng[4]
                                                  : textMyan[4],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey),
                                            )
                                          : Text(
                                              (checklang == "Eng")
                                                  ? textEng[4]
                                                  : textMyan[4],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                      SizedBox(height: 10),
                                      Text(
                                        widget.voucherType,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      )
                                    ]),
                              )
                            ],
                          ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[5]
                                        : textMyan[5],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[5]
                                        : textMyan[5],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                            SizedBox(height: 10),
                            Text(
                              widget.amount,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            )
                          ]),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[6]
                                        : textMyan[6],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[6]
                                        : textMyan[6],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                            SizedBox(height: 10),
                            Row(children: [
                              Text(
                                widget.bankcharges,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                  child: Text(
                                '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              )),
                            ])
                          ]),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (checklang == "Eng")
                                ? Text(
                                    (checklang == "Eng")
                                        ? textEng[7]
                                        : textMyan[7],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                : Text(
                                    (checklang == "Eng")
                                        ? textEng[7]
                                        : textMyan[7],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                            SizedBox(height: 10),
                            Text(
                              widget.totalamount.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            )
                          ]),
                    ),
                  ]),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              width: double.infinity,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: colorgreen,
                child: (checklang == "Eng")
                    ? Text(
                        (checklang == "Eng") ? textEng[9] : textMyan[9],
                        style: TextStyle(fontSize: 15, color: Colors.white,fontWeight: FontWeight.w500),
                      )
                    : Text(
                        (checklang == "Eng") ? textEng[9] : textMyan[9],
                        style: TextStyle(fontSize: 14, color: Colors.white,fontWeight: FontWeight.w500),
                      ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WalletPage()),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
