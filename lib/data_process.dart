import 'package:flutter/material.dart';

final biggerFont = const TextStyle(
  fontSize: 16.0,
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

String _getLogoUrl(item, size) {
  var id = item['id'];
  var logoUrl = 'https://s2.coinmarketcap.com/static/img/coins/${size}x$size/$id.png';
  return logoUrl;
}


Widget renderTickers(List<dynamic> top) {
  top.sort((a, b) => a['rank'].compareTo(b['rank']));

  return SimpleList(top);
}

class SimpleList extends StatefulWidget {
  final top;

  SimpleList(this.top);

  @override
  ListState createState() => ListState(top);
}

class ListState extends State<SimpleList> {
  var _choice;
  final top;

  ListState(this.top);

  _clearChoice() {
    setState(() {
      _choice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_choice == null) {
      var grid = GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: top.length,
        itemBuilder: (context, index) {
          final item = top[index];
          var quotes = item['quotes'];

          var p1 = "\$ ${quotes['USD']['price'].toStringAsFixed(2)}";
          var p3 = "¥ ${quotes['CNY']['price'].toStringAsFixed(2)}";

          return GestureDetector(
            onTap: () {
              setState(() {
                _choice = index;
              });
            },
            child: Card(
              margin: EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.dstATop),
                      image: NetworkImage(_getLogoUrl(item, 128)),
                    )
                ),
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      Text(
                        '${item["symbol"]}',
                        style: biggerFont,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('R ${item["rank"]}'),
                      Text(p1),
                      Text(p3),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      return Hero(
        tag: 'item',
        child: grid,
      );
    } else {
      var item = top[_choice];
      return renderItem(item, context, _clearChoice);
    }
  }
}

Widget renderItem(dynamic item, BuildContext context, callback) {
  Widget _renderCell(String name) {
    var quotes = item['quotes'];

    if (name=='Symbol') {
      return ListTile(
          title: Row(
            children: <Widget>[
              Text(
                '${item['rank']} ${item['symbol']} ${item["name"]}',
                style: biggerFont,
              ),
              Image.network(_getLogoUrl(item, 64)),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          )
      );
    } else if (name=='Price') {
      return ListTile(
        title: Text(
          '\$ ${quotes['USD']['price']}\n¥ ${quotes['CNY']['price'].toStringAsFixed(2)}',
        ),
      );
    } else if (name=='Supply') {
      return ListTile(
        title: Text('Supply'),
        subtitle: Row(
          children: ['Circulating', 'Total', 'Max'].map((t) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Text('$t\n${item['${t.toLowerCase()}_supply']}'),
          )).toList(),
        ),
      );
    } else if (name=='Change') {
      return ListTile(
        title: const Text('Change'),
        subtitle: Row(
          children: ['1h', '24h', '7d'].map((t) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Text('$t\n${quotes['USD']['percent_change_$t']}'),
          )).toList(),
        ),
      );
    } else if (name=='Volume') {
      return ListTile(
        title: const Text('Volume 24h'),
        subtitle: Row(
          children: ['usd', 'cny'].map((t) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Text('${t.toUpperCase()}\n${quotes[t.toUpperCase()]['volume_24h'].toStringAsFixed(2)}'),
          )).toList(),
        ),
      );
    } else if (name=='Cap') {
      return ListTile(
        title: const Text('Cap'),
        subtitle: Row(
          children: ['usd', 'cny'].map((t) => Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Text('${t.toUpperCase()}\n${quotes[t.toUpperCase()]['market_cap']}'),
          )).toList(),
        ),
      );
    } else if (name=='Update') {
      var now = DateTime.now().millisecondsSinceEpoch / 1000;
      var ts = item['last_updated'];

      return ListTile(
        title: const Text('Updated'),
        subtitle: Text('${(now - ts).toStringAsFixed(0)} seconds ago'),
      );
    }

    return ListTile(
      title: Text('BUG'),
    );
  }

  var rv = Card(
    child: Column(
      children: ListTile.divideTiles(
        color: Colors.grey,
        tiles: categories.map((x) => _renderCell(x)).toList(),
      ).toList(),
    ),
    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
  );

  return Hero(
    tag: 'item',
    child: GestureDetector(
      onTap: () {
        callback();
      },
      child: rv,
    ),
  );
}

