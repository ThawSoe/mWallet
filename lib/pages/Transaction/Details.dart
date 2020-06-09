import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatefulWidget {
  final String name;
  final String type;
  final String amount;
  final String refNo;
  final String date;
  final String phNo;
  DetailsPage(
      {Key key,
       this.name,
       this.type,
       this.phNo,
       this.date,
       this.refNo,
       this.amount})
      : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    print("name ==> " + widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Details",
          style: TextStyle(
            fontSize: 22,
            color: Color.fromRGBO(40, 103, 178, 1),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: Card(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    Text('Transaction Date',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.grey)),
                    SizedBox(height: 10),
                    Text(
                      widget.date,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
                    Text('Transaction Number',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.grey)),
                    SizedBox(height: 10),
                    Text(
                      widget.refNo,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
                    Text('Transaction Type',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.grey)),
                    SizedBox(height: 10),
                    Text(
                      widget.type,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
                    Text('Transaction To',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.grey)),
                    SizedBox(height: 10),
                    Row(children: [
                      Text(
                        widget.phNo,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      )
                    ]),
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
                    Text('Amount',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.grey)),
                    SizedBox(height: 10),
                    Row(children: [
                      Text(
                        widget.amount + "  MMK",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      SizedBox(width: 10),
                    ])
                  ]),
            ),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500)),
                    SizedBox(height: 10),
                    Text(
                      widget.type,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    )
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}
