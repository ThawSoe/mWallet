class GoMerchantPaymentRequest {
  String token;
  String senderCode;
  String merchantID;
  String fromName;
  String amount;
  String prevBalance;
  String password;
  String iv;
  String dm;
  String salt;
  GoMerchantPaymentRequest({
    this.token,
    this.senderCode,
    this.merchantID,
    this.fromName,
    this.amount,
    this.prevBalance,
    this.password,
    this.iv,
    this.dm,
    this.salt,
  });
  factory GoMerchantPaymentRequest.fromJson(Map<String, dynamic> parsedJson) {
    return GoMerchantPaymentRequest(
        token: parsedJson['token'],
        senderCode: parsedJson['senderCode'],
        merchantID: parsedJson['merchantID'],
        fromName: parsedJson['fromName'],
        amount: parsedJson['amount'],
        prevBalance: parsedJson['prevBalance'],
        password: parsedJson['password'],
        iv: parsedJson['iv'],
        dm: parsedJson['dm'],
        salt: parsedJson['salt'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["token"] = this.token;
    map["senderCode"] = this.senderCode;
    map["merchantID"] = this.merchantID;
    map["fromName"] = this.fromName;
    map["amount"] = this.amount;
    map["prevBalance"] = this.prevBalance;
    map["password"] = this.password;
    map["iv"] = this.iv;
    map["dm"] = this.dm;
    map["salt"] = this.salt;
    return map;
  }
}
