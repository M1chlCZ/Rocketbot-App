import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:rocketbot/models/coin.dart';
import 'package:rocketbot/models/fees.dart';
import 'package:rocketbot/models/get_withdraws.dart';
import 'package:rocketbot/netinterface/app_exception.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/qr_code_scanner.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class SendPage extends StatefulWidget {
  final Coin? coinActive;
  final double? free;

  const SendPage({Key? key, this.coinActive, this.free}) : super(key: key);

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  NetInterface _interface = NetInterface();

  Coin? _coinActive;
  bool _curtain = true;
  bool _copyIconVisible = true;
  bool _error = false;
  double _free = 0.0;
  double _fee = 0.0;
  double _min = 0.0;
  String _feeCrypto = '';

  @override
  void initState() {
    super.initState();
    _coinActive = widget.coinActive!;
    _getFees();
    _addressController.text = '';
    _addressController.addListener(() {
      if (_addressController.text.length == 0) {
        setState(() {
          _copyIconVisible = true;
        });
      } else {
        setState(() {
          _copyIconVisible = false;
        });
      }
    });
    _curtain = false;
  }

  _getFees() async {
    try {
      _free = widget.free!;
      final response = await _interface
          .get("Transfers/GetWithdrawFee?coinId=${widget.coinActive!.id!}");
      var d = Fees.fromJson(response);
      setState(() {
        _feeCrypto = d.data!.feeCrypto!.ticker!;
        _fee = d.data!.fee!;
        _min = d.data!.crypto!.minWithdraw!;
        print(_min.toString());
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
      print(e);
    }
  }

  _createWithdrawal() async {
    Map<String, dynamic> _query = {
      "coinId": widget.coinActive!.id!,
      "fee": _fee,
      "amount": double.parse(_amountController.text),
      "toAddress": _addressController.text
    };
    try {
      final response = await _interface
              .post("Transfers/CreateWithdraw", _query);
      // print(response.toString());
    } on BadRequestException catch (r, e) {
      int messageStart = r.toString().indexOf("{");
      int messageEnd = r.toString().indexOf("}");
      var s = r.toString().substring(messageStart,messageEnd + 1);
      var js = json.decode(s);
      var wm = WithdrawalsModels.fromJson(js);
      // _showError(wm.error!);

      Dialogs.openAlertBox(context, wm.message!, wm.error!);

    } catch (e) {
      print(e);
    }
  }


  _getClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    print(data!.text!);
    setState(() {
      if (data.text != null) _addressController.text = data.text!;
      _addressController.selection =
          TextSelection.collapsed(offset: _addressController.text.length);
    });
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
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
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
                      Text(AppLocalizations.of(context)!.send,
                          style: Theme.of(context).textTheme.headline4),
                      const SizedBox(
                        width: 50,
                      ),
                      // SizedBox(
                      //   width: 90.0,
                      //   child: StreamBuilder<ApiResponse<List<CoinBalance>>>(
                      //     stream: _bloc!.coinsListStream,
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData) {
                      //         switch (snapshot.data!.status) {
                      //           case Status.LOADING:
                      //             listCoins = null;
                      //             Future.delayed(Duration(milliseconds: 100), () {
                      //               setState(() {
                      //                 _finished = true;
                      //               });
                      //             });
                      //             return Padding(
                      //               padding: const EdgeInsets.only(top: 30.0),
                      //               child: SizedBox(
                      //                 child: _finished
                      //                     ? Container()
                      //                     : const CircularProgressIndicator(),
                      //               ),
                      //             );
                      //           case Status.COMPLETED:
                      //             Future.delayed(Duration(milliseconds: 500), () {
                      //               setState(() {
                      //                 _finished = false;
                      //               });
                      //             });
                      //             if (listCoins == null) {
                      //               listCoins = snapshot.data!.data!;
                      //               widget.passBalances(listCoins);
                      //               if(_coinActive == null) {
                      //                 _coinActive = listCoins![0].coin!;
                      //                 _free = listCoins![0].free!;
                      //               };
                      //               // _calculatePortfolio();
                      //             }
                      //             return SizedBox(
                      //               height: 30,
                      //               child: NeuContainer(
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.only(left: 8.0),
                      //                     child: Center(
                      //                       child: DropdownButtonHideUnderline(
                      //                         child: DropdownButton<Coin>(
                      //                           value: _coinActive,
                      //                           isDense: true,
                      //                           onChanged: (Coin? coin) {
                      //                             setState(() {
                      //                               _coinActive = coin!;
                      //                               final index = listCoins!.indexWhere((element) =>
                      //                               element.coin == coin);
                      //                               _free = listCoins![index].free!;
                      //                               // _priceBlock!.changeCoin(coin.coinGeckoId!);
                      //                               // _coinNameOpacity = 0.0;
                      //                               // _txBloc!.changeCoin(coin);
                      //                             });
                      //                             // _calculatePortfolio();
                      //                           },
                      //                           items: listCoins!
                      //                               .map((e) => DropdownMenuItem(
                      //                               value: e.coin!,
                      //                               child: SizedBox(
                      //                                   width: 50,
                      //                                   child: Text(e.coin!.cryptoId!))))
                      //                               .toList(),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   )),
                      //             );
                      //           case Status.ERROR:
                      //             Future.delayed(Duration(milliseconds: 500), () {
                      //               setState(() {
                      //                 _finished = false;
                      //               });
                      //             });
                      //             print("error");
                      //             break;
                      //         }
                      //       }
                      //       return Container();
                      //     },
                      //   ),
                      // ),
                      const SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              height: 30,
                              width: 25,
                              child: NeuButton(
                                onTap: () async {},
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
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 100.0,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _coinActive == null
                          ? Icon(
                              Icons.monetization_on,
                              size: 50.0,
                              color: Colors.white,
                            )
                          : SizedBox(
                              width: 50.0,
                              height: 50.0,
                              child: CachedNetworkImage(
                                imageUrl: 'https://app.rocketbot.pro/coins/' +
                                    _coinActive!.imageSmall!,
                                // progressIndicatorBuilder: (context, url, downloadProgress) =>
                                //     CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      SizedBox(
                        height: 65.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    _coinActive == null
                                        ? AppLocalizations.of(context)!
                                            .choose_coin
                                        : _coinActive!.ticker!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(fontSize: 18.0),
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: SizedBox(
                                    width: 70,
                                    child: AutoSizeText(
                                      _coinActive == null
                                          ? 'Token'
                                          : _coinActive!.name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0),
                                      minFontSize: 8,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0.0),
                                  child: Text(
                                    _free.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(fontSize: 18.0),
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                NeuContainer(
                  height: 30.0,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Stack(
                    children: [
                      TextField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z0-9]+')),
                          ],
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white, fontSize: 12.0),
                          autocorrect: false,
                          controller: _addressController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            isDense: false,
                            contentPadding: const EdgeInsets.only(bottom: 16.0),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: Colors.white54, fontSize: 12.0),
                            hintText: AppLocalizations.of(context)!.address,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          )),
                      Visibility(
                        visible: _copyIconVisible,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                _getClipBoardData();
                              },
                              child: Image.asset(
                                'images/copy.png',
                                width: 18.0,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                NeuContainer(
                  height: 30.0,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: TextField(
                      keyboardType: Platform.isIOS
                          ? TextInputType.numberWithOptions(signed: true)
                          : TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,8}')),
                      ],
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white, fontSize: 12.0),
                      autocorrect: false,
                      controller: _amountController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        isDense: false,
                        contentPadding: const EdgeInsets.only(bottom: 16.0),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .subtitle2!
                            .copyWith(color: Colors.white54, fontSize: 12.0),
                        hintText: AppLocalizations.of(context)!.amount,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                AnimatedOpacity(
                  opacity: _feeCrypto.isNotEmpty ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.min_withdraw + ':',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.white54)),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(_min.toString() + ' ' +  widget.coinActive!.ticker!.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.white54)),
                            const SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.fees + ':',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.white54)),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(_fee.toString() + ' ' + _feeCrypto,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(color: Colors.white54)),
                            const SizedBox(
                              width: 10.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                _error
                    ? Text(
                        AppLocalizations.of(context)!.dp_error,
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(fontWeight: FontWeight.bold, color: Colors.red.withOpacity(0.5)),
                      )
                    : NeuButton(
                        height: 30.0,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Text(
                          AppLocalizations.of(context)!.send,
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                  onTap: () {_createWithdrawal();},
                      ),
                const SizedBox(
                  height: 40.0,
                ),
                Container(
                  height: 0.5,
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  color: Colors.white30,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  AppLocalizations.of(context)!.or_send_scan_qr,
                  style: Theme.of(context).textTheme.headline3,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                NeuButton(
                  onTap: () {
                    _openQRScanner();
                  },
                  width: 200,
                  height: 200,
                  child: Image.asset("images/qr_code_scan.png"),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _curtain,
            child: Container(
              margin: EdgeInsets.only(top: 50),
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

  _openQR(context, String qr) async {
    showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
            child: Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xFF9F9FA4)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Wrap(children: [
                Container(
                  width: 400.0,
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0, bottom: 2.0),
                          child: SizedBox(
                            width: 380,
                            child: AutoSizeText(
                              "Send address",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 8.0,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                      fontSize: 22.0, color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: Text(
                        '(tap to copy, long press to share)',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontSize: 14.0, color: Colors.black54),
                      )),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 4.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(new ClipboardData(text: qr));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("QR code copied to clipboard"),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.fixed,
                              elevation: 5.0,
                            ));
                            Navigator.pop(context);
                          },
                          onLongPress: () {
                            Vibration.vibrate(duration: 200);
                            Share.share(qr);
                            Navigator.pop(context);
                          },
                          child: QrImage(
                            dataModuleStyle: QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square),
                            eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square),
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                            data: qr.toString(),
                            foregroundColor: Colors.black87,
                            version: QrVersions.auto,
                            // size: 250,
                            gapless: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          );
        });
  }

  void _openQRScanner() async {
    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 200), () async {
      var status = await Permission.camera.status;
      if (await Permission.camera.isPermanentlyDenied) {
        // await Dialogs.openAlertBoxReturn(context, "Warning", "Please grant this app permissions for Camera");
        openAppSettings();
      } else if (status.isDenied) {
        var r = await Permission.camera.request();
        if (r.isGranted) {
          Navigator.of(context).push(new PageRouteBuilder(
              pageBuilder: (BuildContext context, _, __) {
            return QScanWidget(
              scanResult: (String s) {
                _addressController.text = s;
              },
            );
          }, transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
            return new FadeTransition(opacity: animation, child: child);
          }));
        }
      } else {
        Navigator.of(context).push(new PageRouteBuilder(
            pageBuilder: (BuildContext context, _, __) {
          return QScanWidget(
            scanResult: (String s) {
              _addressController.text = s;
            },
          );
        }, transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(opacity: animation, child: child);
        }));
      }
    });
  }
}
