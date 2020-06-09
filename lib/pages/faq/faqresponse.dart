class FaqResponse {
  List<FAQ> faqData;
  String code;
  String desc;

  FaqResponse({this.faqData,this.code,this.desc});

  factory FaqResponse.fromJson(Map<String, dynamic> parsedJson){
    return FaqResponse(
        code: parsedJson['code'],
        // faqData: parsedJson['data'],
        faqData: parseData(parsedJson),
        desc: parsedJson['desc'],
    );
  }

  static List<FAQ> parseData(dataJson){
    var list = dataJson['faqData'] as List;
    List<FAQ> dataList = list.map((faqData) => FAQ.fromJson(faqData)).toList();
    return dataList;
  }
Map toMap() {
    var map = new Map<String, dynamic>();
    map["code"] = this.code;
    map["faqData"] = this.faqData;
    map["desc"] = this.desc;
    return map;
  }

}

class FAQ{
  String questionEng;
  String questionUni;
  String answerEng;
  String answerUni;

  FAQ({this.questionEng,this.questionUni,this.answerEng,this.answerUni});

  factory FAQ.fromJson(Map<String, dynamic> parsedJson){
    return FAQ(
      questionEng: parsedJson['questionEng'],
      questionUni: parsedJson['questionUni'],
      answerEng: parsedJson['answerEng'],
      answerUni: parsedJson['answerUni'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["questionEng"] = this.questionEng;
    map["questionUni"] = this.questionUni;
    map["answerEng"] = this.answerEng;
    map["answerUni"] = this.answerUni;
    return map;
  }
}