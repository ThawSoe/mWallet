import 'package:http/http.dart' as http;
import 'dart:convert';

final JsonDecoder _decoder = new JsonDecoder();

Future<String> doPost(String url, Map jsonMap) async {
  //encode Map to JSON
  var body = json.encode(jsonMap);
  http.Response response = await http.post(url,headers: {"Content-Type": "application/json"},
                            body: body);
  final int statusCode = response.statusCode;

  if (statusCode < 200 || statusCode > 400 || json == null) {
  throw new Exception("Error while fetching data");
  }
  return response.body;
}

 Future<dynamic> get(String url, Map jsonMap) async{
    return http
        .get(
      url,
    )
        .then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":"+
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception( statusCode);
      }
      return _decoder.convert(res);
    });
  }