import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QScanWidget extends StatefulWidget {
  final Function(String) scanResult;
  const QScanWidget({Key? key, required this.scanResult}) : super(key: key);

  @override
  _QScanWidgetState createState() => _QScanWidgetState();
}

class _QScanWidgetState extends State<QScanWidget> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Theme.of(context).canvasColor.withOpacity(0.5),
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(flex: 7, child: _buildQrView(context)),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(8),
                                child: NeuButton(
                                  height: 50,
                                    width: 100,
                                    onTap: () async {
                                      await controller?.toggleFlash();
                                      setState(() {});
                                    },
                                    child: FutureBuilder(
                                      future: controller?.getFlashStatus(),
                                      builder: (context, snapshot) {
                                        print(snapshot.data.toString());
                                        return SizedBox(
                                          width: 100,
                                            child: AutoSizeText(AppLocalizations.of(context)!.qr_scan_flash + ' ${snapshot.data == true ? AppLocalizations.of(context)!.qr_scan_off.toUpperCase() : AppLocalizations.of(context)!.qr_scan_on.toUpperCase()}',
                                              maxLines: 1,
                                              minFontSize: 8,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 12.0),));
                                      },
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.all(8),
                                child: NeuButton(
                                    height: 50,
                                    width: 100,
                                    onTap: () async {
                                      await controller?.flipCamera();
                                      setState(() {});
                                    },
                                    child: FutureBuilder(
                                      future: controller?.getCameraInfo(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          return SizedBox(
                                            width: 100,
                                            child: AutoSizeText(
                                              '${describeEnum(snapshot.data!) == 'front' ? AppLocalizations.of(context)!.qr_scan_back : AppLocalizations.of(context)!.qr_scan_front}',
                                                maxLines: 1,
                                                minFontSize: 8,
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 12.0)),
                                          );
                                        } else {
                                          return Text('loading', style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 14.0));
                                        }
                                      },
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SafeArea(
                child: Padding(
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
                      Text('',
                          style: Theme.of(context).textTheme.headline4),
                      const SizedBox(
                        width: 50,
                      ),
                      // SizedBox(
                      //     height: 30,
                      //     child: TimeRangeSwitcher(
                      //       changeTime: _changeTime,
                      //     )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.green,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 5,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      widget.scanResult(scanData.code!);
      controller.pauseCamera();
      Navigator.of(context).pop();
      // setState(() {
      //   result = scanData;
      // });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

