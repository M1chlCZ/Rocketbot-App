
import 'package:rocketbot/NetInterface/interface.dart';
import 'package:rocketbot/models/get_withdraws.dart';

class TransactionList {
  final NetInterface _helper = NetInterface();

  Future<List<Data>?> fetchTransactions(int coinID) async {
    final deposits = await _helper.get("Transfers/GetDeposits?page=1&pageSize=10&coinId=$coinID");
    final withdrawals = await _helper.get("Transfers/GetWithdraws?page=1&pageSize=10&coinId=$coinID");
    List<Data>? r = WithdrawalsModels.fromJson(withdrawals).data;
    // List<Data> finalList = [];
    //
    // await Future.forEach(r!, (item) async {
    //   try {
    //     var coinBal = (item as CoinBalance);
    //     var coin = coinBal.coin;
    //     String? coinID = coin!.coinGeckoId;
    //     final price = priceData['data'][coinID!];
    //     PriceData? p = PriceData.fromJson(price);
    //     coinBal.setPriceData(p);
    //     finalList.add(coinBal);
    //
    //   } catch (e) {
    //     // print(e);
    //   }
    // });
    return r;
  }
}
