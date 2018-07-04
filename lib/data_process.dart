import 'package:flutter/material.dart';
import 'marketcap.dart';
import 'background.dart';

final biggerFont = const TextStyle(
  fontSize: 18.0,
  fontWeight:  FontWeight.bold,
);

/*
  const keys = [
    ['rank', 'Rank'],
    ['symbol', 'Symbol'],

    ['price_usd', 'USD'],
    ['price_btc', 'BTC'],
    ['price_cny', 'CNY'],

    // ['available_supply', ''],
    // ['total_supply', 'Supply'],
    // ['max_supply', ''],

    // ['percent_change_1h', '1h%'],
    // ['percent_change_24h', '24h'],
    // ['percent_change_7d', '7d%'],
    // ['24h_volume_usd', 'Volume USD'],
    // ['24h_volume_cny', 'Volume CNY'],
    // ['market_cap_usd', 'Cap USD'],
    // ['market_cap_cny', 'Cap CNY'],
    // ['last_updated', 'Update'],
  ];
  */

const categories = [
  'Symbol',
  'Price',
  'Supply',
  'Change',
  'Volume',
  'Cap',
  'Update',
];


Widget renderTickers(List<dynamic> json) {
  var top = json[0];
  var listings = json[1];

  return new GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    itemCount: top.length,
    itemBuilder: (context, index) {
      final item = top[index];
      var p1 = "\$ ${double.parse(item['price_usd']).toStringAsFixed(2)}";
      var p2 = "฿ ${double.parse(item['price_btc']).toStringAsFixed(6)}";
      var p3 = "¥ ${double.parse(item['price_cny']).toStringAsFixed(2)}";
      var id = findIDBySymbol(listings, item['symbol']);
      var logoUrl = 'https://s2.coinmarketcap.com/static/img/coins/128x128/$id.png';

      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Hero(
                tag: "detail",
                child: renderItem(item, context),
              )
          ));
        },
        child: Card(
          margin: EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
                  image: NetworkImage(logoUrl),
                )
            ),
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Text(
                    '${item['rank']} ${item['symbol']}',
                    style: biggerFont,
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(p1),
                  Text(p2),
                  Text(p3),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget renderItem(dynamic item, BuildContext context) {
  Widget _renderCell(String name) {
    if (name=='Symbol') {
      return new ListTile(
        title: new Text(
          '${item['rank']} ${item['symbol']}',
          style: biggerFont,
        ),
      );
    } else if (name=='Price') {
      return new ListTile(
        title: new Text(
          '\$ ${item['price_usd']}\n฿ ${item['price_btc']}\n¥ ${item['price_cny']}',
        ),
      );
    } else if (name=='Supply') {
      return new ListTile(
        title: new Text('Supply'),
        subtitle: new Row(
          children: ['Available', 'Total', 'Max'].map((t) => new Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: new Text('$t\n${item['${t.toLowerCase()}_supply']}'),
          )).toList(),
        ),
      );
    } else if (name=='Change') {
      return new ListTile(
        title: const Text('Change'),
        subtitle: new Row(
          children: ['1h', '24h', '7d'].map((t) => new Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: new Text('$t\n${item['percent_change_$t']}'),
          )).toList(),
        ),
      );
    } else if (name=='Volume') {
      return new ListTile(
        title: const Text('Volume'),
        subtitle: new Row(
          children: ['usd', 'cny'].map((t) => new Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: new Text('${t.toUpperCase()}\n${item['24h_volume_$t']}'),
          )).toList(),
        ),
      );
    } else if (name=='Cap') {
      return new ListTile(
        title: const Text('Cap'),
        subtitle: new Row(
          children: ['usd', 'cny'].map((t) => new Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: new Text('${t.toUpperCase()}\n${item['market_cap_$t']}'),
          )).toList(),
        ),
      );
    } else if (name=='Update') {
      var now = new DateTime.now().millisecondsSinceEpoch / 1000;
      var ts = int.parse(item['last_updated']);

      return new ListTile(
        title: const Text('Updated'),
        subtitle: new Text('${(now - ts).toStringAsFixed(0)} seconds ago'),
      );
    } else {
      return new ListTile(
        title: new Text('BUG'),
      );
    }
  }

  var rv = Card(
    child: Column(
      children: ListTile.divideTiles(
        color: Colors.grey,
        tiles: categories.map((x) => _renderCell(x)).toList(),
      ).toList(),
    ),
    margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
  );

  return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: rv,
  );
}

