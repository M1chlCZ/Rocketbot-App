import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info/package_info.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:rocketbot/models/registration_errors.dart';
import 'package:rocketbot/models/registration_succ.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screenpages/portfolio_page.dart';
import 'package:rocketbot/support/dialogs.dart';
import 'package:rocketbot/support/firebase_service.dart';
import 'package:rocketbot/support/gradient_text.dart';
import 'package:rocketbot/widgets/login_register.dart';
import 'package:url_launcher/url_launcher.dart';

import 'auth_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PackageInfo? _packageInfo;
  final _storage = const FlutterSecureStorage();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController emailRegController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController passwordRegController = TextEditingController();
  TextEditingController passwordRegConfirmController = TextEditingController();

  bool _curtain = true;
  bool _termsAgreed = false;
  bool _registerButton = true;
  String _appVersion = "1.0";
  var _page = 0;

  @override
  void initState() {
    super.initState();
    // _curtain = false;
    // if (kDebugMode) {
    //   loginController.text = 'm1chlcz18@gmail.com';
    //   passwordController.text = 'MvQ.u:3kML_WjGX';
    // }
    _initPackageInfo();
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

  void _initPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = _packageInfo!.version;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _loggedIN() async {
    String? lg = await _storage.read(key: NetInterface.token);
    if (lg != null && lg.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  _goodCredentials() async {
    // _nextPage();
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

  void _loginUser(String login, String pass) async {
    setState(() {
      _curtain = true;
    });
    var email = login;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.email_invalid,
          AppLocalizations.of(context)!.email_invalid_message);
      return;
    }
    String? res = await NetInterface.getKey(login, pass);
    if (res != null) {
      bool code = await NetInterface.getEmailCode(res);
      if(code) {
        Dialogs.open2FAbox(context, res, _getToken);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Problem getting your email code, try again later",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.fixed,
          elevation: 5.0,
        ));
        setState(() {
          _curtain = false;
        });
      }
      // _codeDialog(res);
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

  void _getToken(String key, String code) async {
    Navigator.of(context).pop();
    String? res = await NetInterface.getToken(key, code);
      if (res != null) {
        await _storage.write(key: NetInterface.token, value: res);
        String? wer = await _storage.read(key: NetInterface.token);
        if(wer != null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const PortfolioScreen()));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Bad code entered!",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.fixed,
            elevation: 5.0,
          ));
        }
        setState(() {
          _curtain = false;
        });
      }
  }

  _nextPage() async {
    String? res = await _storage.read(key: "PIN");
    // String? res;
    if (res == null) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (BuildContext context, _, __) {
        return const PortfolioScreen();
      }, transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      }));
    } else {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (BuildContext context, _, __) {
        return const AuthScreen();
      }, transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      }));
    }
  }

  _switchPage(int page) {
    FocusScope.of(context).unfocus();
    loginController.text = '';
    firstNameController.text = '';
    secondNameController.text = '';
    passwordController.text = '';
    emailRegController.text = '';
    passwordRegController.text = '';
    passwordRegConfirmController.text = '';
    setState(() {
      _page = page;
    });
  }

  void _onTermsChanged(bool? newValue) => setState(() {
        _termsAgreed = newValue!;
      });

  void _registerUser() async {
    var realname = firstNameController.text;
    var username = secondNameController.text;
    var password = passwordRegController.text;
    var passwordConfirm = passwordRegConfirmController.text;
    var email = emailRegController.text;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (username.isEmpty || username.length > 64) {
      Dialogs.openAlertBox(
          context,
          AppLocalizations.of(context)!.username_invalid,
          AppLocalizations.of(context)!.username_invalid_message);
      return;
    } else if (password.length < 8 || password.length > 64) {
      Dialogs.openAlertBox(
          context,
          AppLocalizations.of(context)!.password_invalid,
          AppLocalizations.of(context)!.password_invalid_message);
      return;
    } else if (!emailValid) {
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.email_invalid,
          AppLocalizations.of(context)!.email_invalid_message);
      return;
    } else if (realname.isEmpty || realname.length > 64) {
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.name_invalid,
          AppLocalizations.of(context)!.name_invalid_message);
      return;
    } else if (password != passwordConfirm) {
      Dialogs.openAlertBox(
          context,
          AppLocalizations.of(context)!.password_mismatch,
          AppLocalizations.of(context)!.password_mismatch_message);
      return;
    } else if (!_termsAgreed) {
      Dialogs.openAlertBox(context, AppLocalizations.of(context)!.alert,
          AppLocalizations.of(context)!.terms_agree);
      return;
    }
    setState(() {
      _registerButton = false;
    });
    String? res = await NetInterface.registerUser(
        agreed: _termsAgreed,
        passConf: passwordRegConfirmController.text,
        email: emailRegController.text,
        pass: passwordRegController.text,
        surname: secondNameController.text,
        name: firstNameController.text);
    var error = json.decode(res);
    var succ = RegistrationSucc.fromJson(error);
    if (succ.hasError != null && succ.hasError != true) {
      Future.delayed(const Duration(milliseconds: 5), () async {
        bool b = await _loggedIN();
        if (b) {
          _goodCredentials();
        } else {
          setState(() {
            _curtain = false;
          });
        }
      });
    } else {
      var m = RegistrationErrors.fromJson(error);
      // print(m.status);
      Dialogs.openAlertBox(context, m.title!, m.errors.toString());
      setState(() {
        _registerButton = true;
      });
    }
  }

  void _forgotPass(String email) async {
    var i = NetInterface.forgotPass(email);
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
                          height: 60,
                        ),
                        LoginRegisterSwitcher(changeType: _switchPage),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: SafeArea(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 15.0, top: 17.0),
                    child: Text(
                      'v ' + _appVersion,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white70, fontSize: 12.0),
                    ),
                  )),
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
                                  height: 150,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 280,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 280,
                                          child: NeuContainer(
                                              child: TextField(
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 18.0),
                                                  autocorrect: false,
                                                  controller: loginController,
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                    isDense: false,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            bottom: 5.0),
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1!
                                                        .copyWith(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: 14.0),
                                                    hintText:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .e_mail,
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
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
                                                          color: Colors.white,
                                                          fontSize: 18.0),
                                                  obscureText: true,
                                                  enableSuggestions: false,
                                                  autocorrect: false,
                                                  controller:
                                                      passwordController,
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                    isDense: false,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            bottom: 5.0),
                                                    hintStyle: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1!
                                                        .copyWith(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: 14.0),
                                                    hintText:
                                                        AppLocalizations.of(
                                                                context)!
                                                            .password,
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                                  ))),
                                        ),
                                        const SizedBox(
                                          height: 30.0,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 55.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .forgot_pass,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                              ),
                                              const SizedBox(
                                                width: 20.0,
                                              ),
                                              SizedBox(
                                                height: 30,
                                                width: 25,
                                                child: NeuButton(
                                                  onTap: () {
                                                    _forgotDialog();
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
                                      _loginUser(loginController.text,
                                          passwordController.text);
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
                                                fontSize: 22.0,
                                                color: Colors.white),
                                      )),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.or,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          fontSize: 16.0, color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: NeuButton(
                                      onTap: () async {
                                        FirebaseService service =
                                            FirebaseService();
                                        try {
                                          String? tokenID =
                                              await service.signInwithGoogle();
                                          if (tokenID != null) {
                                            var asdf = await NetInterface.getTokenGoogle(tokenID);
                                            if(asdf != null) {
                                              _nextPage();
                                            }else{
                                              Dialogs.openAlertBox(context, "Error", "Error Sign in with Google");
                                            }
                                          }
                                        } catch (e) {
                                          // print("======HOVNO=======");
                                          // print(e);
                                          // if (e is FirebaseAuthException) {
                                          //   print(e.message!);
                                          // }
                                          Dialogs.openAlertBox(context, "Error", "Error Sign in with Google");
                                        }
                                        setState(() {
                                          // isLoading = false;
                                        });
                                      },
                                      splashColor: Colors.purple,
                                      child: Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 25,
                                              child: Image.asset(
                                                  'images/google_icon.png')),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .sign_in_google,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontSize: 14.0,
                                                    color: Colors.white),
                                          ),
                                        ],
                                      )),
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
                                  height: 150,
                                ),
                                SizedBox(
                                  width: 280,
                                  child: NeuContainer(
                                      child: TextField(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 18.0),
                                          autocorrect: false,
                                          controller: emailRegController,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: false,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 10.0, bottom: 5.0),
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    color: Colors.white54,
                                                    fontSize: 14.0),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .e_mail,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
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
                                                  color: Colors.white,
                                                  fontSize: 18.0),
                                          autocorrect: false,
                                          controller: firstNameController,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: false,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 10.0, bottom: 5.0),
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    color: Colors.white54,
                                                    fontSize: 14.0),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .name,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
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
                                                  color: Colors.white,
                                                  fontSize: 18.0),
                                          autocorrect: false,
                                          controller: secondNameController,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: false,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 10.0, bottom: 5.0),
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    color: Colors.white54,
                                                    fontSize: 14.0),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .surname,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
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
                                                  color: Colors.white,
                                                  fontSize: 18.0),
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          controller: passwordRegController,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: false,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 10.0, bottom: 5.0),
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    color: Colors.white54,
                                                    fontSize: 14.0),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .password,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
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
                                                  color: Colors.white,
                                                  fontSize: 18.0),
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          controller:
                                              passwordRegConfirmController,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: false,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 10.0, bottom: 5.0),
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    color: Colors.white54,
                                                    fontSize: 14.0),
                                            hintText:
                                                AppLocalizations.of(context)!
                                                    .conf_password,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ))),
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppLocalizations.of(context)!
                                                    .agreed_to +
                                                ' ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                          TextSpan(
                                            text: AppLocalizations.of(context)!
                                                .terms,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(color: Colors.blue),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                _launchURL(
                                                    'https://rocketbot.pro/terms');
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                      child: Checkbox(
                                          checkColor: Colors.lightGreen,
                                          activeColor: Colors.white12,
                                          value: _termsAgreed,
                                          onChanged: _onTermsChanged),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 45,
                                ),
                                SizedBox(
                                    width: 250,
                                    height: 50,
                                    child: _registerButton
                                        ? NeuButton(
                                            onTap: () {
                                              _registerUser();
                                            },
                                            splashColor: Colors.purple,
                                            child: GradientText(
                                              AppLocalizations.of(context)!
                                                  .register_button,
                                              gradient:
                                                  const LinearGradient(colors: [
                                                Color(0xFFF05523),
                                                Color(0xFF812D88),
                                              ]),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      fontSize: 22.0,
                                                      color: Colors.white),
                                            ))
                                        : const Center(
                                            child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                            color: Color(0xFFAA3B63),
                                          ))),
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
                  color: const Color(0xFF1B1B1B),
                // child: Center(
                //   child: HeartbeatProgressIndicator(
                //     startScale: 0.01,
                //     endScale: 0.2,
                //     child: const Image(
                //       image: AssetImage('images/rocketbot_logo.png'),
                //       color: Colors.white30,
                //     ),
                //   ),
                // ),
              )
          ),
        ],
      ),
    );
  }

  void _forgotDialog() async {
    await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SafeArea(
            child: Builder(builder: (context) {
              final TextEditingController _forgotPassControl =
                  TextEditingController();
              return Center(
                child: SizedBox(
                    width: 300,
                    height: MediaQuery.of(context).size.height * 0.22,
                    child: StatefulBuilder(
                        builder: (context, StateSetter setState) {
                      return Card(
                        color: const Color(0xFF1B1B1B),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 15.0,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  AppLocalizations.of(context)!.forgot_email,
                                  style: Theme.of(context).textTheme.headline4,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Stack(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      child: Container(
                                        color: Colors.black38,
                                        padding: const EdgeInsets.all(5.0),
                                        child: TextField(
                                            controller: _forgotPassControl,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                            autocorrect: false,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              isDense: false,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 10.0, bottom: 5.0),
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1!
                                                  .copyWith(
                                                      color: Colors.white54,
                                                      fontSize: 14.0),
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .e_mail,
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent),
                                              ),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 22.0, 15.0, 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 90.0,
                                      child: NeuButton(
                                        onTap: () {
                                          _forgotPass(_forgotPassControl.text);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'OK',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(color: Colors.white),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
              );
            }),
          );
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 150));
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
}
