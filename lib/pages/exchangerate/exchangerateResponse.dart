class ExchangeRateResponse{
String code;
List<Data> data;
// dynamic data;
String desc;
ExchangeRateResponse({
    this.code,
    this.data,
    this.desc,
  });
factory ExchangeRateResponse.fromJson(Map<String, dynamic> parsedJson){
    return ExchangeRateResponse(
        code: parsedJson['code'],
        // data: parsedJson['data'],
        data: parseData(parsedJson),
        desc: parsedJson['desc'],
    );
  }

  static List<Data> parseData(dataJson){
    var list = dataJson['data'] as List;
    List<Data> dataList = list.map((data) => Data.fromJson(data)).toList();
    return dataList;
  }
Map toMap() {
    var map = new Map<String, dynamic>();
    map["code"] = this.code;
    map["data"] = this.data;
    map["desc"] = this.desc;
    return map;
  }
}
class Data{
   String ccy1;
   String ccy2;
   String codMethod;
   String namCURRFrom;
   String namCURRTo;
   String numBuyRate;
   String numChqBuyRate;
   String numChqSellRate;
   String numMidRate;
   String numQuotation;
   String numSellRate;
   String numXFERBuyRate;
   String numXFERSellRate;
   String slno;
   String systemDate;
   String txtRateType;
   String dTime;

  Data({
    this.ccy1,
    this.ccy2,
    this.codMethod,
    this.namCURRFrom,
    this.namCURRTo,
    this.numBuyRate,
    this.numChqBuyRate,
    this.numChqSellRate,
    this.numMidRate,
    this.numQuotation,
    this.numSellRate,
    this.numXFERBuyRate,
    this.numXFERSellRate,
    this.slno,
    this.systemDate,
    this.txtRateType,
    this.dTime
  });
  factory Data.fromJson(Map<String, dynamic> parsedJson){
    return Data(
        ccy1: parsedJson['ccy1'],
        ccy2: parsedJson['ccy2'],
        codMethod: parsedJson['codMethod'],
        namCURRFrom: parsedJson['namCURRFrom'],
        namCURRTo: parsedJson['namCURRTo'],
        numBuyRate: parsedJson['numBuyRate'],
        numChqBuyRate: parsedJson['numChqBuyRate'],
        numChqSellRate: parsedJson['numChqSellRate'],
        numMidRate: parsedJson['numMidRate'],
        numQuotation: parsedJson['numQuotation'],
        numSellRate: parsedJson['numSellRate'],
        numXFERBuyRate: parsedJson['numXFERBuyRate'],
        numXFERSellRate: parsedJson['numXFERSellRate'],
        slno: parsedJson['slno'],
        systemDate: parsedJson['systemDate'],
        txtRateType: parsedJson['txtRateType'],
        dTime: parsedJson['dTime'],
    );
  }
Map toMap() {
    var map = new Map<String, dynamic>();
    map["ccy1"] = this.ccy1;
    map["ccy2"] = this.ccy2;
    map["codMethod"] = this.codMethod;
    map["namCURRFrom"] = this.namCURRFrom;
    map["namCURRTo"] = this.namCURRTo;
    map["numBuyRate"] = this.numBuyRate;
    map["numChqBuyRate"] = this.numChqBuyRate;
    map["numChqSellRate"] = this.numChqSellRate;
    map["numMidRate"] = this.numMidRate;
    map["numQuotation"] = this.numQuotation;
    map["numSellRate"] = this.numSellRate;
    map["numXFERBuyRate"] = this.numXFERBuyRate;
    map["numXFERSellRate"] = this.numXFERSellRate;
    map["slno"] = this.slno;
    map["systemDate"] = this.systemDate;
    map["txtRateType"] = this.txtRateType;
    map["dTime"] = this.dTime;
    return map;
  }
}


