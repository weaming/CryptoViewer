import 'package:flutter/material.dart';
import 'marketcap.dart';
import 'data_process.dart';
import 'background.dart';

void main() => runApp(new App());

class BaseLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          decoration: new BoxDecoration(
            image: buildBackground("images/girl.jpg")
          ),
          child: new MainLayout(),
      ),
    );
  }
}

class MainLayout extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MainLayout> {
  var _needRefresh = false;

  void _toggleNeedFresh() {
    setState(() {
      _needRefresh = !_needRefresh;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('building');
    return FutureBuilder<dynamic>(
      future: fetchTop(20),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // http ok
          _needRefresh = false;

          var button = new Container(
            child: IconButton(
              icon: (_needRefresh
                  ? Icon(Icons.done)
                  : Icon(Icons.refresh)),
              color: Colors.yellow[500],
              onPressed: _toggleNeedFresh,
            ),
          );

          return renderTickers(snapshot.data, button);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'CoinMarketCap',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('CoinMarketCap'),
        ),
        body: new BaseLayout(),
      ),
    );
  }
}
