import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    var tickerList = TickerList();
    var listings = Text('');

    return TabBarView(
      children: <Widget>[
        tickerList,
        listings,
      ],
    );
  }
}

class TickerList extends StatefulWidget {
  @override
  _TickerListState createState() => _TickerListState();
}

class _TickerListState extends State<TickerList> {
  @override
  Widget build(BuildContext context) {
    return buildTickerList();
  }
}

class TickersList extends StatelessWidget {
  final data;

  TickersList(this.data);

  @override
  Widget build(BuildContext context) {
    var tickers = data['data'].values.map((v) => v).toList();
    var rv = renderTickers(tickers);
    return rv;
  }
}

// build two list
Widget buildTickerList() {
  return FutureBuilder<dynamic>(
    future: fetchTop(99),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return TickersList(snapshot.data);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }

      return Text('');
    },
  );
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
