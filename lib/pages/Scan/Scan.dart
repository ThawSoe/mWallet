import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nsb/pages/Scan/ScanPayment.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  GlobalKey globalKey = new GlobalKey();
  String _scanBarcode="";
  String alertmsg="";
  @override
  void initState() { 
    super.initState();
    scanBarcodeNormal();
  }
  void _method1(){
    _scaffoldkey.currentState.showSnackBar(new SnackBar(content: new Text(this.alertmsg),duration: Duration(seconds: 1)));
  }
  Future scanBarcodeNormal() async {
      String barcodeScanRes="";
      try {
      //  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      //     "#ff6666", "Cancel", true, ScanMode.QR,);
      barcodeScanRes = await scanner.scan();
      if(barcodeScanRes!= null){
        if(barcodeScanRes.substring(0,1)=="{"){
          var route = new MaterialPageRoute(
               builder: (BuildContext context) =>
              new ScanPayment(value:barcodeScanRes));
              Navigator.of(context).push(route);
        }else{
          print("haha");
        }
      }else{
        scanBarcodeNormal();
      }
      setState(() {
       _scanBarcode = barcodeScanRes;
        print(_scanBarcode);
        alertmsg=_scanBarcode;
        this._method1();
    });
      // } on PlatformException catch(ex){
      //   if(ex.code == BarcodeScanner.CameraAccessDenied){
      //     setState(() {
      //       alertmsg = "The permission was denied.";
      //     });
      //   }else{
      //     setState(() {
      //       alertmsg = "unknown error ocurred $ex";
      //     });
      //   }
      }on FormatException{
        setState(() {
          alertmsg = "Scan canceled, try again !";
          print(alertmsg);
        });
      }catch(e){
        alertmsg = "Unknown error $e";
      }
      print(barcodeScanRes);
      this._method1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:globalKey,
    );
  }
}