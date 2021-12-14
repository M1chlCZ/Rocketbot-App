import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:rocketbot/models/transaction_data.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionDetailPage extends StatefulWidget {
  final TransactionData transactionData;

  const TransactionDetailPage({Key? key, required this.transactionData})
      : super(key: key);

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  var _receive = true;
  var _confirmed = false;

  @override
  void initState() {
    super.initState();
    if (widget.transactionData.toAddress != null) {
      _receive = false;
    } else {
      _receive = true;
    }
    if(widget.transactionData.chainConfirmed == true) {
      _confirmed = true;
    }else{
      _confirmed = false;
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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

  Matrix4 scaleXYZTransform({
    double scaleX = 1.05,
    double scaleY = 1.00,
    double scaleZ = 0.00,
  }) {
    return Matrix4.diagonal3Values(scaleX, scaleY, scaleZ);
  }

  String _getMeText(TransactionData td) {
    if (td.chainConfirmed == true) {
      if (td.toAddress != null) {
        return 'Sent!';
      } else {
        return 'Received!';
      }
    } else {
      return 'Pending..';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
          child: Row(
            children: [
              SizedBox(
                height: 30,
                width: 25,
                child: NeuButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20.0,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              if (widget.transactionData.toAddress != null)
                SizedBox(
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 1.0),
                    child: Center(
                        child: Text(
                      'SEND',
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                          color: Colors.white),
                    )),
                  ),
                )
              else
                SizedBox(
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                    child: Center(
                        child: Text(
                      'RECEIVE',
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                          color: Colors.white),
                    )),
                  ),
                ),
              const SizedBox(
                width: 50,
              ),
            ],
          ),
        ),
        SizedBox(
            width: double.infinity,
            height: 250,
            child: Stack(
              // alignment: AlignmentDirectional.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, right: 10.0, top: 50.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Transform(
                      transform: scaleXYZTransform(),
                      child: Image(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(_confirmed ? "images/confirmed_wave.png" : "images/pending_wave.png"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 175.0, right: 0.0, top: 95.0),
                  child: Transform.scale(
                    scale: 0.35,
                    child: Image(
                      image: AssetImage(_confirmed ? "images/confirmed_rocket_pin.png" : "images/pending_rocket_pin.png"),
                    ),
                  ),
                ),
                 Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 150.0),
                    child: SizedBox(
                      width: 60.0,
                      child: Image(
                          fit: BoxFit.fitWidth,
                          image: AssetImage( _confirmed ? "images/confirmed_icon.png"  : "images/pending_icon.png")),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, bottom: 60.0, top: 25.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 90,
                          child: AutoSizeText(
                            _getMeText(widget.transactionData),
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18.0),
                            minFontSize: 8.0,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Container(
            height: 0.5,
            color: Colors.white24,
          ),
        ),
        Column(
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
                                        widget.transactionData.toAddress != null ? "Sent to: " + _formatTx(widget.transactionData.toAddress!) : "Tx id: " + _formatTx(widget.transactionData.transactionId!),
                                        // "Sent to: " + _formatTx(widget.data.toAddress!),
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
                                    child: _confirmed ? Text(
                                        _getMeDate(widget.transactionData.receivedAt),
                                      style: Theme.of(context).textTheme.headline4!.copyWith(color: const Color(0xff656565), fontSize: 12.0),
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ) : Text(
                                      widget.transactionData.confirmations.toString() + "confirmations",
                                      style: Theme.of(context).textTheme.headline4,
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
                                        "-" + (widget.transactionData.usdPrice! * widget.transactionData.amount!).toStringAsFixed(3) + "  USD",
                                        style: Theme.of(context).textTheme.headline4!.copyWith(color: _receive ? const Color(0xff1AD37A) : const Color(0xffEA3913)),
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
                                      '',
                                      // widget.data.amount.toString() + " " + widget.data.coin!.name!,
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
                    ],
                  ),
                )),
          ],

        ),
      ]),
    ));
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
}
