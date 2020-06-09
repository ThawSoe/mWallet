class GoTransferResponse {
  String code;
  String desc;
  String bankRefNumber;
  String bankTaxRefNumber;
  String transactionDate;
  String cardExpire;
  String bankCharges;
  String otherResponseCode;
  String otherResponseDesc;
  String effectiveDate;
  String otherStatus;
  String penalty;
  String actualDate;
  GoTransferResponse({
    this.code,
    this.desc,
    this.bankRefNumber,
    this.bankTaxRefNumber,
    this.transactionDate,
    this.cardExpire,
    this.bankCharges,
    this.otherResponseCode,
    this.otherResponseDesc,
    this.effectiveDate,
    this.otherStatus,
    this.penalty,
    this.actualDate,
  });
  factory GoTransferResponse.fromJson(Map<String, dynamic> parsedJson) {
    return GoTransferResponse(
        code: parsedJson['code'],
        desc: parsedJson['desc'],
        bankRefNumber: parsedJson['bankRefNumber'],
        bankTaxRefNumber: parsedJson['bankTaxRefNumber'],
        transactionDate: parsedJson['transactionDate'],
        cardExpire: parsedJson['cardExpire'],
        bankCharges: parsedJson['bankCharges'],
        otherResponseCode: parsedJson['otherResponseCode'],
        otherResponseDesc: parsedJson['otherResponseDesc'],
        effectiveDate: parsedJson['effectiveDate'],
        otherStatus: parsedJson['otherStatus'],
        penalty: parsedJson['penalty'],
        actualDate: parsedJson['actualDate'],
 );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["code"] = this.code;
    map["desc"] = this.desc;
    map["bankRefNumber"] = this.bankRefNumber;
    map["bankTaxRefNumber"] = this.bankTaxRefNumber;
    map["transactionDate"] = this.transactionDate;
    map["cardExpire"] = this.cardExpire;
    map["bankCharges"] = this.bankCharges;
    map["otherResponseCode"] = this.otherResponseCode;
    map["otherResponseDesc"] = this.otherResponseDesc;
    map["effectiveDate"] = this.effectiveDate;
    map["otherStatus"] = this.otherStatus;
    map["penalty"] = this.penalty;
    map["actualDate"] = this.actualDate;
    return map;
  }
}
