import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/widgets/login_register.dart';

import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _curtain = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () async {
      bool b = await _loggedIN();
      if (b) {
        _goodCredentials();
      } else {
        setState(() {
          _curtain = false;
        });
      }
    });
  }

  _loggedIN() async {
    var lg = await const FlutterSecureStorage().read(key: NetInterface.token);
    if (lg != null && lg.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  _goodCredentials() async {
    int i = await NetInterface.checkToken();
    if (i == 0) {
      _nextPage();
    } else {
      setState(() {
        _curtain = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Invalid credentials",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.fixed,
        elevation: 5.0,
      ));
    }
  }

  _nextPage() {
    Navigator.of(context).pushReplacement(
        PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
      return const MainScreen();
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      const LoginRegisterSwitcher(),
                      const SizedBox(
                        height: 80,
                      ),
                      SizedBox(
                        width: 280,
                        child: NeuContainer(
                            child: TextField(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white, fontSize: 18.0),
                                autocorrect: false,
                                controller: loginController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  isDense: false,
                                  contentPadding:
                                      const EdgeInsets.only(left: 10.0, bottom: 5.0),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                          color: Colors.white54,
                                          fontSize: 14.0),
                                  hintText: 'E-mail',
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                ))),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        width: 280,
                        child: NeuContainer(
                            child: TextField(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Colors.white, fontSize: 18.0),
                                autocorrect: false,
                                controller: passwordController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  isDense: false,
                                  contentPadding:
                                  const EdgeInsets.only(left: 10.0, bottom: 5.0),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                      color: Colors.white54,
                                      fontSize: 14.0),
                                  hintText: 'Password',
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                ))),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 65.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            SizedBox(
                              height: 30,
                              width: 25,
                              child: NeuButton(
                                onTap: () {
                                  // widget.goBack();
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      SizedBox(
                        width: 250,
                        child: NeuButton(
                          onTap: () {
                            _loginUser(
                                loginController.text, passwordController.text);
                          },
                          splashColor: Colors.purple,
                          child: Container(
                            width: 200,
                            height: 50,
                            color: Colors.transparent,
                            child: Center(
                                child: Text(
                              "Sign in",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 22.0, color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    ]),
              )),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                    width: 100,
                    height: 50,
                    child: Image.asset("images/logo_big.png")),
              ),
            ),
          ),
          Visibility(
              visible: _curtain,
              child: Container(
                  width: double.infinity,
                  height: double.maxFinite,
                  color: const Color(0xFF1B1B1B))),
        ],
      ),
    );
  }

  void _loginUser(String login, String pass) async {
    int i = await NetInterface.createToken(login, pass);
    if (i == 0) {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (BuildContext context, _, __) {
        return const MainScreen();
      }, transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      }));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Credentials doesn't match any user!",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.fixed,
        elevation: 5.0,
      ));
    }
  }
}
