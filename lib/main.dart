import 'package:flutter/material.dart';
import 'dart:async';
import 'marketcap.dart';
import 'data_process.dart';
import 'background.dart';

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
  Future<dynamic> _fetchInfoAndListings(n) async {
    var top = await fetchTop(n);
    var listings = await fetchListings();
    return [top, listings];
  }

  @override
  Widget build(BuildContext context) {
    var tickerList = FutureBuilder<dynamic>(
      future: _fetchInfoAndListings(120),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TickersList(snapshot.data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );

    return TabBarView(
      children: <Widget>[
        tickerList,
        Text(''),
      ],
    );
  }
}


class TickersList extends StatelessWidget {
  final data;

  TickersList(this.data);

  @override
  Widget build(BuildContext context) {
    var rv = renderTickers(data);
    return Hero(
      tag: 'detail',
      child: rv,
    );
  }
}

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
