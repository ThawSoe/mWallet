class GetBalanceResponse {
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
  double balance=0.00;
  String t16;
  String region;
  String regionNumber;
  String alreadyRegister;
	String channels;
  String type;
  String uuid;
  String userId;
  GetBalanceResponse({
    this.messageCode,
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
    this.channels,
    this.type,
    this.uuid,
    this.userId,
  });
  factory GetBalanceResponse.fromJson(Map<String, dynamic> parsedJson) {
    return GetBalanceResponse(
        messageCode: parsedJson['messageCode'],
        messageDesc: parsedJson['messageDesc'],
        accountNo: parsedJson['accountNo'],
        sessionID: parsedJson['sessionID'],
        sKey: parsedJson['sKey'],
        name: parsedJson['name'],
        nrc: parsedJson['nrc'],
        field1: parsedJson['field1'],
        field2: parsedJson['field2'],
        institutionCode: parsedJson['institutionCode'],
        institutionName: parsedJson['institutionName'],
        balance: parsedJson['balance'],
        t16: parsedJson['t16'],
        region: parsedJson['region'],
        regionNumber: parsedJson['regionNumber'],
        alreadyRegister: parsedJson['alreadyRegister'],
        channels: parsedJson['channels'],
        type: parsedJson['type'],
        uuid:parsedJson['uuid'],
        userId: parsedJson['userId'],
        );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["messageCode"] = this.messageCode;
    map["messageDesc"] = this.messageDesc;
    map["accountNo"] = this.accountNo;
    map["sessionID"] = this.sessionID;
    map["sKey"] = this.sKey;
    map["name"] = this.name;
    map["nrc"] = this.nrc;
    map["field1"] = this.field1;
    map["field2"] = this.field2;
    map["institutionCode"] = this.institutionCode;
    map["institutionName"] = this.institutionName;
    map["balance"] = this.balance;
    map["t16"] = this.t16;
    map["region"] = this.region;
    map["regionNumber"] = this.regionNumber;
    map["alreadyRegister"] = this.alreadyRegister;
    map["channels"] = this.channels;
    map["type"] = this.type;
    map["uuid"] = this.uuid;
    map["userId"] = this.userId;
    return map;
  }
}
