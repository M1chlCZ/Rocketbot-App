import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rocketbot/Bloc/BalancesBloc.dart';
import 'package:rocketbot/Bloc/CoinPriceBloc.dart';
import 'package:rocketbot/Models/BalanceList.dart';
import 'package:rocketbot/Widgets/CoinListView.dart';

import 'Bloc/CoinsBloc.dart';
import 'ComponentWidgets/nContainer.dart';
import 'Models/CoinGraph.dart';
import 'Widgets/CoinPriceGraph.dart';
import 'Widgets/PriceBadge.dart';
import 'Support/MaterialColorGenerator.dart';
import 'ComponentWidgets/nButton.dart';
import 'Models/Coin.dart';
import 'NetInterface/ApiResponse.dart';
import 'Widgets/TimeRangeSwitch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Montserrat",
        canvasColor: Color(0xFF1B1B1B),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 24.0,
          ),
          headline2: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
          headline3: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
          headline4: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
          subtitle1: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 10.0,
          ),
          subtitle2: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontWeight: FontWeight.w400,
            fontSize: 10.0,
          ),
        ),
        primarySwatch: generateMaterialColor(Colors.white),
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _graphKey =  GlobalKey<CoinPriceGraphState>();
  BalancesBloc? _bloc;
  CoinPriceBloc? _priceBlock;

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
                  SizedBox(height: 30, child: TimeRangeSwitcher(
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
                child: StreamBuilder<ApiResponse<PriceData>>(
                  stream: _priceBlock!.coinsListStream,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.COMPLETED:
                          return CoinPriceGraph(
                            key: _graphKey,
                            prices: snapshot.data!.data!.historyPrices,
                            time: 48,
                          );
                          break;
                        case Status.LOADING:
                          return Center(child: Text("loading data"));
                        case Status.ERROR:
                          return Center(child: Text("data error"));
                      }
                    } else {
                      return Container();
                    }
                  },
                )),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _bloc!.fetchBalancesList(),
                child: StreamBuilder<ApiResponse<List<CoinBalance>>>(
                  stream: _bloc!.coinsListStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:

                          break;
                        case Status.COMPLETED:
                          return ListView.builder(
                              itemCount: snapshot.data!.data!.length,
                              itemBuilder: (ctx, index) {
                                return CoinListView(
                                  coin: snapshot.data!.data![index].coin!,
                                  free: snapshot.data!.data![index].free!,
                                );
                              });
                          break;
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
}
