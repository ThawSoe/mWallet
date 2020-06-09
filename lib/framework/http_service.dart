import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> doPost(String url, Map jsonMap) async {
  //encode Map to JSON
  var body = json.encode(jsonMap);
  http.Response response = await http.post(url,headers: {"Content-Type": "application/json"},
                            body: body);
  final int statusCode = response.statusCode;

  if (statusCode < 200 || statusCode > 400 || json == null) {
  throw new Exception("Error while fetching data");
  }
  return utf8.decode(response.bodyBytes);
}