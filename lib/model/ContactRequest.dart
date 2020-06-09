class SessionData{
  String userID;
  String sessionID;
  String loginID;
  String lovDesc;
  String t1;
  String t2;

  SessionData({
    this.userID,
    this.sessionID,
    this.loginID,
    this.lovDesc,
    this.t1,
    this.t2,
    
  });

  factory SessionData.fromJson(Map<String, dynamic> parsedJson){
    return SessionData(
        userID: parsedJson['userID'],
        sessionID : parsedJson['sessionID'],
        loginID: parsedJson['loginID'],
        lovDesc: parsedJson['lovDesc'],
        t1: parsedJson['t1'],
        t2: parsedJson['t2'],
        
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userID"] = this.userID;
    map["sessionID"] = this.sessionID;
    map["loginID"] = this.loginID;
    map["lovDesc"] = this.lovDesc;
    map["t1"] = this.t1;
    map["t2"] = this.t2;
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