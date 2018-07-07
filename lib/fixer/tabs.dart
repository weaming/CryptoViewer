import 'dart:async';
import 'package:flutter/material.dart';
import './api.dart';
import '../cache.dart';
import './l10n.dart';

class RateList extends StatefulWidget {
  @override
  RateListState createState() => RateListState();
}

class RateListState extends State<RateList> {
  var data;
  var _selectedCurrency = 'CNY';

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
            color: Colors.green,
          ),
        )
    ));
  }

  Future<Null> _getData({force=false}) async {
    if (force) {
      fetchRates()
          .then((rv) {
        setState(() {
          data = rv;
        });

        _afterHttpFinish();
      });
    } else {
      httpGetCache("rates", fetchRates, timeout: 30, withState: true)
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

    var rates = data['rates'];
    var rv = RefreshIndicator(
      child: renderRates(rates, _selectedCurrency),
      onRefresh: () => _getData(force: true),
    );
    return rv;
  }
}

Widget renderRates(Map rates, String selectedCurrency, {double amount=100.0}) {
  var keys = rates.keys
      .where((x) => CURRENCY_NAMES[x].length > 0)
      .map((x) => '$x').toList();
  keys.sort();

  var items = keys.map((k) => [k, rates[k]]).toList();

  return ListView.builder(
    itemCount: keys.length,
    itemBuilder: (context, index) {
      var item = items[index];
      var currency = item[0];
      var rate = ((item[1] / rates[selectedCurrency]) * amount)
          .toStringAsFixed(3);

      var rv = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$currency ${CURRENCY_NAMES[currency]}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                currency == selectedCurrency
                    ? Colors.deepOrange
                    : Colors.blue),
          ),
          Chip(
            label: Text(
              '$rate',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ),
        ],
      );

      return Card(
        margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5.0),
        child: Container(
          child: rv,
          margin: EdgeInsets.all(10.0),
        ),
        color: Colors.white70,
      );
    },
  );
}
