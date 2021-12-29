import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screenpages/portfolio_page.dart';
import 'package:rocketbot/support/gradient_text.dart';
import 'package:rocketbot/widgets/login_register.dart';

import 'auth_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordRegController = TextEditingController();
  TextEditingController passwordRegConfirmController = TextEditingController();
  bool _curtain = true;
  var _page = 0;

  @override
  void initState() {
    super.initState();
    // _curtain = false;
    Future.delayed(const Duration(milliseconds: 50), () async {
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
      return const AuthScreen();
    }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
      return FadeTransition(opacity: animation, child: child);
    }));
  }

  _switchPage(int page) {
    FocusScope.of(context).unfocus();
    loginController.text = '';
    passwordController.text = '';
    usernameController.text = '';
    passwordRegController.text = '';
    passwordRegConfirmController.text = '';
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                       LoginRegisterSwitcher(
                           changeType: _switchPage
                       ),
                      ],
                    ),

                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(right:15.0, top: 17.0),
                      child: Text('v 1.0',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(
                            color: Colors.white70, fontSize: 12.0),
                      ),
                    )

                  ),
                ),
                IgnorePointer(
                  ignoring: _page == 1 ? true : false,
                  child: AnimatedOpacity(
                    opacity: _page == 0 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: SafeArea(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                const SizedBox(
                                  height: 120,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 280,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
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
                                                    hintText: AppLocalizations.of(context)!.e_mail,
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
                                                  obscureText: true,
                                                  enableSuggestions: false,
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
                                                    hintText: AppLocalizations.of(context)!.password,
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.forgot_pass,
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
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
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
                                            AppLocalizations.of(context)!.sign_in,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 22.0, color: Colors.white),
                                      )),
                                    ),
                                  ),
                                ),
                                const SizedBox( height: 20.0,),
                                Text(AppLocalizations.of(context)!.or, style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 16.0, color: Colors.white),),
                                const SizedBox( height: 20.0,),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: NeuButton(
                                    onTap: () {
                                      // _loginUser(
                                      //     loginController.text, passwordController.text
                                      // );
                                    },
                                    splashColor: Colors.purple,
                                    child:
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 25,
                                            child: Image.asset('images/google_icon.png')),
                                       const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(AppLocalizations.of(context)!.sign_in_google, style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                            fontSize: 14.0, color: Colors.white),),
                                      ],
                                    )
                                  ),
                                ),
                              ]),
                        )),
                  ),
                ),
                IgnorePointer(
                  ignoring: _page == 0 ? true : false,
                  child: AnimatedOpacity(
                    opacity: _page == 1 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: SafeArea(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                const SizedBox(
                                  height: 120,
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
                                          controller: usernameController,
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
                                            hintText: AppLocalizations.of(context)!.e_mail,
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
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          controller: passwordRegController,
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
                                            hintText: AppLocalizations.of(context)!.password,
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
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      controller: passwordRegConfirmController,
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
                                        hintText: AppLocalizations.of(context)!.conf_password,
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
                                  height: 141,
                                ),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: NeuButton(
                                      onTap: () {
                                        // _loginUser(
                                        //     loginController.text, passwordController.text
                                        // );
                                      },
                                      splashColor: Colors.purple,
                                      child:
                                      GradientText(
                                        AppLocalizations.of(context)!.register_button,
                                        gradient: const LinearGradient(colors: [
                                          Color(0xFFF05523),
                                          Color(0xFF812D88),
                                        ]),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                            fontSize: 22.0, color: Colors.white),
                                      )
                                  ),
                                ),
                              ]),
                        )),
                  ),
                ),
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
              ],
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
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (BuildContext context, _, __) {
        return const PortfolioScreen();
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
