import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rocketbot/component_widgets/container_neu.dart';
import 'package:rocketbot/netinterface/interface.dart';
import 'package:rocketbot/screenpages/portfolio_page.dart';
import 'package:rocketbot/support/dialogs.dart';
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
  final _storage = FlutterSecureStorage();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController emailRegController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController passwordRegController = TextEditingController();
  TextEditingController passwordRegConfirmController = TextEditingController();

  bool _curtain = true;
  bool _termsAgreed = false;
  var _page = 0;

  @override
  void initState() {
    super.initState();
    // _curtain = false;
    // loginController.text = 'm1chlcz18@gmail.com';
    // passwordController.text = 'MvQ.u:3kML_WjGX';

    Future.delayed(const Duration(milliseconds: 50), () async {
      var pinCheck = await _storage.read(key: "PIN");
      if(pinCheck!.length != 6) {await  _storage.delete(key: "PIN");}
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
    // await _storage.delete(key: NetInterface.token);
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
    var email = login;
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      Dialogs.openAlertBox(
          context,
          AppLocalizations.of(context)!.email_invalid,
          AppLocalizations.of(context)!.email_invalid_message);
      return;
    }
    String? res = await NetInterface.getKey(login, pass);
    if (res != null) {
      _codeDialog(res);
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
    String? res = await NetInterface.getToken(key, code);
    if (res != null) {
      _storage.write(key: NetInterface.token, value: res);
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

  _nextPage() async {
    String? res = await _storage.read(key: "PIN");
    // String? res;
    if(res == null) {
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
            return const PortfolioScreen();
          },
              transitionsBuilder: (_, Animation<double> animation, __,
                  Widget child) {
                return FadeTransition(opacity: animation, child: child);
              }));
    }else {
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
            return const AuthScreen();
          },
              transitionsBuilder: (_, Animation<double> animation, __,
                  Widget child) {
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
    var passwordConfirm =
    passwordRegConfirmController.text;
    var email = emailRegController.text;
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (username.length < 3) {
      Dialogs.openAlertBox(
          context,
          AppLocalizations.of(context)!.username_invalid,
          AppLocalizations.of(context)!.username_invalid_message);
      return;
    } else if (password.length < 3) {
      Dialogs.openAlertBox(
          context,
          AppLocalizations.of(context)!.password_invalid,
          AppLocalizations.of(context)!.password_invalid_message);
      return;
    } else if (!emailValid) {
      Dialogs.openAlertBox(
          context,
          AppLocalizations.of(context)!.email_invalid,
          AppLocalizations.of(context)!.email_invalid_message);
      return;
    } else if (realname.length < 3) {
      Dialogs.openAlertBox(
          context,
          AppLocalizations.of(context)!.name_invalid,
          AppLocalizations.of(context)!.name_invalid_message);
      return;
    } else if (password !=
        passwordConfirm) {
      Dialogs.openAlertBox(
          context,
          AppLocalizations.of(context)!.password_mismatch,
          AppLocalizations.of(context)!.password_mismatch_message);
      return;
    }
    int res = await NetInterface.registerUser(
        agreed: _termsAgreed,
        passConf: passwordRegConfirmController.text,
        email: emailRegController.text,
        pass: passwordRegController.text,
        surname: secondNameController.text,
        name: firstNameController.text
    );
    if(res == 1) {
      _registrationDialog(true);
    }else{
      _registrationDialog(false);
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
                                  height: 150,
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
                                                        .subtitle1!
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
                                                        .subtitle1!
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
                                        Padding(
                                          padding: const EdgeInsets.only(left: 55.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!.forgot_pass,
                                                style: Theme.of(context).textTheme.subtitle1,
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
                                Text(AppLocalizations.of(context)!.or, style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 16.0, color: Colors.white),),
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
                                            .subtitle1!
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
                                              color: Colors.white, fontSize: 18.0),
                                          autocorrect: false,
                                          controller: emailRegController,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: false,
                                            contentPadding:
                                            const EdgeInsets.only(left: 10.0, bottom: 5.0),
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
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
                                          autocorrect: false,
                                          controller: firstNameController,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: false,
                                            contentPadding:
                                            const EdgeInsets.only(left: 10.0, bottom: 5.0),
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                color: Colors.white54,
                                                fontSize: 14.0),
                                            hintText: AppLocalizations.of(context)!.name,
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
                                          controller: secondNameController,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            isDense: false,
                                            contentPadding:
                                            const EdgeInsets.only(left: 10.0, bottom: 5.0),
                                            hintStyle: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                color: Colors.white54,
                                                fontSize: 14.0),
                                            hintText: AppLocalizations.of(context)!.surname,
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
                                                .subtitle1!
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
                                            .subtitle1!
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
                            height: 30.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!.agreed_to + ' ',
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                    TextSpan(
                                      text: AppLocalizations.of(context)!.terms,
                                      style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () { _launchURL('https://rocketbot.pro/terms');
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Checkbox(
                                  checkColor: Colors.lightGreen,
                                  activeColor: Colors.white12,
                                  value: _termsAgreed,
                                  onChanged: _onTermsChanged
                              ),
                            ],
                          ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: 250,
                                  height: 50,
                                  child: NeuButton(
                                      onTap: () {
                                        _registerUser();
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

  void _codeDialog(String key) async {
    await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SafeArea(
            child: Builder(builder: (context) {
              final TextEditingController _codeControl = TextEditingController();
              return Center(
                child: SizedBox(
                    width: 300,
                    height: MediaQuery.of(context).size.height * 0.24,
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
                                    child: Text(AppLocalizations.of(context)!.enter_code,
                                      style: Theme.of(context).textTheme.headline4,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0,),
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          child: Container(
                                            color: Colors.black38,
                                            padding: EdgeInsets.all(5.0),
                                            child: TextField(controller: _codeControl,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                    color: Colors.white, fontSize: 18.0),
                                                autocorrect: false,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  isDense: false,
                                                  contentPadding:
                                                  const EdgeInsets.only(left: 10.0, bottom: 5.0),
                                                  hintStyle: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1!
                                                      .copyWith(
                                                      color: Colors.white54,
                                                      fontSize: 14.0),
                                                  hintText: AppLocalizations.of(context)!.enter_code_hint,
                                                  enabledBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.transparent),
                                                  ),
                                                  focusedBorder: const UnderlineInputBorder(
                                                    borderSide:
                                                    BorderSide(color: Colors.transparent),
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15.0, 22.0, 15.0, 0.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 90.0,
                                          child: NeuButton(
                                            onTap: () {
                                              _getToken(key, _codeControl.text);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('OK',
                                                style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
                                                textAlign: TextAlign.start,
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

  void _forgotDialog() async {
    await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SafeArea(
            child: Builder(builder: (context) {
              final TextEditingController _forgotPassControl = TextEditingController();
              return Center(
                child: SizedBox(
                    width: 300,
                    height: MediaQuery.of(context).size.height * 0.22,
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
                                    child: Text(AppLocalizations.of(context)!.forgot_email,
                                      style: Theme.of(context).textTheme.headline4,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0,),
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          child: Container(
                                            color: Colors.black38,
                                            padding: EdgeInsets.all(5.0),
                                            child: TextField(controller: _forgotPassControl,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                    color: Colors.white, fontSize: 18.0),
                                                autocorrect: false,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  isDense: false,
                                                  contentPadding:
                                                  const EdgeInsets.only(left: 10.0, bottom: 5.0),
                                                  hintStyle: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1!
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
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15.0, 22.0, 15.0, 0.0),
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
                                              child: Text('OK',
                                                style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
                                                textAlign: TextAlign.start,
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

  void _registrationDialog(bool succ) async {
    await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SafeArea(
            child: Builder(builder: (context) {
              return Center(
                child: SizedBox(
                    width: 300,
                    height: MediaQuery.of(context).size.height * 0.22,
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
                                    child: Text(succ ? 'Registration complete' : 'Registration Error',
                                      style: Theme.of(context).textTheme.headline4,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0,),
                                  Stack(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child:
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          child: Container(
                                            color: Colors.black38,
                                            padding: EdgeInsets.all(5.0),
                                            child: Text(succ ? 'Please confirm your registration in e-mail' : 'Registration unsuccessful', style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center,)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(15.0, 22.0, 15.0, 0.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 90.0,
                                          child: NeuButton(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('OK',
                                                style: Theme.of(context).textTheme.headline4!.copyWith(color: Colors.white),
                                                textAlign: TextAlign.start,
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
