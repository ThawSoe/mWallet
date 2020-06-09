class ReadMessageResponse{
String rKey;
String code;
String desc;
String sKey;
String otpCode;
String otpMessage;
String phone;
ReadMessageResponse({
    this.rKey,
    this.code,
    this.desc,
    this.sKey,
    this.otpCode,
    this.otpMessage,
    this.phone,
  });
factory ReadMessageResponse.fromJson(Map<String, dynamic> parsedJson){
    return ReadMessageResponse(
        rKey : parsedJson['rKey'],
        code: parsedJson['code'],
        desc: parsedJson['desc'],
        sKey: parsedJson['sKey'],
        otpCode: parsedJson['otpCode'],
        otpMessage: parsedJson['otpMessage'],
        phone: parsedJson['phone'],
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
    map['phone'] = this.phone;
    return map;
  }
}
