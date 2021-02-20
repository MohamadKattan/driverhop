// this class for get response data json

import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(url); // first get url response

    // now will check if response don
    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodeData = jsonDecode(jsonData);
        return decodeData;
      } else {
        return 'failed';
      }
    } catch (ex) {
      return 'failed';
    }
  }
}
