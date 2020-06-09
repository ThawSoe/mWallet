import 'package:flutter/material.dart';

class ViewAllFilter extends StatefulWidget {
  @override
  _ViewAllFilterState createState() => _ViewAllFilterState();
}

class _ViewAllFilterState extends State<ViewAllFilter> {
  String phoneno;
  String alertmsg = "";
  bool _isLoading;
  String phoneNo = "";
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  var contactList = [];
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final startDate = new TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Start Date", hasFloatingPlaceholder: true,
        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
        fillColor: Colors.black87,
        //       suffixIcon: IconButton(
        //       padding: EdgeInsets.all(0),
        //       onPressed: (){
        //       print(Text("gg"));
        // },
        //             iconSize: 25,
        //             icon: Icon(Icons.contacts, color: Color.fromRGBO(40, 103, 178, 1),size: 30,),
        //           )
      ),
    );

    final endDate = new TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "End Date", hasFloatingPlaceholder: true,
        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
        fillColor: Colors.black87,
        //       suffixIcon: IconButton(
        //       padding: EdgeInsets.all(0),
        //       onPressed: (){
        //       print(Text("gg"));
        // },
        //             iconSize: 25,
        //             icon: Icon(Icons.contacts, color: Color.fromRGBO(40, 103, 178, 1),size: 30,),
        //           )
      ),
    );

    final nextButton = Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 0.0),
        child: SizedBox(
          height: 100.0,
          width: MediaQuery.of(context).size.width,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0)),
            child: new Text(
              'Search',
              style: TextStyle(fontSize: 18),
            ),
            textColor: Colors.white,
            onPressed: () async {},
            color: Color.fromRGBO(40, 103, 178, 1),
          ),
        ));

    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.grey[200],
      appBar: new AppBar(
        //Application Bar
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(40, 103, 178, 1),
        title: Text(
          'Transfer To',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              print(Text("ez"));
            },
            iconSize: 25,
            icon: Icon(
              Icons.view_list,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: new Form(
        child: new ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Container(
                  // padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  height: 100,
                  width: 210,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 1.0,
                    child: ListView(
                      padding: EdgeInsets.all(5.0),
                      children: <Widget>[
                        SizedBox(height: 0.0),
                        Center(
                          child: new Container(
                            padding: EdgeInsets.only(left: 22.0, right: 10.0),
                            child: startDate,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  height: 100,
                  width: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 1.0,
                    child: ListView(
                      padding: EdgeInsets.all(5.0),
                      children: <Widget>[
                        SizedBox(height: 0.0),
                        Center(
                          child: new Container(
                            padding: EdgeInsets.only(left: 22.0, right: 10.0),
                            child: endDate,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 65,
                    child: nextButton,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              height: 420,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 3.0,
                child: ListView.separated(
                  padding: EdgeInsets.all(5.0),
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  key: _formKey,
                  itemCount: contactList == null ? 0 : contactList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 30.0,
                        child: Text(
                            "${contactList[index]["name"]}".substring(0, 1)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      title: Text("${contactList[index]["name"]}",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      subtitle: Text("${contactList[index]["phone"]}"),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
