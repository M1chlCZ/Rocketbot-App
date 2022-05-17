import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rocketbot/screens/portfolio_page.dart';
import 'package:rocketbot/screens/security_screen.dart';
import 'package:rocketbot/support/secure_storage.dart';
import 'package:rocketbot/widgets/screen_lock.dart';

class AuthScreen extends StatefulWidget {
  final bool setupPIN;
  final int type;

  const AuthScreen({Key? key, this.setupPIN = false, this.type = 0})
      : super(key: key);

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  List<int> _tempPIN = [];
  List<int> _tempPIN2 = [];

  bool _isFingerprint = false;
  bool _firstPIN = true;
  bool _showFinger = false;

  List<int> _myPass = [];

  @override
  void initState() {
    _getPIN();
    _getAuthType();
    super.initState();
  }

  void _getPIN() async {
    String? nums = await SecureStorage.readStorage(key: "PIN");
    if (nums == null) return;
    _myPass = nums.split('').map(int.parse).toList();
  }

  void _getAuthType() async {
    if (widget.setupPIN != true) {
      var i = await SecureStorage.readStorage(key: "AUTH_TYPE");
      if (int.parse(i!) == 0) {
        setState(() {
          _showFinger = false;
        });
      } else if (int.parse(i) == 1) {
        biometrics();
      } else {
        setState(() {
          _showFinger = true;
        });
      }
    }
  }

  Future<void> biometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          sensitiveTransaction: true,
          biometricOnly: true,
        ),
        localizedReason: 'Scan your fingerprint to authenticate',);
    } on PlatformException catch (e) {
      setState(() {
        _showFinger = false;
      });
      if (kDebugMode) {
        print(e);
      }
    }
    if (!mounted) return;
    if (authenticated) {
      setState(() {
        _isFingerprint = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Visibility(
        visible: !widget.setupPIN,
        child: IgnorePointer(
          ignoring: widget.setupPIN,
          child: Material(
            child: SafeArea(
                child: LockScreen(
                    title: AppLocalizations.of(context)!.as_enter_pin,
                    passLength: 6,
                    numColor: Colors.white70,
                    bgImage: "images/pending_rocket_pin.png",
                    fingerPrintImage: ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(colors: [
                          Color(0xFFF05523),
                          Color(0xFF812D88),
                        ]).createShader(bounds);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Image.asset(
                        "images/fingerprint.png",
                        height: 50.0,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    showFingerPass: _showFinger,
                    fingerFunction: biometrics,
                    fingerVerify: _isFingerprint,
                    borderColor: Colors.white,
                    showWrongPassDialog: false,
                    wrongPassContent:
                        AppLocalizations.of(context)!.as_wrong_pin,
                    wrongPassTitle: "Opps!",
                    wrongPassCancelButtonText: "Cancel",
                    passCodeVerify: (passcode) async {
                      for (int i = 0; i < _myPass.length; i++) {
                        if (passcode[i] != _myPass[i]) {
                          return false;
                        }
                      }

                      return true;
                    },
                    onSuccess: () {
                      if (widget.type == 0) {
                        Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder:
                            (BuildContext context, _, __) {
                          return const PortfolioScreen();
                        }, transitionsBuilder:
                            (_, Animation<double> animation, __, Widget child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        }));
                      } else if (widget.type == 2) {
                        Navigator.of(context).pop(true);
                      } else {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(PageRouteBuilder(pageBuilder:
                            (BuildContext context, _, __) {
                          return const SecurityScreen();
                        }, transitionsBuilder:
                            (_, Animation<double> animation, __, Widget child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        }));
                      }
                    })),
          ),
        ),
      ),
      Visibility(
        visible: widget.setupPIN,
        child: IgnorePointer(
          ignoring: !widget.setupPIN,
          child: Material(
            child: SafeArea(
                child: Stack(
              children: [

                Visibility(
                    visible: _firstPIN,
                    child: IgnorePointer(
                      ignoring: !_firstPIN,
                      child: LockScreen(
                          title: AppLocalizations.of(context)!
                              .as_enter_desired_pin,
                          passLength: 6,
                          numColor: Colors.white70,
                          bgImage: "images/pending_rocket_pin.png",
                          fingerPrintImage: null,
                          showFingerPass: false,
                          fingerFunction: biometrics,
                          fingerVerify: _isFingerprint,
                          borderColor: Colors.white,
                          showWrongPassDialog: false,
                          wrongPassContent: "",
                          wrongPassTitle: "",
                          wrongPassCancelButtonText: "Cancel",
                          passCodeVerify: (passcode) async {
                            if (passcode.length != 6) {
                              return false;
                            }
                            _tempPIN = passcode;
                            return true;
                          },
                          onSuccess: () {
                            setState(() {
                              _firstPIN = false;
                            });
                          }),
                    )),
                Visibility(
                    visible: !_firstPIN,
                    child: IgnorePointer(
                      ignoring: _firstPIN,
                      child: LockScreen(
                          title: AppLocalizations.of(context)!
                              .as_enter_desired_confirm_pin,
                          passLength: 6,
                          numColor: Colors.white70,
                          bgImage: "images/pending_rocket_pin.png",
                          fingerPrintImage: null,
                          showFingerPass: false,
                          fingerFunction: biometrics,
                          fingerVerify: _isFingerprint,
                          borderColor: Colors.white,
                          showWrongPassDialog: false,
                          wrongPassContent: "",
                          wrongPassTitle: "",
                          wrongPassCancelButtonText: "Cancel",
                          passCodeVerify: (passcode) async {
                            if (passcode.length != 6) {
                              return false;
                            }
                            _tempPIN2 = passcode;
                            return true;
                          },
                          onSuccess: () {
                            _checkSetupPIN();
                          }),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 80.0, left: 20.0),
                  child: SizedBox.fromSize(
                    size: const Size(40, 40), // button width and height

                    child: ClipOval(
                      child: Material(
                        color: Colors.black12, // button color
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.8), // splash color
                          onTap: () {
                            SecureStorage.deleteStorage(key: "PIN");
                            Navigator.pop(context);
                          }, // button pressed
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Icon(Icons.arrow_back, color: Colors.white70,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: SizedBox(
                width: 100,
                height: 50,
                child: Image.asset("images/logo_big.png")),
          ),
        ),
      ),
    ]);
  }

  void _checkSetupPIN() async {
    int first = int.parse(_tempPIN.map((i) => i.toString()).join(""));
    int second = int.parse(_tempPIN2.map((i) => i.toString()).join(""));
    var succ = false;
    if (first == second) {
      succ = true;
      await SecureStorage.writeStorage(key: "PIN", value: first.toString());
    }else{
      await SecureStorage.deleteStorage(key: "PIN");
    }
    if (mounted) Navigator.of(context).pop(succ);
  }
}
