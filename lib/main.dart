import 'package:flutter/material.dart';
import 'background.dart';
import './marketcap/tabs.dart';
import './fixer/tabs.dart';


void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinMarketCap',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
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
            image: DecorationImage(
              image: AssetImage("images/black_power.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.deepPurple.withOpacity(0.8),
                  BlendMode.dstATop
              ),
            )
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
    var rateList = RateList();

    return TabBarView(
      children: <Widget>[
        tickerList,
        rateList,
      ],
    );
  }
}

