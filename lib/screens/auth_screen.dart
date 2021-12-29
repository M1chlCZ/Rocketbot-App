import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rocketbot/screenpages/portfolio_page.dart';
import 'package:rocketbot/widgets/screen_lock.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isFingerprint = false;

  Future<Null> biometrics() async {
    final LocalAuthentication auth = new LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        biometricOnly: true,
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    if (authenticated) {
      setState(() {
        isFingerprint = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var myPass = [1, 2, 3, 4, 5, 6];
    return Stack(
      children:[ Material(
        child: SafeArea(
          child: LockScreen(
              title: "Please enter PIN",
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
                child: Image.asset(
                  "images/fingerprint.png",
                  height: 50.0,
                  fit: BoxFit.fitHeight,
                ),
                blendMode: BlendMode.srcATop,
              ),
              showFingerPass: true,
              fingerFunction: biometrics,
              fingerVerify: isFingerprint,
              borderColor: Colors.white,
              showWrongPassDialog: false,
              wrongPassContent: "Wrong pass please try again.",
              wrongPassTitle: "Opps!",
              wrongPassCancelButtonText: "Cancel",
              passCodeVerify: (passcode) async {
                for (int i = 0; i < myPass.length; i++) {
                  if (passcode[i] != myPass[i]) {
                    return false;
                  }
                }

                return true;
              },
              onSuccess: () {
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (BuildContext context) {
                      return PortfolioScreen();
                    }));
              })
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

}
