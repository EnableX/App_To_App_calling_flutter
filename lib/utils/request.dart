import 'package:http/http.dart' as http;

import 'constants.dart';

class Requests {
  final String url;
  final dynamic body;

  Requests({required this.url, this.body});

  Future<http.Response> post() {
    String urlData=urlBase + url ;
    print("urls $urlData  Data$body");
    return http.post(Uri.parse(urlData), body: body).timeout(const Duration(minutes: 2));
  }
  Future<http.Response> put() {
    String urlData=urlBase + url ;
    print("urls $urlData  Data$body");
    return http.put(Uri.parse(urlData), body: body).timeout(const Duration(minutes: 2));
  }

  Future<http.Response> get() {
    String urlData=urlBase + url ;
    return http.get(Uri.parse(urlData)).timeout(const Duration(minutes: 2));
  }
}