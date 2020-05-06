import 'package:bitcoin_ticker/networking.dart';

const coinUrl = 'https://rest.coinapi.io/v1/exchangerate';
const apikey = '71FC7075-477A-418E-B6F7-A40A1B5FE710';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  String currency;
  String crypto;

  CoinData({this.currency, this.crypto});

  Future<dynamic> getExchangeRate() async {
    String url = '$coinUrl/$crypto/$currency?apikey=$apikey';
    NetworkHelper networkHelper = NetworkHelper(url);

    var coinData = await networkHelper.getData();
    return coinData;
  }
}
