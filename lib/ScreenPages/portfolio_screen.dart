import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rocketbot/Bloc/BalancesBloc.dart';
import 'package:rocketbot/Bloc/CoinPriceBloc.dart';
import 'package:rocketbot/ComponentWidgets/nButton.dart';
import 'package:rocketbot/Models/BalanceList.dart';
import 'package:rocketbot/Models/CoinGraph.dart';
import 'package:rocketbot/NetInterface/ApiResponse.dart';
import 'package:rocketbot/Widgets/CoinListView.dart';
import 'package:rocketbot/Widgets/TimeRangeSwitch.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  BalancesBloc? _bloc;
  CoinPriceBloc? _priceBlock;

  double totalUSD = 0.0;
  double totalBTC = 0.0;

  bool portCalc = false;

  @override
  void initState() {
    super.initState();
    _bloc = BalancesBloc();
    _priceBlock = CoinPriceBloc("merge");
  }

  @override
  void dispose() {
    _bloc!.dispose();
    _priceBlock!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 10.0, bottom: 5.0),
            child: Row(
              children: [
                Text("Portfolio", style: Theme.of(context).textTheme.headline4),
                SizedBox(
                  width: 50,
                ),
                SizedBox(
                    height: 30,
                    child: TimeRangeSwitcher(
                      changeTime: _changeTime,
                    )),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        height: 30,
                        width: 25,
                        child: NeuButton(
                          onTap: () {},
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 250,
            child: portCalc
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\$$totalUSD",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        "$totalBTC BTC",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ],
                  )
                : Container(),
          ),
          SizedBox(
            height: 0.5,
            child: Container(
              color: portCalc ? Colors.white12 : Colors.transparent,
            ),
          ),
          // SizedBox(
          //     width: double.infinity,
          //     height: 250,
          //     child: StreamBuilder<ApiResponse<PriceData>>(
          //       stream: _priceBlock!.coinsListStream,
          //       builder: (BuildContext context, snapshot) {
          //         if (snapshot.hasData) {
          //           switch (snapshot.data!.status) {
          //             case Status.COMPLETED:
          //               return Stack(
          //                 children: [
          //                   Align(
          //                       alignment: Alignment.topCenter,
          //                       child: Padding(
          //                         padding: const EdgeInsets.only(top: 20.0),
          //                         child: Text(
          //                           _coinActive,
          //                           style:
          //                               Theme.of(context).textTheme.headline2,
          //                         ),
          //                       )),
          //                   CoinPriceGraph(
          //                     key: _graphKey,
          //                     prices: snapshot.data!.data!.historyPrices,
          //                     time: 48,
          //                   ),
          //                 ],
          //               );
          //             case Status.LOADING:
          //               return Center(child: Text("loading data"));
          //             case Status.ERROR:
          //               return Center(child: Text("data error"));
          //           }
          //         } else {
          //           return Container();
          //         }
          //       },
          //     )),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _bloc!.fetchBalancesList(),
              child: StreamBuilder<ApiResponse<List<CoinBalance>>>(
                stream: _bloc!.coinsListStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data!.status) {
                      case Status.LOADING:
                        return Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: SizedBox(
                            child: portCalc
                                ? Container()
                                : CircularProgressIndicator(),
                          ),
                        );
                      case Status.COMPLETED:
                        _calculatePortfolio(snapshot.data!.data!);
                        return ListView.builder(
                            itemCount: snapshot.data!.data!.length,
                            itemBuilder: (ctx, index) {
                              return CoinListView(
                                coin: snapshot.data!.data![index],
                                free: snapshot.data!.data![index].free!,
                                coinSwitch: _changeCoin,
                                activeCoin: _changeCoinName,
                              );
                            });
                      case Status.ERROR:
                        print("error");
                        break;
                    }
                  }
                  return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _changeTime(int time) {
    // _graphKey.currentState!.changeTime(time);
  }

  _changeCoin(HistoryPrices? h) {
    // _graphKey.currentState!.changeCoin(h!);
  }

  _changeCoinName(String s) {
    setState(() {
      // _coinActive = s;
    });
  }

  _calculatePortfolio(List<CoinBalance> lc) {
    lc.forEach((element) {
      double? _freeCoins = element.free;
      double? _priceUSD = element.priceData!.prices!.usd;
      double? _priceBTC = element.priceData!.prices!.btc;

      double _usd = _freeCoins! * _priceUSD!;
      totalUSD += _usd;
      double _btc = _freeCoins * _priceBTC!;
      totalBTC += _btc;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        portCalc = true;
      });
    });
  }
}
