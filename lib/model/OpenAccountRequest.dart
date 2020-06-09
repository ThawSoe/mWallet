class OpenAccountRequest {
  String userID;
  String name;
  String nrc;
  String sessionID;
  int sKey;
  String institutionCode;
  String field1;
  String field2;
  String region;
  String phoneType;
  String alreadyRegister;
  String password;
  String deviceId;
  String appVersion;
  String regionNumber;
  String fcmToken;
  String iv;
	String dm;
  String salt;
  OpenAccountRequest({
    this.userID,
    this.name,
    this.nrc,
    this.sessionID,
    this.sKey,
    this.institutionCode,
    this.field1,
    this.field2,
    this.region,
    this.phoneType,
    this.alreadyRegister,
    this.password,
    this.deviceId,
    this.appVersion,
    this.regionNumber,
    this.fcmToken,
    this.iv,
    this.dm,
    this.salt,
  });
  factory OpenAccountRequest.fromJson(Map<String, dynamic> parsedJson) {
    return OpenAccountRequest(
        userID: parsedJson['userID'],
        name: parsedJson['name'],
        nrc: parsedJson['nrc'],
        sessionID: parsedJson['sessionID'],
        sKey: parsedJson['sKey'],
        institutionCode: parsedJson['institutionCode'],
        field1: parsedJson['field1'],
        field2: parsedJson['field2'],
        region: parsedJson['region'],
        phoneType: parsedJson['phoneType'],
        alreadyRegister: parsedJson['alreadyRegister'],
        password: parsedJson['password'],
        deviceId: parsedJson['deviceId'],
        appVersion: parsedJson['appVersion'],
        regionNumber: parsedJson['regionNumber'],
        fcmToken: parsedJson['fcmToken'],
        iv: parsedJson['iv'],
        dm: parsedJson['dm'],
        salt:parsedJson['salt']);

  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userID"] = this.userID;
    map["name"] = this.name;
    map["nrc"] = this.nrc;
    map["sessionID"] = this.sessionID;
    map["sKey"] = this.sKey;
    map["institutionCode"] = this.institutionCode;
    map["field1"] = this.field1;
    map["field2"] = this.field2;
    map["region"] = this.region;
    map["phoneType"] = this.phoneType;
    map["alreadyRegister"] = this.alreadyRegister;
    map["password"] = this.password;
    map["deviceId"] = this.deviceId;
    map["appVersion"] = this.appVersion;
    map["regionNumber"] = this.regionNumber;
    map["fcmToken"] = this.fcmToken;
    map["iv"] = this.iv;
    map["dm"] = this.dm;
    map["salt"] = this.salt;
    return map;
  }
}
