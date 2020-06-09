import 'package:flutter/material.dart';
class PaymentPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new PaymentState();
}
class PaymentState extends State<PaymentPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: new AppBar(//Application Bar
              elevation: 0.0,
              backgroundColor:Colors.purple[900],
              title: new Center(child:new Text('Payment', style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
              height: 1.0,
              fontWeight: FontWeight.w600),),),
              actions: <Widget>[
                new IconButton(icon: new Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ), onPressed: (){
                })
              ],
            ),
    );
  }
}