class CheckOTPRequestData{
  String userID;
	String sessionID;
	String otpCode;
	String rKey;
	String sKey;
	String type;
	String deviceID;
	String fcmToken;
  CheckOTPRequestData({
    this.userID,
    this.sessionID,
    this.otpCode,
    this.rKey,
    this.sKey,
    this.type,
    this.deviceID,
    this.fcmToken,
  });
  factory CheckOTPRequestData.fromJson(Map<String, dynamic> parsedJson){
    return CheckOTPRequestData(
        userID: parsedJson['userID'],
        sessionID: parsedJson['sessionID'],
        otpCode: parsedJson['otpCode'],
        rKey: parsedJson['rKey'],
        sKey: parsedJson['sKey'],
        type : parsedJson['type'],
        deviceID: parsedJson['deviceID'],
        fcmToken:parsedJson['fcmToken'],
    );
  }
  
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userID"] = this.userID;
    map["sessionID"] = this.sessionID;
    map["otpCode"] = this.otpCode;
    map["rKey"] = this.rKey;
    map["sKey"] = this.sKey;
    map["type"] = this.type;
    map["deviceID"] = this.deviceID;
    map["fcmToken"] = this.fcmToken;
    return map;
  }
   
}