import 'package:flutter/material.dart';

final biggerFont = const TextStyle(
  fontSize: 22.0,
  fontWeight:  FontWeight.bold,
);


Widget renderTickers(List<dynamic> json, Widget refreshButton) {
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

  Widget renderItem(dynamic item) {
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

    var rv = new Card(
      child: new Column(
        children: ListTile.divideTiles(
          color: Colors.grey,
          tiles: categories.map((x) => _renderCell(x)).toList(),
        ).toList(),
      ),
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
    );
    return rv;
  }

  var children = [refreshButton];
  children.addAll(json.map((item) => renderItem(item)).toList());

  return new ListView(
    children: children,
  );
}

