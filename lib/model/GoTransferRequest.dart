class GoTransferRequest {
  String token;
  String senderCode;
  String receiverCode;
  String fromName;
  String toName;
  String amount;
  String prevBalance;
  String password;
  String iv;
  String dm;
  String salt;
  String appType;
  GoTransferRequest({
    this.token,
    this.senderCode,
    this.receiverCode,
    this.fromName,
    this.toName,
    this.amount,
    this.prevBalance,
    this.password,
    this.iv,
    this.dm,
    this.salt,
    this.appType,
  });
  factory GoTransferRequest.fromJson(Map<String, dynamic> parsedJson) {
    return GoTransferRequest(
        token: parsedJson['token'],
        senderCode: parsedJson['senderCode'],
        receiverCode: parsedJson['receiverCode'],
        fromName: parsedJson['fromName'],
        toName: parsedJson['toName'],
        amount: parsedJson['amount'],
        prevBalance: parsedJson['prevBalance'],
        password: parsedJson['password'],
        iv: parsedJson['iv'],
        dm: parsedJson['dm'],
        salt: parsedJson['salt'],
        appType: parsedJson['appType'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["token"] = this.token;
    map["senderCode"] = this.senderCode;
    map["receiverCode"] = this.receiverCode;
    map["fromName"] = this.fromName;
    map["toName"] = this.toName;
    map["amount"] = this.amount;
    map["prevBalance"] = this.prevBalance;
    map["password"] = this.password;
    map["iv"] = this.iv;
    map["dm"] = this.dm;
    map["salt"] = this.salt;
    map["appType"] = this.appType;
    return map;
  }
}
