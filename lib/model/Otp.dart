class Otp{
  String userID;
  String type;
  String deviceID;
  String code;
  String desc;
  String otpCode;
  String otpMessage;
  String sessionID;
  String rKey;
  String fcmToken;
  Otp({
    this.userID,
    this.type,
    this.deviceID,
    this.code,
    this.desc,
    this.otpCode,
    this.otpMessage,
    this.sessionID,
    this.rKey,
    this.fcmToken,
  });

  factory Otp.fromJson(Map<String, dynamic> parsedJson){
    return Otp(
        userID: parsedJson['userID'],
        type : parsedJson['type'],
        deviceID: parsedJson['deviceID'],
        code: parsedJson['code'],
        desc: parsedJson['desc'],
        otpCode: parsedJson['otpCode'],
        otpMessage: parsedJson['otpMessage'],
        sessionID: parsedJson['sessionID'],
        fcmToken:parsedJson['fcmToken'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userID"] = this.userID;
    map["type"] = this.type;
    map["deviceID"] = this.deviceID;
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