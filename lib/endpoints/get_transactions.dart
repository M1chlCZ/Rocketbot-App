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
    final price = await _helper.get("Coin/GetPriceData?coin=$coinID&IncludeHistoryPrices=false&IncludeVolume=false&IncludeMarketcap=false&IncludeChange=true");

    List<DataWithdrawals>? _with = WithdrawalsModels.fromJson(_withdrawals).data;
    List<DataDeposits>? _dep = DepositsModel.fromJson(_deposits).data;
    List<TransactionData> _finalList = [];

    double? priceValue;

    await Future.forEach(_dep!, (item) async {
      try {
        var it = (item as DataDeposits);
        if(priceValue == null) {
          CoinGraph cg = CoinGraph.fromJson(price, item.coin!.coinGeckoId!);
          priceValue = cg.data!.prices!.usd;
        }
        TransactionData d = TransactionData.fromCustom(
            coin: it.coin,
            amount: it.amount,
            receivedAt: it.receivedAt,
            transactionId: it.transactionId,
            chainConfirmed: it.isConfirmed,
            confirmations: it.confirmations,
            usdPrice: priceValue);
        _finalList.add(d);

      } catch (e) {
        print(e);
      }
    });

    await Future.forEach(_with!, (item) {
      try {
        var it = (item as DataWithdrawals);
        if(priceValue == null) {
          CoinGraph cg = CoinGraph.fromJson(price, item.coin!.coinGeckoId!);
          priceValue = cg.data!.prices!.usd;
        }
        TransactionData d = TransactionData.fromCustom(
          coin: it.coin,
          amount: it.amount,
          toAddress: it.toAddress,
          receivedAt: it.createdAt,
          transactionId: it.transactionId,
          chainConfirmed: it.chainConfirmed,
          usdPrice: priceValue,
        );
        _finalList.add(d);
      }catch(e) {
        print(e);
      }
    });

    _finalList.sort((a,b) {
      var A = DateTime.parse(a.receivedAt!);
      var B = DateTime.parse(b.receivedAt!);
      return A.compareTo(B);
    });

    return _finalList;
  }
}
