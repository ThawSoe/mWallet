import 'package:flutter/material.dart';

class PopUpPage extends StatefulWidget {
  State<StatefulWidget> createState() => new PopUpPageState();
}
class PopUpPageState  extends State<PopUpPage>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child:PopupMenuButton(
       itemBuilder: (BuildContext context){
       return [
       PopupMenuItem(child:Text('Language',style: TextStyle(color: Colors.black, fontSize: 16))),
       PopupMenuItem(child:Text('Version',style: TextStyle(color: Colors.black, fontSize: 16)),),
       ];
       },
     ),
    );
  }
}