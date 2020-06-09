class ContactAddResponse{
  String code;
  String desc;
  int count;
  
  ContactAddResponse({
    this.code,
    this.desc,
    this.count,
        
  });

  factory ContactAddResponse.fromJson(Map<String, dynamic> parsedJson){
    return ContactAddResponse(
        code: parsedJson['code'],
        desc : parsedJson['desc'],
        count: parsedJson['count'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["code"] = this.code;
    map["desc"] = this.desc;
    map["count"] = this.count;
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