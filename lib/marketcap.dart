import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

const API_BASE = 'https://api.coinmarketcap.com';
const API_TICKER = API_BASE + '/v1/ticker/';


Future<dynamic> fetchTop(n) async {
  var url = API_TICKER + '?convert=CNY&limit=$n';
  print(url);

  var response = await http.get(url);
  var rv = json.decode(response.body);
  return rv;
}

