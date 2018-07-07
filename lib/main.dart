import 'package:flutter/material.dart';
import 'dart:async';
import 'marketcap.dart';
import 'data_process.dart';
import 'background.dart';
import 'cache.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinMarketCap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('CoinMarketCap'),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.info_outline)),
                Tab(icon: Icon(Icons.format_list_bulleted)),
              ],
            ),
          ),
          body: BaseLayout(),
        ),
      ),
    );
  }
}

class BaseLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: buildBackground("images/girl.jpg")
          ),
          child: MainLayout(),
      ),
    );
  }
}

class MainLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tickerList = TickersList();
    var listings = Text('');

    return TabBarView(
      children: <Widget>[
        tickerList,
        listings,
      ],
    );
  }
}

class TickersList extends StatefulWidget {
  @override
  TickersListState createState() => TickersListState();
}

class TickersListState extends State<TickersList> {
  var data;

  TickersListState();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<Null> _getData() async {
    httpGetCache("tickerList", () => fetchTop(99), timeout: 30, withState: true)
        .then((rv) {
      setState(() {
        data = rv[0];
      });

      var useCache = rv[1];
      if (!useCache) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              'Update success',
              style: TextStyle(
                color: Colors.green,
              ),
            )
        ));
      }
    });
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
      onRefresh: _getData,
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
