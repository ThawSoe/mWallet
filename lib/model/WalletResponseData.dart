class WalletResponseData{
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
  String type;
  String uuid;
  String userId;
  List channels;
  WalletResponseData({
    this.messageCode,
    this.messageDesc,
    this.sessionID,
    this.accountNo,
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
    this.userId,
    this.channels,
  });
  factory WalletResponseData.fromJson(Map<String, dynamic> parsedJson){
    return WalletResponseData(
        messageCode: parsedJson['messageCode'],
        messageDesc: parsedJson['messageDesc'],
        accountNo: parsedJson['accountNo'],
        sKey: parsedJson['sKey'],
        sessionID:parsedJson['sessionID'],
        name: parsedJson['name'],
        nrc : parsedJson['nrc'],
        field1: parsedJson['field1'],
        field2:parsedJson['field2'],
        institutionCode:parsedJson['institutionCode'],
        institutionName:parsedJson['institutionName'],
        balance:parsedJson['balance'],
        t16:parsedJson['t16'],
        region:parsedJson['region'],
        regionNumber:parsedJson['regionNumber'],
        type:parsedJson['type'],
        uuid:parsedJson['uuid'],
        userId:parsedJson['userId'],
        channels:parsedJson['channels'],
    );
  }
  Map<String, dynamic> toJson() => {
      'sKey': sKey, 'userID': userId,
      'name': name, 'sessionID': sessionID,
      'accountNo': accountNo, 'balance': balance,
      'frominstituteCode': institutionCode, 'institutionName': "",
      'field1': field1, 'field2': field2,
      'region': region, 't16': t16
};
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["messageCode"] = this.messageCode;
    map["messageDesc"] = this.messageDesc;
    map["accountNo"] = this.accountNo;
    map["sessionID"]=this.sessionID;
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
    map["type"] = this.type;
    map["uuid"] = this.uuid;
    map["type"] = this.type;
    map["userId"] = this.userId;
    map["channels"] = this.channels;
    return map;
  }

	
}