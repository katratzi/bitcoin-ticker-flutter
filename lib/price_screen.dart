import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/networking.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency;
  String bitcoinRate = '?';

  /// dropdown for android
  DropdownButton<String> androidDropdown() {
    // get our list of currencies
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      dropdownItems.add(
        DropdownMenuItem(
          child: Text(currenciesList[i]),
          value: currenciesList[i],
        ),
      );
    }

    // return the main dropdown widget
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          print(value);
          setCurrency(value);
        });
      },
    );
  }

// picker for iOS
  CupertinoPicker iosPicker() {
    /// create our list of currency widgets
    List<Widget> pickerWidgets = [];
    for (String currency in currenciesList) {
      pickerWidgets.add(
        Text(
          currency,
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // now return the cupertino picker
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        // print(selectedIndex);
        setCurrency(currenciesList[selectedIndex]);
      },
      children: pickerWidgets,
    );
  }

  void setCurrency(String desiredCurrency) {
    if (selectedCurrency != desiredCurrency) {
      selectedCurrency = desiredCurrency;
      getExchangeRate();
    }
  }

  void updateUi(dynamic coinData) {
    setState(() {
      // check for null
      if (coinData == null) {
        bitcoinRate = '?';
        return;
      }
      // we have good data, parse it
      double bitcoinAccurate = coinData['rate'];
      bitcoinRate = bitcoinAccurate.toInt().toString();
      print('btc is $bitcoinRate}');
    });
  }

  void getExchangeRate() async {
    CoinData coinData = CoinData(crypto: 'BTC', currency: selectedCurrency);
    var exchangeData = await coinData.getExchangeRate();
    updateUi(exchangeData);
  }

  @override
  void initState() {
    super.initState();

    // get our datea and update ui
    getExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $bitcoinRate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            // child: Platform.isIOS ? iosPicker() : androidDropdown(),
            // child: iosPicker(),
            child: androidDropdown(),
          ),
        ],
      ),
    );
  }
}
