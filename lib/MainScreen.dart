import 'package:flutter/material.dart';

import 'Bloc/BalancesBloc.dart';
import 'Bloc/CoinPriceBloc.dart';
import 'ComponentWidgets/nButton.dart';
import 'Models/BalanceList.dart';
import 'Models/CoinGraph.dart';
import 'NetInterface/ApiResponse.dart';
import 'Widgets/CoinListView.dart';
import 'Widgets/CoinPriceGraph.dart';
import 'Widgets/TimeRangeSwitch.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _graphKey = GlobalKey<CoinPriceGraphState>();
  String _coinActive = "Merge";
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 40.0, top: 10.0, bottom: 5.0),
              child: Row(
                children: [
                  Text("Portfolio",
                      style: Theme.of(context).textTheme.headline4),
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
                        Text("\$$totalUSD", style: Theme.of(context).textTheme.headline1,),
                        Text("$totalBTC BTC", style: Theme.of(context).textTheme.headline2,),
                      ],
                    )
                  : Container(),
            ),
            SizedBox(height: 1, child: Container(color: Colors.white12,),),
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
                          return Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu1.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            label: '',
            activeIcon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu1.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu2.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            label: '',
            activeIcon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu2.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu3.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            label: '',
            activeIcon: SizedBox(
              width: 40,
              height: 40,
              child: NeuButton(
                onTap: () {},
                imageIcon: Image.asset(
                  "images/bottommenu3.png",
                  width: 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _changeTime(int time) {
    _graphKey.currentState!.changeTime(time);
  }

  _changeCoin(HistoryPrices? h) {
    _graphKey.currentState!.changeCoin(h!);
  }

  _changeCoinName(String s) {
    setState(() {
      _coinActive = s;
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
