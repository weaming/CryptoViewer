import 'dart:async';
import 'package:flutter/material.dart';
import './api.dart';
import './data_process.dart';
import '../cache.dart';

class TickerList extends StatefulWidget {
  @override
  TickerListState createState() => TickerListState();
}

class TickerListState extends State<TickerList> {
  var data;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _afterHttpFinish() {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Update success',
          style: TextStyle(
            color: Colors.deepPurple,
          ),
        )
    ));
  }

  Future<Null> _getData({force=false}) async {
    if (force) {
      fetchTop(99)
          .then((rv) {
        setState(() {
          data = rv;
        });

        _afterHttpFinish();
      });
    } else {
      httpGetCache("tickerList", () => fetchTop(99), timeout: 30, returnState: true)
          .then((rv) {
        setState(() {
          data = rv[0];
        });

        var useCache = rv[1];
        if (!useCache) {
          _afterHttpFinish();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Center(
          child: CircularProgressIndicator()
      );
    }

    var tickers = data['data'].values.map((v) => v).toList();
    var rv = renderTickers(tickers);

    return RefreshIndicator(
      child: rv,
      onRefresh: () => _getData(force: true),
    );
  }
}

// build two list
Widget buildListings() {
  return FutureBuilder<dynamic>(
    future: fetchListings(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        var data = snapshot.data;

        return GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
          children: data.map<Widget>((Coin item) => Card(
            child: ListTile(
              title: Text('${item.id}'),
              subtitle: Text('${item.symbol}'),
            ),
          )).toList(),
        );
      }

      return CircularProgressIndicator();
    },
  );
}
