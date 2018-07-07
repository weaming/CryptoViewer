import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> fetchRates() async {
  const KEY = 'b313f8e4b2bd44500c0dc34796c1a3b2';
  var url = 'http://data.fixer.io/api/latest?access_key=$KEY';
  return await fetch(url);
}

Future<dynamic> fetch(url) async {
  print(url);
  var response = await http.get(url);
  var rv = json.decode(response.body);
  return rv;
}
