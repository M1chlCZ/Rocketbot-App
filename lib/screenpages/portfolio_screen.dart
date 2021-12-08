import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/Bloc/balance_bloc.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/Models/balance_list.dart';
import 'package:rocketbot/Models/coin.dart';
import 'package:rocketbot/Models/coin_graph.dart';
import 'package:rocketbot/NetInterface/api_response.dart';
import '../Widgets/coin_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PortfolioScreen extends StatefulWidget {
  final Function(Coin? coin) coinSwitch;

  const PortfolioScreen({Key? key, required this.coinSwitch}) : super(key: key);

  @override
  PortfolioScreenState createState() => PortfolioScreenState();
}

class PortfolioScreenState extends State<PortfolioScreen> {
  BalancesBloc? _bloc;
  List<CoinBalance>? listCoins;

  double totalUSD = 0.0;
  double totalBTC = 0.0;

  bool portCalc = false;

  @override
  void initState() {
    super.initState();
    _bloc = BalancesBloc();
  }

  @override
  void dispose() {
    _bloc!.dispose();
    super.dispose();
  }

  Matrix4 scaleXYZTransform({
    double scaleX = 1.05,
    double scaleY = 1.00,
    double scaleZ = 0.00,
  }) {
    return Matrix4.diagonal3Values(scaleX, scaleY, scaleZ);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<CoinBalance> getList() {
    return listCoins!;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 10.0, bottom: 0.0),
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.helloWorld, style: Theme.of(context).textTheme.headline4),
                    const SizedBox(
                      width: 50,
                    ),
                    // SizedBox(
                    //     height: 30,
                    //     child: TimeRangeSwitcher(
                    //       changeTime: _changeTime,
                    //     )),
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
                              icon: const Icon(
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
                    ? Stack(
                        // alignment: AlignmentDirectional.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0, right: 10.0, top: 50.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Transform(
                                transform: scaleXYZTransform(),
                                child: const Image(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage("images/wave.png"),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 170.0, right: 0.0, top: 90.0),
                            child:
                            Transform.scale(
                              scale: 0.35,
                              child: const Image(
                                  image: AssetImage("images/rocket_pin.png"),
                              ),
                            ),
                          ),
                           const Align(
                             alignment: Alignment.center,
                             child: Padding(
                               padding: EdgeInsets.only(bottom: 98.0),
                               child: AspectRatio(
                                 aspectRatio: 1.6,
                                 child:
                                 Image(
                                   fit: BoxFit.fitWidth,
                                     image: AssetImage("images/price_frame.png")
                                 ),
                               ),
                             ),
                           ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 130.0, top: 25.0),
                            child: Center(
                              child: Column(
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
                              ),
                            ),
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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _bloc!.fetchBalancesList(),
                  child: StreamBuilder<ApiResponse<List<CoinBalance>>>(
                    stream: _bloc!.coinsListStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            listCoins = null;
                            return Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: SizedBox(
                                child: portCalc
                                    ? Container()
                                    : const CircularProgressIndicator(),
                              ),
                            );
                          case Status.COMPLETED:
                            if(listCoins == null) {
                              listCoins = snapshot.data!.data!;
                              _calculatePortfolio();
                            }
                            return ListView.builder(
                                itemCount: snapshot.data!.data!.length,
                                itemBuilder: (ctx, index) {
                                  return CoinListView(
                                    coin: snapshot.data!.data![index],
                                    free: snapshot.data!.data![index].free!,
                                    coinSwitch: _changeCoin,
                                    activeCoin: widget.coinSwitch,
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
          Visibility(
            visible:!portCalc,
            child: Container(
              color: const Color(0xFF1B1B1B),
              child: Center(
                child: HeartbeatProgressIndicator(
                  startScale: 0.01,
                  endScale: 0.2,
                  child: const Image(
                    image: AssetImage('images/rocketbot_logo.png'),
                    color: Colors.white30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _changeCoin(HistoryPrices? h) {
    // _graphKey.currentState!.changeCoin(h!);
  }

  _calculatePortfolio() {
    totalUSD = 0;
    totalBTC = 0;
    for (var element in listCoins!) {
          double? _freeCoins = element.free;
          double? _priceUSD = element.priceData!.prices!.usd;
          double? _priceBTC = element.priceData!.prices!.btc;

          double _usd = _freeCoins! * _priceUSD!;
          totalUSD += _usd;
          double _btc = _freeCoins * _priceBTC!;
          totalBTC += _btc;
        }

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        portCalc = true;
      });
    });
  }
}
