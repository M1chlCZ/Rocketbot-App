
import 'package:rocketbot/NetInterface/interface.dart';
import 'package:rocketbot/models/coin_graph.dart';
import 'package:rocketbot/models/get_deposits.dart';
import 'package:rocketbot/models/get_withdraws.dart';
import 'package:rocketbot/models/transaction_data.dart';

class TransactionList {
  final NetInterface _helper = NetInterface();

  Future<List<TransactionData>?> fetchTransactions(int coinID) async {
    final _deposits = await _helper.get("Transfers/GetDeposits?page=1&pageSize=10&coinId=$coinID");
    final _withdrawals = await _helper.get("Transfers/GetWithdraws?page=1&pageSize=10&coinId=$coinID");
    List<Data>? _r = WithdrawalsModels.fromJson(_withdrawals).data;
    List<DataDeposits>? _d = DepositsModel.fromJson(_deposits).data;
    List<TransactionData> _finalList = [];

    await Future.forEach(_d!, (item) async {
      try {
        var it = (item as DataDeposits);
        var price = await _helper.get("Coin/GetPriceData?coin=$coinID");
        CoinGraph cg = CoinGraph.fromJson(price, item.coin!.coinGeckoId!);
        TransactionData d = TransactionData.fromCustom(
            coin: it.coin,
            amount: it.amount,
            receivedAt: it.receivedAt,
            transactionId: it.transactionId,
            usdPrice: cg.data!.prices!.usd);
        print(d.coin!.name!);
        // var coin = coinBal.coin;
        // String? coinID = coin!.coinGeckoId;
        // final price = priceData['data'][coinID!];
        // PriceData? p = PriceData.fromJson(price);
        // coinBal.setPriceData(p);
        _finalList.add(d);

      } catch (e) {
        print(e);
      }
    });
    return _finalList;
  }
}
