class OpenAccountResponse {
  String messageCode;
  String messageDesc;
  String accountNo;
  String sessionID;
  String sKey;
  String name;
  String nrc;
  String field1;
  String field2;
  String institutionCode;
  String institutionName;
  double balance = 0.00;
  String t16; // user profile photo;
  String region;
  String regionNumber;
  String alreadyRegister;
  String type;
  String uuid;
  String userId;
  OpenAccountResponse(
      {this.messageCode,
      this.messageDesc,
      this.accountNo,
      this.sessionID,
      this.sKey,
      this.name,
      this.nrc,
      this.field1,
      this.field2,
      this.institutionCode,
      this.institutionName,
      this.balance,
      this.t16,
      this.region,
      this.regionNumber,
      this.alreadyRegister,
      this.type,
      this.uuid,
      this.userId});
  factory OpenAccountResponse.fromJson(Map<String, dynamic> parsedJson) {
    return OpenAccountResponse(
        messageCode: parsedJson['messageCode'],
        messageDesc: parsedJson['messageDesc'],
        accountNo: parsedJson['accountNo'],
        sessionID: parsedJson['sessionID'],
        sKey: parsedJson['sKey'],
        name: parsedJson['name'],
        nrc: parsedJson['nrc'],
        institutionCode: parsedJson['institutionCode'],
        institutionName: parsedJson['institutionName'],
        field1: parsedJson['field1'],
        field2: parsedJson['field2'],
        region: parsedJson['region'],
        balance: parsedJson['balance'],
        alreadyRegister: parsedJson['alreadyRegister'],
        t16: parsedJson['t16'],
        type: parsedJson['type'],
        uuid: parsedJson['uuid'],
        regionNumber: parsedJson['regionNumber'],
        userId: parsedJson['userId']);
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["messageCode"] = this.messageCode;
    map["messageDesc"] = this.messageDesc;
    map["accountNo"] = this.accountNo;
    map["name"] = this.name;
    map["nrc"] = this.nrc;
    map["sessionID"] = this.sessionID;
    map["sKey"] = this.sKey;
    map["institutionCode"] = this.institutionCode;
    map["institutionName"] = this.institutionName;
    map["field1"] = this.field1;
    map["field2"] = this.field2;
    map["region"] = this.region;
    map["balance"] = this.balance;
    map["t16"] = this.t16;
    map["type"] = this.type;
    map["alreadyRegister"] = this.alreadyRegister;
    map["uuid"] = this.alreadyRegister;
    map["regionNumber"] = this.regionNumber;
    map["userId"] = this.userId;
    return map;
  }
}
