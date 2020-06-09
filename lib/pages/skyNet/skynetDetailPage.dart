import 'dart:convert';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/pages/MeterBill/meterBillSuccess.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:nsb/pages/newLoginPage.dart';
import 'package:nsb/pages/skyNet/skynetBeneficiary.dart';
import 'package:nsb/pages/skyNet/skynetConfirm.dart';
import 'package:nsb/pages/skyNet/skynetPage.dart';
import 'package:nsb/pages/skyNet/skynetPayParView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class skynetDetailPage extends StatefulWidget {
  final String value;

  skynetDetailPage({Key key, this.value}) : super(key: key);

  @override
  _skynetDetailPageState createState() => _skynetDetailPageState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Monthly '),
      Company(2, 'Pay Per View '),
    ];
  }
}

class _skynetDetailPageState extends State<skynetDetailPage> {
  String alertmsg = "";
  String rkey = "";
  bool _isLoading;
  final myControllerno = TextEditingController();
  final myControllername = TextEditingController();
  final myControlleramout = TextEditingController();
  final myControllerref = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List contactList = new List();
  List monthList = new List();
  String contactList1;
  String date1;
  String package;
  String account;
  String month;
  String amount;
  String amount1;
  String type1;
  String charge;
  String total;
  String provisioning;
  String termed;
  String lifeCycle;
  String chooseAccount;
  ListView dateList;

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
  bool isLoading = true;

  String checklang = '';
  List textMyan = [
    "Skynet ငွေပေးချေမှု",
    "ကဒ်နံပါတ်",
    "သက်တမ်းကုန်မည့် နေ့ရက်/အချိန်",
    "ပက်​ကေ့ အမျိုးအစား",
    "ပက်​ကေ့နာမည်",
    "​ကြာမြင့်ချိန်",
    "ပမာဏ",
    "ပြန်စမည်",
    "လုပ်ဆောင်မည်"
  ];
  List textEng = [
    "Skynet Payment",
    "Card No.",
    "Expirary Date Time",
    "Package Type",
    "Available Packages",
    "Duration",
    "Amount",
    "RESET",
    "SUBMIT"
  ];

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

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
      if (_selectedCompany.name == "Pay Per View ") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => skynetPayParView(
                    value1: '$lifeCycle',
                    value2: '$provisioning',
                    value3: '$contactList1',
                    value4: '$termed',
                    value5: "${widget.value}",
                    value6: '$date1')));
      }
    });
  }

  // static const menuItems1 = <String>[
  //   'Monthly ',
  //   'Pay Per View ',
  // ];

  // final List<DropdownMenuItem<String>> _dropDownMenuItems1 = menuItems1
  //     .map(
  //       (String value) => DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value,style: TextStyle(fontFamily:'Montserrat', fontSize:19.0,color: Colors.black),),
  //       ),
  //     )
  //     .toList();

  void initState() {
    _listValues = new List<String>();
    super.initState();
    getConfirm();
    checkLanguage();
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;
  }

  getmonth(String account) async {
    print(account);
    for (var i = 0; i < contactList.length; i++) {
      if (account == _items[i].value) {
        type1 = contactList[i]["alternative_code"];
        amount1 = contactList[i]["value"];
      }
      setState(() {
        type1 = type1;
        amount1 = amount1;
        total = '$charge' + '$amount1';
      });
    }
  }

  getConfirm() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    String a = "${widget.value}";
    String url = '$linkapi'+
        "/AppService/module001/serviceskynet/getServiceAndVoucher";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "userid": "' +
        userID +
        '", "sessionid":"' +
        sessionID +
        '", "cardno":"' +
        a +
        '"}';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      String body = response.body;
      print(body);
      var data = jsonDecode(body);
      print(data);
      date1 = data["expirydate"];
      package = data["currentpackage"];
      charge = data["bankCharges"];
      setState(() {
        isLoading = false;
        contactList = data["voucherlist"];
        month = contactList[0]["alternative_code"];
        amount = contactList[0]["value"];
        contactList1 = data["subscriptionno"];
        lifeCycle = data["life_cycle_state_for_catalog_list"];
        provisioning = data["alternative_code_provisioning_for_catalog_list"];
        termed = data["alternative_code_termed_for_catalog_list"];
      });
      setWidgets();
      setDefaults();
    } else {
      print("Connection Fail");
      setState(() {
        isLoading = true;
      });
    }
  }

  void _method1() {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
        content: new Text(this.alertmsg),backgroundColor: Colors.blueAccent, duration: Duration(seconds: 1)));
  }

  void setDefaults() {
    _listValues.add("1");
  }

  void setWidgets() {
    for (int i = 0; i < contactList.length; i++) {
      myDown.add(contactList[i]["name"]
          .toString()
          .substring(contactList[i]["name"].toString().indexOf('-') + 1));
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
                fontFamily: 'Montserrat', fontSize: 19.0, color: Colors.black),
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
          hint: Text("Choose month"),
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
          child: Text("${widget.value}", style: style),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final expiraryDate = new Container(
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
          child: Text('$date1'=="null" ? "" : '$date1'.replaceAll("T", " "), style: style),
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
            checklang == "Eng" ? textEng[3] : textMyan[3],
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
          //     child: DropdownButton(
          //   value: _btn1SelectedVal,
          //   isExpanded: true,
          //   elevation: 8,
          //   hint: Text("Choose Month"),
          //   onChanged: ((String newValue) {
          //     setState(() {
          //       _btn1SelectedVal = newValue;
          //     });
          //   }),
          //   items: _dropDownMenuItems1,
          // ),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final availablePackage = new Container(
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
          child: Text('$package'=="null" ? "" : '$package', style: style),
        ),
      ),
      Divider(
        color: Colors.black,
      )
    ]));

    final duration = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 0),
          child: Text(
            checklang == "Eng" ? textEng[5] : textMyan[5],
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

    final Amount = new Container(
        child: Column(children: <Widget>[
      ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 8, 10),
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
          child: Text('$amount1'=="null" ? "" : '$amount1', style: style),
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
            "Note",
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
            child: Text(checklang == "Eng" ? textEng[7] : textMyan[7],
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ))),
      ),
    );

    final transferbutton = new RaisedButton(
      onPressed: () async{
        setState(() {
          if(amount1==null){
       _scaffoldkey.currentState.showSnackBar(new SnackBar(
        content: new Text("Please Select month"),backgroundColor: Colors.red, duration: Duration(seconds: 1)));
          }else{
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => skynetConfirmPage(
                  value: "${widget.value}",
                  value1: '$package',
                  value2: '$type1',
                  value3: '$amount1',
                  value4: '$charge',
                  value5: '$total',
                  value6: '$contactList1')),
        );
          }
        });

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
            child: Text(checklang == "Eng" ? textEng[8] : textMyan[8],
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ))),
      ),
    );

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    var skynetbody = new Form(
      key: _formKey,
      child: new ListView(
        children: <Widget>[
          SizedBox(height: 5.0),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 10.0),
            height: 670,
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
                      child: expiraryDate,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: packageType,
                    ),
                  ),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: availablePackage,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: duration,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: new Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Amount,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          skynetbody,
          Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.amber,
                ),
              ))
        ],
      ),
    );

    return Scaffold(
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
      ),
      body: isLoading ? bodyProgress : skynetbody,
    );
  }
}
