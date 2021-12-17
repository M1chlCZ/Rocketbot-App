import 'dart:io';

import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/models/transaction_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CoinWithdrawalView extends StatefulWidget {
  final TransactionData data;
  final String? customLocale;
  

  const CoinWithdrawalView({Key? key,required this.data, this.customLocale}) : super (key: key);

  @override
  State<CoinWithdrawalView> createState() => _CoinWithdrawalViewState();
}

class _CoinWithdrawalViewState extends State<CoinWithdrawalView> {

  @override
  void initState() {
    super.initState();
    // print(widget.data.transactionId);
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
                                child: Text(
                                  AppLocalizations.of(context)!.sentTo + " " + _formatTx(widget.data.toAddress!),
                                  style: Theme.of(context).textTheme.headline3,
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
                                      "-" + (widget.data.usdPrice! * widget.data.amount!).toStringAsFixed(3) + "  USD",
                                      style: Theme.of(context).textTheme.headline4!.copyWith(color: const Color(0xffEA3913)),
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

  void _launchURL(String url) async {
    var _url = url.replaceAll("{0}", "");
    print(_url);
    try {
      await launch(_url);
    } catch (e) {
      print(e);
    }
  }
  // void _showDetails(TransactionData td) async {
  //   Navigator.of(context).push(PageRouteBuilder(
  //       pageBuilder: (BuildContext context, _, __) {
  //         return TransactionDetailPage(transactionData: td);
  //       }, transitionsBuilder:
  //       (_, Animation<double> animation, __, Widget child) {
  //     return FadeTransition(opacity: animation, child: child);
  //   }));
  // }
  void _showDetails(TransactionData td) async {
    await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SafeArea(
            child: Builder(builder: (context) {
              var _copied = false;
              return Center(
                child: SizedBox(
                    width: 300,
                    height: MediaQuery.of(context).size.height * 0.26,
                    child: StatefulBuilder(
                        builder: (context, StateSetter setState) {
                          return Card(
                            color: const Color(0xFF1B1B1B),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 15.0,),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Stack(
                                      alignment: AlignmentDirectional.topCenter,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Text(AppLocalizations.of(context)!.txdet, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 16.0),),
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(width: 240.0,),
                                            SizedBox(
                                              width: 30.0,
                                                height: 30.0,
                                                child: NeuButton(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: Icon(Icons.clear, color: Colors.white, size: 20.0,),)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15.0,),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(AppLocalizations.of(context)!.txid,
                                      style: Theme.of(context).textTheme.headline4,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0,),
                              Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                      child:
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(text: td.transactionId.toString()));
                                          setState(() {
                                            _copied = true;
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          child: Container(
                                            color: Colors.black38,
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(td.transactionId!,
                                              style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 12.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ),
                                  IgnorePointer(
                                    child: AnimatedOpacity(
                                      duration:Duration(milliseconds: 300) ,
                                      opacity: _copied ? 1.0 : 0.0,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          child: Container(
                                            color: Colors.green,
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(AppLocalizations.of(context)!.txcopy+"\n",
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15.0, 22.0, 15.0, 0.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(text: td.transactionId.toString()));
                                          setState(() {
                                            _copied = true;
                                          });
                                        },
                                        child: SizedBox(
                                          width: 90.0,
                                          child: NeuButton(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(AppLocalizations.of(context)!.copy,
                                                style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _launchURL(td.coin!.explorerUrl! + td.transactionId!);
                                        },
                                        child: SizedBox(
                                          width: 90.0,
                                          child: NeuButton(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(AppLocalizations.of(context)!.explorer,
                                                style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],),
                                  ),

                                ],
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
}


