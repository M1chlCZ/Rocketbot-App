import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rocketbot/Screens/main_screen.dart';
import 'package:rocketbot/screens/login_screen.dart';
import 'Support/material_color_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    precacheImage(const AssetImage('images/bottommenu1.png'), context);
    precacheImage(const AssetImage('images/bottommenu2.png'), context);
    precacheImage(const AssetImage('images/bottommenu3.png'), context);
    precacheImage(const AssetImage('images/price_frame.png'), context);
    precacheImage(const AssetImage('images/rocket_pin.png'), context);
    precacheImage(const AssetImage('images/rocketbot_logo.png'), context);
    precacheImage(const AssetImage('images/wave.png'), context);

  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Montserrat",
        canvasColor: const Color(0xFF1B1B1B),
        textTheme: TextTheme(
          headline1: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 28.0,
          ),
          headline2: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
          headline3: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
          headline4: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
          subtitle1: const TextStyle(
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
      home: const LoginScreen(),
    );
  }
}
