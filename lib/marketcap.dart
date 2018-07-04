import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

const API_BASE = 'https://api.coinmarketcap.com';
const API_TICKER = API_BASE + '/v1/ticker/';
const API_LISTINGS = API_BASE + '/v2/listings/';


Future<dynamic> fetchTop(n) async {
  var url = API_TICKER + '?convert=CNY&limit=$n';
  return await fetch(url);
}

Future<dynamic> fetch(url) async {
  print(url);
  var response = await http.get(url);
  var rv = json.decode(response.body);
  return rv;
}

class Coin {
  final int id;
  final String name;
  final String symbol;
  final String websiteSlug;

  Coin(this.id, this.name, this.symbol, this.websiteSlug);

  factory Coin.fromJson(Map<String, dynamic> data) {
    return Coin(
      data['id'],
      data['name'],
      data['symbol'],
      data['website_slug'],
    );
  }
}

Future<List<Coin>> fetchListings() async {
  const url = API_LISTINGS;
  var response = await fetch(url);
  return response['data'].map<Coin>((json) => Coin.fromJson(json)).toList();
}

int findIDBySymbol(List<Coin> coins, String symbol) {
  for (var coin in coins) {
    if (coin.symbol == symbol) {
      return coin.id;
    }
  }
  return 0;
}
