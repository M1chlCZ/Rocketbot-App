import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../Bloc/CoinPriceBloc.dart';
import '../ComponentWidgets/nButton.dart';
import '../ComponentWidgets/nContainer.dart';
import '../Models/BalanceList.dart';
import '../Models/Coin.dart';
import '../Models/CoinGraph.dart';
import '../NetInterface/ApiResponse.dart';
import '../Widgets/CoinPriceGraph.dart';
import '../Widgets/PriceBadge.dart';
import '../Widgets/TimeRangeSwitch.dart';

class CoinScreen extends StatefulWidget {
  final Coin activeCoin;
  final VoidCallback goBack;
  final List<CoinBalance>? allCoins;

  const CoinScreen(
      {Key? key, required this.activeCoin, this.allCoins, required this.goBack})
      : super(key: key);

  @override
  _CoinScreenState createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  var _graphKey = GlobalKey<CoinPriceGraphState>();
  late List<CoinBalance> _listCoins;
  late Coin _coinActive;
  double _percentage = 0.0;

  CoinPriceBloc? _priceBlock;

  double totalCoins = 0.0;
  double totalUSD = 0.0;
  double btcCost = 0.0;

  bool portCalc = false;

  @override
  void initState() {
    super.initState();
    _coinActive = widget.activeCoin;
    _listCoins = widget.allCoins!;
    _calculatePortfolio();
    _priceBlock = CoinPriceBloc(widget.activeCoin.coinGeckoId!);
  }

  @override
  void dispose() {
    _priceBlock!.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
            child: Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 25,
                  child: NeuButton(
                    onTap: () {
                      widget.goBack();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20.0,
                      color: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                if (_listCoins.isNotEmpty)
                  SizedBox(
                    height: 30,
                    child: NeuContainer(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Coin>(
                            value: _coinActive,
                            isDense: true,
                            onChanged: (Coin? coin) {
                              setState(() {
                                _coinActive = coin!;
                                _priceBlock!.changeCoin(coin.coinGeckoId!);
                              });
                              _calculatePortfolio();
                            },
                            items: _listCoins
                                .map((e) => DropdownMenuItem(
                                    value: e.coin!,
                                    child: SizedBox(
                                        width: 50,
                                        child: Text(e.coin!.cryptoId!))))
                                .toList(),
                          ),
                        ),
                      ),
                    )),
                  )
                else
                  Container(),
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
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 250,
                child: portCalc
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$totalCoins " + _coinActive.name!,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "\$$totalUSD",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              SizedBox(width: 5.0),
                              PriceBadge(
                                percentage: _percentage,
                              ),
                            ],
                          )
                        ],
                      )
                    : Container(),
              ),
              SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: StreamBuilder<ApiResponse<PriceData>>(
                    stream: _priceBlock!.coinsListStream,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.COMPLETED:
                            Future.delayed(const Duration(milliseconds: 1000),
                                () {
                              setState(() {
                                portCalc = true;
                              });
                            });
                            return Stack(
                              children: [
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            _coinActive.name!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "\$$totalUSD",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline2,
                                              ),
                                              SizedBox(width: 5.0),
                                              PriceBadge(
                                                percentage: _percentage,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                CoinPriceGraph(
                                  key: _graphKey,
                                  prices: snapshot.data!.data!.historyPrices,
                                  time: 48,
                                ),
                              ],
                            );
                          case Status.LOADING:
                            // return Center(child: Text("loading data"));
                            return HeartbeatProgressIndicator(
                              child: Icon(
                                Icons.access_time_sharp,
                                color: Colors.white30,
                              ),
                            );
                          case Status.ERROR:
                            return Center(child: Text("data error"));
                        }
                      } else {
                        return Container();
                      }
                    },
                  )),
            ],
          ),
          // Expanded(
          //   child: RefreshIndicator(
          //     onRefresh: () => _bloc!.fetchBalancesList(),
          //     child: StreamBuilder<ApiResponse<List<CoinBalance>>>(
          //       stream: _bloc!.coinsListStream,
          //       builder: (context, snapshot) {
          //         if (snapshot.hasData) {
          //           switch (snapshot.data!.status) {
          //             case Status.LOADING:
          //               return Padding(
          //                 padding: EdgeInsets.only(top: 30.0),
          //                 child: SizedBox(
          //                   child: portCalc
          //                       ? Container()
          //                       : CircularProgressIndicator(),
          //                 ),
          //               );
          //             case Status.COMPLETED:
          //               _calculatePortfolio(snapshot.data!.data!);
          //               return ListView.builder(
          //                   itemCount: snapshot.data!.data!.length,
          //                   itemBuilder: (ctx, index) {
          //                     return CoinListView(
          //                       coin: snapshot.data!.data![index],
          //                       free: snapshot.data!.data![index].free!,
          //                       coinSwitch: _changeCoin,
          //                       activeCoin: _changeCoinName,
          //                     );
          //                   });
          //             case Status.ERROR:
          //               print("error");
          //               break;
          //           }
          //         }
          //         return Container();
          //       },
          //     ),
          //   ),
          // ),
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

  _calculatePortfolio() {
    setState(() {
      portCalc = false;
    });
    _listCoins.forEach((element) {
      if (element.coin == _coinActive) {
        double? _freeCoins = element.free;
        double? _priceUSD = element.priceData!.prices!.usd;
        double? _priceBTC = element.priceData!.prices!.btc;
        _percentage = element.priceData!.priceChange24HPercent!.usd!;
        btcCost = element.priceData!.priceChange24HPercent!.usd!;

        totalCoins = _freeCoins!;
        double _btc = _freeCoins * _priceUSD!;
        totalUSD += _btc;
      }
    });
  }
}
