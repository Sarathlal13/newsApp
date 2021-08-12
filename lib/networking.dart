import 'dart:convert';

import 'package:http/http.dart' as http;

const url = "https://saurav.tech/NewsAPI/top-headlines/category/health/in.json";

class NetWorking {
  Future getDatafromServer() async {
    http.Response resp = await http.get(url);
    print(resp.body);
    if (resp.statusCode == 200) {
      print(resp);
      var result = jsonDecode(resp.body);
      return result;
    }
  }
}
