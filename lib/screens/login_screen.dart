import 'package:flutter/material.dart';
import 'package:rocketbot/component_widgets/button_neu.dart';
import 'package:rocketbot/netinterface/interface.dart';

import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100.0,
            ),
            Image.asset(
              "images/rocket_pin.png",
              width: 150,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'ROCKETBOT',
              style:
                  Theme.of(context).textTheme.headline1!.copyWith(fontSize: 32.0),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Container(
                width: 290,
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white, fontSize: 24.0),
                    autocorrect: false,
                    controller: loginController,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding: const EdgeInsets.only(left: 10.0),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white70, fontSize: 18.0),
                      hintText: 'E-mail',
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ))),
            Container(
                width: 290,
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white, fontSize: 24.0),
                    autocorrect: false,
                    controller: passwordController,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding: const EdgeInsets.only(left: 10.0),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white70, fontSize: 18.0),
                      hintText: 'Password',
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                      ),
                    ))),
            const SizedBox(
              height: 150,
            ),
            NeuButton(
                onTap: () {
                  _loginUser(loginController.text, passwordController.text);
                },
              splashColor: Colors.purple,
                child: Container(
                  width: 200,
                  height: 50,
                  color: Colors.transparent,
                  child: Center(
                      child:
                      Text("Log in",
                        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 18.0, color: Colors.white70),
                      )),
                ),
              ),
            ])
        ),
      );

  }
  void _loginUser(String login, String pass) async{
    int i = await NetInterface.createToken(login, pass);
    if(i == 0) {
      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) {
        return const MainScreen();
      }, transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      }));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Credentials doesn't match any user!", textAlign: TextAlign.center,),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.fixed,
        elevation: 5.0,
      ));
    }
  }
}
