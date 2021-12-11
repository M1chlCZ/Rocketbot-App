import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/models/transaction_data.dart';
import 'package:url_launcher/url_launcher.dart';

class CoinDepositView extends StatefulWidget {
  final TransactionData data;
  final String? customLocale;
  

  const CoinDepositView({Key? key,required this.data, this.customLocale}) : super (key: key);

  @override
  State<CoinDepositView> createState() => _CoinDepositViewState();
}

class _CoinDepositViewState extends State<CoinDepositView> {

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
                _showDetails(widget.data);
                // widget.coinSwitch(widget.coin.priceData!.historyPrices!);
                // widget.activeCoin(widget.coin.coin!);
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
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top:5.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: widget.data.chainConfirmed! ? Text(
                                  "Tx id: " + _formatTx(widget.data.transactionId!),
                                  style: Theme.of(context).textTheme.headline3,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ) : Text(
                                  widget.data.confirmations!.toString() + "confirmation",
                                  style: Theme.of(context).textTheme.headline4,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // const SizedBox(
                              //   width: 4.0,
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(bottom: 1.0),
                              //   child: SizedBox(
                              //     width: 70,
                              //     child: AutoSizeText(
                              //       'dsf',
                              //       style: Theme.of(context).textTheme.subtitle2,
                              //       minFontSize: 8,
                              //       maxLines: 1,
                              //       textAlign: TextAlign.start,
                              //       overflow: TextOverflow.ellipsis,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                _getMeDate(widget.data.receivedAt),
                                style: Theme.of(context).textTheme.headline4!.copyWith(color: const Color(0xff656565)),
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
                                padding: const EdgeInsets.only(top: 2.5, right: 6.0),
                                child: SizedBox(
                                  width: 150,
                                  height: 20.0,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: AutoSizeText(
                                      // widget.free!.toString(),
                                      "+" + (widget.data.usdPrice! * widget.data.amount!).toStringAsFixed(3) + "  USD",
                                      style: Theme.of(context).textTheme.headline4!.copyWith(color: const Color(0xff1AD37A)),
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
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    // widget.coin.priceData!.prices!.usd!.toStringAsFixed(2) + "\$",
                                    // widget.coin.free!.toStringAsFixed(3),
                                    widget.data.amount.toString() + " " + widget.data.coin!.name!,
                                    style: Theme.of(context).textTheme.headline3,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 2.0),
                                //   child: PriceBadge(percentage:widget.coin.priceData!.priceChange24HPercent!.usd!,),
                                // ),
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
                            icon: const Icon(Icons.arrow_right, color: Colors.white70,),
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
  String _formatTx(String s) {
    var firstPart = s.substring(0,3);
    var lastPart = s.substring(s.length - 3);
    return firstPart + "..." + lastPart;
  }
  String _getMeDate(String? d) {
    if (d == null) return "";
    var date = DateTime.parse(d);
    var format = DateFormat.yMd(Platform.localeName).add_jm();
    return format.format(date);
  }

  void _showDetails(TransactionData td) async {
    await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return SafeArea(
        child: Builder(builder: (context) {
          return Center(
              child: SizedBox(
                width: 400,
                height: 500,
                child: StatefulBuilder(
                    builder: (context, snapshot) {
                      return Card(
                        color: const Color(0xFF1B1B1B),
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                              SizedBox(
                                width: 100,
                                child: CachedNetworkImage(
                                  imageUrl:'https://app.rocketbot.pro/coins/' + td.coin!.imageBig!,
                                  // progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  //     CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                  fit: BoxFit.fitWidth,),
                              ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text('Deposit transaction',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text('TX id:',
                                    style: Theme.of(context).textTheme.headline4,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(td.transactionId!,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text('Confirmations:  ' + td.confirmations!.toString(),
                                    style: Theme.of(context).textTheme.headline4,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text('Date:  ' + _getMeDate(td.receivedAt!),
                                    style: Theme.of(context).textTheme.headline4,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text('Amount:  ' + td.amount!.toString(),
                                    style: Theme.of(context).textTheme.headline4,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _launchURL(td.coin!.explorerUrl! + td.transactionId!);
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text('Launch explorer',
                                      style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.blue),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );})),);
        }),
      );
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context)
        .modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 150));
  }
  void _launchURL(String URL) async {
    var url = URL.replaceAll("{0}", "");
    print(url);
    try {
      await launch(url);
    } catch (e) {
      print(e);
    }
  }
}
