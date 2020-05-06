import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  final String url;
  NetworkHelper(this.url);

  /// get and decode json data from the given url.  null if status code isn't 200
  Future getData() async {
    http.Response response = await http.get(url);

    // if successful response
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print('failed to get data. $response.statusCode');
    }
  }
}
