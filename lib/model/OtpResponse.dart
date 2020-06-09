class OtpResponse{
  String rKey;
	String code;
	String desc;
  String sKey;
	String otpCode;
	String otpMessage;
  String sessionID;
  String userID;
  OtpResponse({
    this.rKey,
    this.code,
    this.desc,
    this.sKey,
    this.otpCode,
    this.otpMessage,
    this.sessionID,
    this.userID,
  });
  factory OtpResponse.fromJson(Map<String, dynamic> parsedJson){
    return OtpResponse(
        rKey: parsedJson['rKey'],
        code : parsedJson['code'],
        desc: parsedJson['desc'],
        sKey: parsedJson['sKey'],
        otpCode: parsedJson['otpCode'],
        otpMessage: parsedJson['otpMessage'],
        sessionID: parsedJson['sessionID'],
        userID: parsedJson['userID'],
    );
  }
   Map toMap() {
    var map = new Map<String, dynamic>();
    map["rKey"] = this.rKey;
    map["code"] = this.code;
    map["desc"] = this.desc;
    map["sKey"] = this.sKey;
    map["otpCode"] = this.otpCode;
    map["otpMessage"] = this.otpMessage;
    map["sessionID"] = this.sessionID;
    map["userID"] = this.userID;
    return map;
  }
 

}