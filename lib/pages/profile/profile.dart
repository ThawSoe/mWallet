import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nsb/Link.dart';
import 'package:nsb/constants/constant.dart';
import 'package:nsb/global.dart';
import 'package:nsb/model/WalletResponseData.dart';
import 'package:nsb/model/updateProfileRequest.dart';
import 'package:nsb/framework/http_service.dart' as http;
import 'package:http/http.dart' as http;
import 'package:nsb/model/updateProfileResponse.dart';
import 'package:nsb/pages/Wallet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String value1;
  final String value2;

  Profile({
    Key key,
    this.value1,
    Key key1,
    this.value2,
  }) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File imageURI;
  var profileURI;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final myController = TextEditingController();
  final myphController = TextEditingController();
  String checklang = '';
  var data;
  bool isLoading = false;
  List textMyan = ["ကိုယ်ပိုင်အချက်အလက်", "သိမ်းမည်", "ဖုန်းနံပါတ်​", "အမည်​"];
  List textEng = ["Profile", "Save", "Phone Number", "Name"];
  static final CREATE_POST_URL = '$linkapi'
      '/chatting/api/v1/serviceChat/updateProfileforupdate';

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageURI = image;
    });
    print(imageURI);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("Profile", '$imageURI');
    profileURI = prefs
        .getString("Profile")
        .substring(prefs.getString("Profile").lastIndexOf("/") + 1)
        .replaceAll("'", "");
    print(profileURI);
  }

  snackbartrue(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      backgroundColor: colorgreen,
      duration: Duration(seconds: 2),
    ));
  }

  snackbarfalse(name) {
    _scaffoldkey.currentState.showSnackBar(new SnackBar(
      content: new Text(name),
      backgroundColor: colorerror,
      duration: Duration(seconds: 2),
    ));
  }

  updatePhoto() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    String syskey = prefs.getString('sKey');

    String url = '$link' + "/service001/mobileupload";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "userID": "' +
        userID +
        '", "sessionID": "' +
        sessionID +
        '","syskey":"' +
        syskey +
        '","userName":"' +
        "userName" +
        '" }';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      String body = response.body;
      var data = jsonDecode(body);
      if (data['messageCode'] == "0000") {
        setState(() {
          isLoading = false;
        });
        print(prefs.getString('name'));
        final key2 = 'name';
        final name = "userName";
        prefs.setString(key2, name);
        var result = prefs.getString('name');
        print(" Result is.... $result");
      }
    } else {
      print("Connection Fail");
      setState(() {
        isLoading = false;
      });
    }
  }

  //   @override
  //  void dispose() {
  //   myphController.dispose();
  //   super.dispose();
  // }
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

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageURI = image;
    });
    print(imageURI);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("Profile", '$imageURI');
    profileURI = prefs
        .getString("Profile")
        .substring(prefs.getString("Profile").lastIndexOf("/") + 1)
        .replaceAll("'", "");
    print(profileURI);
    // final File newImage = await image.copy('$profileURI');
  }

  @override
  void initState() {
    super.initState();
    checkLanguage();
    this.myController.text = "${widget.value2}";
    this.myphController.text = "${widget.value1}";
  }

  updateProfile() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String syskey = prefs.getString('sKey');
    String t1 = "${widget.value1}";
    String t2 = this.myController.text;
    updateProfileRequest profileListRequest = new updateProfileRequest(
        syskey: syskey,
        t1: t1,
        t2: t2,
        t3: "DC001",
        t4: "",
        t9: "010",
        t16: "");
    updateProfileResponse profileListResponse =
        await getUpdateProfile(CREATE_POST_URL, profileListRequest.toMap());
    if (profileListResponse.syskey != 10) {
      saveProfile();
    } else {}
  }

  Future<updateProfileResponse> getUpdateProfile(url, Map jsonMap) async {
    updateProfileResponse p = new updateProfileResponse();

    var body;
    try {
      body = await http.doPost(url, jsonMap);
      p = updateProfileResponse.fromJson(json.decode(body.toString()));
    } catch (e) {}
    print(p.toMap());
    return p;
  }

  saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userId');
    String sessionID = prefs.getString('sessionID');
    String syskey = prefs.getString('sKey');
    String userName = myController.text;

    String url = '$link'
        "/service001/saveProfile";
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{ "userID": "' +
        userID +
        '", "sessionID": "' +
        sessionID +
        '","syskey":"' +
        syskey +
        '","userName":"' +
        userName +
        '" }';
    http.Response response = await http.post(url, headers: headers, body: json);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      data = jsonDecode(body);
      print("Data $data");
      if (data['messageCode'] == "0000") {
        setState(() {
          isLoading = false;
        });
        print(prefs.getString('name'));
        final key2 = 'name';
        final name = userName;
        prefs.setString(key2, name);
        var result = prefs.getString('name');
        print(" Result is.... $result");
        if (data["messageDesc"] == "Successfully") {
          updatePhoto();
        }
        snackbartrue(data["messageDesc"]);
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WalletPage()));
        });
      }
    } else {
      snackbarfalse(data["messageDesc"]);
      print("Connection Fail");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = new TextFormField(
      controller: myController,
      autofocus: true,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: (checklang == "Eng") ? textEng[3] : textMyan[3],
        hasFloatingPlaceholder: true,
        labelStyle: (checklang == "Eng")
            ? TextStyle(
                fontSize: 15,
                color: colorblack,
                height: 0,
                fontWeight: FontWeight.w300)
            : TextStyle(fontSize: 14, color: colorblack, height: 0),
        fillColor: Colors.black87,
      ),
    );

    var profilebody = SingleChildScrollView(
      key: _formKey,
      child: new Container(
        // color: colorgreen,
        padding: EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: imageURI == null
                          ? (Image.asset('assets/images/user-icon.png',
                              width: 100.0, height: 100.0))
                          : (Image.file(imageURI,
                              width: 100.0, height: 100.0, fit: BoxFit.cover)),
                      //                     : new FutureBuilder(
                      //   future: DefaultAssetBundle.of(context).loadString(profileURI),
                      //   builder: (context, snapshot) {
                      //     return new Text(snapshot.data ?? '', softWrap: true);
                      //   }
                      // ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: Image.asset(
                        'assets/images/edit.png',
                        color: Colors.grey,
                        width: 20,
                      ),
                      onPressed: () {
                        _settingModalBottomSheet(context);
                      }),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: myphController,
                        style: TextStyle(
                            color: colorblack, fontWeight: FontWeight.w300),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText:
                              (checklang == "Eng") ? textEng[2] : textMyan[2],
                          hasFloatingPlaceholder: true,
                          labelStyle: (checklang == "Eng")
                              ? TextStyle(
                                  fontSize: 15,
                                  color: colorblack,
                                  height: 0,
                                  fontWeight: FontWeight.w300)
                              : TextStyle(
                                  fontSize: 14, color: colorblack, height: 0),
                          fillColor: colorblack,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: name,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: RaisedButton(
                        onPressed: () {
                          updateProfile();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: (checklang == "Eng")
                            ? Text(
                                (checklang == "Eng") ? textEng[1] : textMyan[1],
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              )
                            : Text(
                                (checklang == "Eng") ? textEng[1] : textMyan[1],
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                        color: colorgreen,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          profilebody,
          Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.height * 0.9,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: colorgreen,
                ),
              ))
        ],
      ),
    );

    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          backgroundColor: colorgreen,
          centerTitle: true,
          title: (checklang == "Eng")
              ? Text(
                  (checklang == "Eng") ? textEng[0] : textMyan[0],
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                )
              : Text(
                  (checklang == "Eng") ? textEng[0] : textMyan[0],
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
        ),
        body: isLoading ? bodyProgress : profilebody);
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            color: Colors.transparent,
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.camera_alt),
                    title: Text("Take new picture"),
                    onTap: () {
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: Text("Select new from gallery"),
                    onTap: () {
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.clear),
                    title: Text("Cancel"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
