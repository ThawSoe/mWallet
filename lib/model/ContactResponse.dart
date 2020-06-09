class ContactArr{
  String code;
  String desc;
  List dataList;

  ContactArr({
    this.code,
    this.desc,
    this.dataList,
  });

  factory ContactArr.fromJson(Map<String, dynamic> parsedJson){
    return ContactArr(
        code: parsedJson['code'],
        desc : parsedJson['desc'],
        dataList: parsedJson['dataList'],
        
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["code"] = this.code;
    map["desc"] = this.desc;
    map["dataList"] = this.dataList;
    return map;
  }
  //  Map toMapLogin() {
  //   var map = new Map<String, dynamic>();
  //   map["userID"] = this.userID;
  //   map["deviceID"] = this.deviceID;
  //   map["otpCode"]=this.otpCode;
  //   map["rKey"]=this.rKey;
  //   map["sessionID"]=this.sessionID;
  //   map["fcmToken"]=this.fcmToken;
  //   return map;
  // }

}