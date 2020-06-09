import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/pages/skyNet/skynetConfirm.dart';
import 'package:nsb/pages/skyNet/skynetDetailPage.dart';
import 'package:nsb/pages/skyNet/skynetPage.dart';
import 'package:nsb/pages/skyNet/skynetPayParViewConfirm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zawgyi_converter/zawgyi_converter.dart';
import 'package:zawgyi_converter/zawgyi_detector.dart';

class skynetPayParView extends StatefulWidget {
  final String value;
  final String value1;
  final String value2;
  final String value3;
  final String value4;
  final String value5;
  final String value6;

  skynetPayParView(
      {Key key,
      this.value,
      this.value1,
      this.value2,
      this.value3,
      this.value4,
      this.value5,
      this.value6})
      : super(key: key);

  @override
  _skynetDetailPageState createState() => _skynetDetailPageState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Pay Per View '),
      Company(2, 'Monthly '),
    ];
  }
}

class _skynetDetailPageState extends State<skynetPayParView> {
  ZawgyiConverter zawgyiConverter = ZawgyiConverter();
  ZawgyiDetector zawgyiDetector = ZawgyiDetector();
  String alertmsg = "";
  String rkey = "";
  bool _isLoading;
  String checklang = '';
  List textMyan = [
    "Skynet ငွေပေးချေမှု",
    "ကဒ်နံပါတ်",
    "သက်တမ်းကုန်မည့် နေ့ရက်/အချိန်",
    "​ဇာတ်ကားနာမည်",
    "ပြီးဆုံးသည့် နေ့ရက်/အချိန်",
    "စတင်သုံးစွဲသည့် နေ့ရက်/အချိန်",
    "ပမာဏ",
    "ပက်​ကေ့ အမျိုးအစား",
    "ပြန်စမည်",
    "လုပ်ဆောင်မည်",
  ];
  List textEng = [
    "Skynet Payment",
    "Card No.",
    "Expiry Date Time",
    "Movie Name",
    "End Date Time",
    "Start Date Time",
    "Amount",
    "Package Type",
    "RESET",
    "SUBMIT",
  ];
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List contactList = new List();
  List monthList = new List();
  String account;
  String amount;
  String startdate1;
  String enddate1;
  String amount1;
  String id;
  String type1;
  String charge;
  String total;
  String chooseAccount;
  ListView dateList;
  String desc;
  String type2;
  var movieList = [];
  String bankcharge;

  List<DropdownMenuItem<String>> _items;
  List<Widget> _widgets;
  List<String> _listValues;
  List<String> myDown = [];
  List result;
  var items = List<dynamic>();
  String _btn1SelectedVal;
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(
            company.name,
            style: TextStyle(
                fontFamily: 'Montserrat', fontSize: 19.0, color: Colors.black),
          ),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
      if (_selectedCompany.name == "Monthly ") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => skynetDetailPage()));
      }
    });
  }

  void initState() {
    _listValues = new List<String>();
    super.initState();
    checkLanguage();
    getConfirm();
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
  }

  getmonth(String account) async {
    print(account);
    for (var i = 0; i < movieList.length; i++) {
      if (account == _items[i].value) {
        type1 = movieList[i]["moviename"];
        type2 = movieList[i]["moviecode"];
        startdate1 = movieList[i]["startdate"];
        enddate1 = movieList[i]["enddate"];
        amount1 = movieList[i]["amount"];
      }
      setState(() {
        type1 = type1;
        type2 = type2;
        startdate1 = startdate1;
        enddate1 = enddate1;
        amount1 = amount1;
        total = '$charge' + '$startdate1';
      });
    }
    print(startdate1);
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

  getConfirm() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    String url = '$link'+
        "/serviceskynet/getCatalogListAndAvailablePPV";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "userid": "' +
        userID +
        '", "sessionid":"' +
        sessionID +
        '", "life_cycle_state":"' +
        "${widget.value1}" +
        '", "provisioning_provider_identifier__alternative_code":"' +
        "${widget.value2}" +
        '", "subscription_identifier__number":"' +
        "${widget.value3}" +
        '","termed_service_identifier__alternative_code":"' +
        "${widget.value4}" +
        '"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      print(body);
      var data = jsonDecode(body);
      print(data);
      setState(() {
        movieList = data["movielist"];
        bankcharge = data["bankCharges"];
        id = data["usage_service_catalog_identifier__id"];
        desc = data["desc"];
      });
      setWidgets();
      setDefaults();
      this.alertmsg = desc;
      this._method1();
      print(alertmsg);
    } else {
      print("Connection Fail");
      this.alertmsg = desc;
      this._method1();
      print(alertmsg);
    }
  }

  void _method1() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(this.alertmsg),
      backgroundColor: Colors.blueAccent,
      duration: Duration(seconds: 1),
    ));
  }

  void setDefaults() {
    _listValues.add("1");
  }

  void setWidgets() {
    for (int i = 0; i < movieList.length; i++) {
      myDown.add(movieList[i]["moviename"]);
    }
  }

  void setMenuItems() {
    int count = 1;
    _items = new List<DropdownMenuItem<String>>();
    for (var i = 0; i < myDown.length; i++) {
      _items.add(new DropdownMenuItem(
          child: Text(
            myDown[i],
            style: TextStyle(
                fontFamily: 'Pyidaungsu', fontSize: 19.0, color: Colors.black),
          ),
          value: count.toString()));
      count++;
    }
  }

  Widget build(BuildContext context) {
    setMenuItems();
    _widgets = new List<Widget>();
    _widgets.add(new StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return new DropdownButton<String>(
          hint: Text("Choose Movie"),
          value: account,
          isExpanded: true,
          items: _items,
          onChanged: (String newValue) {
            setState(() {
              account = newValue;
              int select = int.parse(account);
              int downValue = select;
              chooseAccount = myDown[--downValue];
              getmonth(account);
            });
          });
    }));

    final style = TextStyle(
        fontFamily: 'Montserrat', fontSize: 19.0, color: Colors.black);
    final cardNo = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 8, 8, 10),
          child: Text(checklang == "Eng" ? textEng[1] : textMyan[1],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              )),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text("${widget.value5}", style: style),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));
    final expireDate = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
          child: Text(
            checklang == "Eng" ? textEng[2] : textMyan[2],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('${widget.value6}'.replaceAll("T", " "), style: style),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final amount = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
          child: Text(
            checklang == "Eng" ? textEng[6] : textMyan[6],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('$amount1'=="null" ? "" : '$amount1' + ".00 MMK", style: style),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final packageType = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
          child: Text(
            checklang == "Eng" ? textEng[7] : textMyan[7],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: DropdownButton(
            isExpanded: true,
            elevation: 8,
            value: _selectedCompany,
            items: _dropdownMenuItems,
            onChanged: onChangeDropdownItem,
          ),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final startDateTime = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 10),
          child: Text(
            checklang == "Eng" ? textEng[5] : textMyan[5],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('$startdate1'=="null" ? "" : '$startdate1'.replaceAll("T", " "), style: style),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final movieName = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 0),
          child: Text(
            checklang == "Eng" ? textEng[3] : textMyan[3],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _widgets.length,
            itemBuilder: (context, index) {
              return _widgets[index];
            },
          ),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final entdateTime = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 10),
          child: Text(
            checklang == "Eng" ? textEng[4] : textMyan[4],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text('$enddate1'=="null" ? "" : '$enddate1'.replaceAll("T", " "), style: style),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));
    final note = new Row(
      children: <Widget>[
        Container(
          child: Text(
            "Note:",
            style: TextStyle(color: Colors.green, fontSize: 15),
          ),
        ),
        Container(
          child: Text(
            "Including 5% Government commercial tax.",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        )
      ],
    );

    final cancelbutton = new RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: () async {
        this.alertmsg = '';
        Navigator.pop(context);
      },
      color: Colors.grey[300],
      textColor: Colors.white,
      child: Container(
        width: 120.0,
        height: 38.0,
        child: Center(
            child: Text(checklang == "Eng" ? textEng[8] : textMyan[8],
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ))),
      ),
    );

    final transferbutton = new RaisedButton(
      onPressed: () async{
        if(amount1==null){
       _scaffoldkey.currentState.showSnackBar(new SnackBar(
        content: new Text("Please Select Movie"),backgroundColor: Colors.red, duration: Duration(seconds: 1)));
        }else{
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => skynetPayParViewConfirm(
                      value: "${widget.value5}",
                      value1: '$type1',
                      value2: '$amount1',
                      value3: '$bankcharge',
                      value4: "${widget.value3}",
                      value5: '$type2',
                      value6: '$startdate1',
                      value7: '$enddate1',
                      value8: '$id',
                    )));
        }
      },
      color: Color.fromRGBO(40, 103, 178, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      textColor: Colors.white,
      child: Container(
        width: 120.0,
        height: 38.0,
        child: Center(
            child: Text(checklang == "Eng" ? textEng[9] : textMyan[9],
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ))),
      ),
    );

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: _scaffoldkey,
          backgroundColor: Colors.grey[200],
          appBar: new AppBar(
              //Application Bar
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Color.fromRGBO(40, 103, 178, 1),
              title: Text(
                checklang == "Eng" ? textEng[0] : textMyan[0],
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {},
                  iconSize: 25,
                  icon: Icon(
                    Icons.view_list,
                    color: Colors.white,
                  ),
                )
              ],
              leading: IconButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => skynetPage()));
                },
                iconSize: 25,
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              )),
          body: new Form(
            key: _formKey,
            child: new ListView(
              children: <Widget>[
                SizedBox(height: 5.0),
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 10.0),
                  height: 700,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5.0,
                    child: ListView(
                      padding: EdgeInsets.all(7.0),
                      children: <Widget>[
                        Center(
                          child: new Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: cardNo,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: new Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: expireDate,
                          ),
                        ),
                        Center(
                          child: new Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: packageType,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: new Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: movieName,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: new Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: startDateTime,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: new Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: entdateTime,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: new Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: amount,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Center(
                          child: new Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: note,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(left: 12.0),
                              child: cancelbutton,
                            ),
                            new Container(
                              padding: EdgeInsets.only(left: 14.0),
                              child: transferbutton,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
