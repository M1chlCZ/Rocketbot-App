
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:rocketbot/ComponentWidgets/nButton.dart';
import 'package:rocketbot/Models/BalanceList.dart';
import 'package:rocketbot/Models/Coin.dart';
import 'package:rocketbot/Models/CoinGraph.dart';

import 'PriceBadge.dart';

class CoinListView extends StatefulWidget {
  final CoinBalance coin;
  final String? customLocale;
  final Function(HistoryPrices? h) coinSwitch;
  final Function (Coin? coin) activeCoin;
  final double? free;

  CoinListView({required this.coin, this.customLocale, this.free, required this.coinSwitch, required this.activeCoin});

  @override
  State<CoinListView> createState() => _CoinListViewState();
}

class _CoinListViewState extends State<CoinListView> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Card(
            elevation: 0,
            color: Theme.of(context).canvasColor,
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: InkWell(
              splashColor: Colors.black54,
              highlightColor: Colors.black54,
              onTap: () {
                widget.coinSwitch(widget.coin.priceData!.historyPrices!);
                widget.activeCoin(widget.coin.coin!);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                width: 280.0,
                height: 70.0,
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.all(15.0),
                          child: Center(child:
                          SizedBox( height: 30,
                              child: CachedNetworkImage(
                                imageUrl:'https://app.rocketbot.pro/coins/' + widget.coin.coin!.imageSmall!,
                                // progressIndicatorBuilder: (context, url, downloadProgress) =>
                                //     CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.fitWidth,))),
                        )),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                    widget.coin.coin!.ticker!,
                                  style: Theme.of(context).textTheme.headline3,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 1.0),
                                child: SizedBox(
                                  width: 70,
                                  child: AutoSizeText(
                                    widget.coin.coin!.name!,
                                    style: Theme.of(context).textTheme.subtitle2,
                                    minFontSize: 8,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                  "\$"+  widget.coin.priceData!.prices!.usd!.toStringAsFixed(2),
                                style: Theme.of(context).textTheme.headline3,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0, right: 6.0),
                                child: SizedBox(
                                  width: 150,
                                  height: 20.0,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: AutoSizeText(
                                      widget.free!.toString(),
                                      style: Theme.of(context).textTheme.headline3,
                                      minFontSize: 8,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              runAlignment: WrapAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    // widget.coin.priceData!.prices!.usd!.toStringAsFixed(2) + "\$",
                                    widget.coin.free!.toStringAsFixed(3),
                                    style: Theme.of(context).textTheme.headline3,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: PriceBadge(percentage:widget.coin.priceData!.priceChange24HPercent!.usd!,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                          height: 25,
                          width: 20,
                          child: NeuButton(
                            onTap: () {},
                            icon: Icon(Icons.arrow_right, color: Colors.white70,),
                    ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: SizedBox(height: 1.0, child: Container(color: Colors.white10,),),
        )
      ],

    );
  }
}
