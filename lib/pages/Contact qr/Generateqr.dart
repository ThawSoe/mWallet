import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:nsb/global.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/utils/crypt_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Generateqr extends StatefulWidget {
  @override
  _CashInConfirmState createState() => _CashInConfirmState();
}

class _CashInConfirmState extends State<Generateqr> {
  GlobalKey globalKey = new GlobalKey();
  String _scanBarcode = "";
  String _dataString = "Hello from this QR";
  String _inputErrorText;
  String res, id, user;
  String checklang = '';
  List textMyan = [
    "QR San ဖြင့် contact အပ်​ပါ။",
    "ပိတ်မည်"
  ];
  List textEng = ["Add contact with QR Scan", "Close"];
  
  void initState() {
    super.initState();
    checkLanguage();
    getinfo();
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

  getinfo() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String name = prefs.getString('name');
    id = userID;
    user = name;
    setState(() {
      _dataString = '{"contacts":"' + userID + '","name":"' + name + '"}';
      _inputErrorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        //Application Bar
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: colorgreen,
        title: Text(
            'QR',
            style: TextStyle(
                fontSize: 19.0,
                color: Colors.white,
                height: 1.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      body: new Form(
        key: globalKey,
        child: new ListView(
          children: <Widget>[
            Center(
              child: new Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
                child: Text('$user',
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.w500))),
            SizedBox(height: 15.0),
            Center(
                child: Text('$id',
                    style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.w500))),
            SizedBox(height: 30.0),
            Center(
                child: Text(checklang=="Eng" ? textEng[0] : textMyan[0],
                    style: TextStyle(fontSize: 15.0))),
            SizedBox(height: 30.0),
            Center(
                child: RepaintBoundary(
              child: QrImage(
                data: _dataString,
                backgroundColor: Colors.white,
                size: 240,
                gapless: true,
              ),
            )),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.99,
                  height: 43.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                    color: colorgreen,
                    elevation: 5.0,
                    splashColor: colorblack,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WalletPage()));
                    },
                    child: new Text(
                      checklang=="Eng" ? textEng[1] : textMyan[1],
                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                    ),
                    textColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
