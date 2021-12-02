import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rocketbot/MainScreen.dart';
import 'Support/MaterialColorGenerator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Montserrat",
        canvasColor: Color(0xFF1B1B1B),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 24.0,
          ),
          headline2: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
          headline3: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
          headline4: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
          subtitle1: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 10.0,
          ),
          subtitle2: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontWeight: FontWeight.w400,
            fontSize: 10.0,
          ),
        ),
        primarySwatch: generateMaterialColor(Colors.white),
      ),
      home: MainScreen(),
    );
  }
}
