import 'package:bitcoin_ticker/coin_data.dart';
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
  String ethereumRate = '?';
  String litecoinRate = '?';

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

  void updateUi(dynamic coinData, String currentCrypto) {
    setState(() {
      // check for null
      if (coinData == null) {
        if (currentCrypto == 'BTC') {
          bitcoinRate = '?';
        } else if (currentCrypto == 'ETH') {
          ethereumRate = '?';
        } else if (currentCrypto == 'LTC') {
          litecoinRate = '?';
        }
        return;
      }
      // we have good data, parse it
      double rateAccurate = coinData['rate'];
      if (currentCrypto == 'BTC') {
        bitcoinRate = rateAccurate.toInt().toString();
        print('btc is $bitcoinRate');
      } else if (currentCrypto == 'ETH') {
        ethereumRate = rateAccurate.toInt().toString();
        print('etc is $ethereumRate');
      } else if (currentCrypto == 'LTC') {
        litecoinRate = rateAccurate.toInt().toString();
        print('ltc is $litecoinRate');
      }
    });
  }

  void getExchangeRate() async {
    // reset our rates
    bitcoinRate = '?';
    ethereumRate = '?';
    litecoinRate = '?';
    // loop through all three currencies
    for (String cryptoCurrency in cryptoList) {
      CoinData coinData =
          CoinData(crypto: cryptoCurrency, currency: selectedCurrency);
      var exchangeData = await coinData.getExchangeRate();
      updateUi(exchangeData, cryptoCurrency);
    }
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
          exchangeRateCard(
              cryptoCurrency: cryptoList[0],
              realCurrency: selectedCurrency,
              exchangeRate: bitcoinRate),
          exchangeRateCard(
              cryptoCurrency: cryptoList[1],
              realCurrency: selectedCurrency,
              exchangeRate: ethereumRate),
          exchangeRateCard(
              cryptoCurrency: cryptoList[2],
              realCurrency: selectedCurrency,
              exchangeRate: litecoinRate),
          SizedBox(height: 200.0),
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

  Padding exchangeRateCard(
      {@required String cryptoCurrency,
      @required String realCurrency,
      @required String exchangeRate}) {
    return Padding(
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
            '1 $cryptoCurrency = $exchangeRate $realCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
