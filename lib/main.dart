import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rocketbot/screens/login_screen.dart';
import 'Support/material_color_generator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
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
    precacheImage(const AssetImage('images/receive_nav_icon.png'), context);
    precacheImage(const AssetImage('images/coin_nav_icon.png'), context);
    precacheImage(const AssetImage('images/send_nav_icon.png'), context);
    precacheImage(const AssetImage('images/price_frame.png'), context);
    precacheImage(const AssetImage('images/rocket_pin.png'), context);
    precacheImage(const AssetImage('images/rocketbot_logo.png'), context);
    precacheImage(const AssetImage('images/wave.png'), context);
    precacheImage(const AssetImage('images/logo_big.png'), context);
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'RocketBot',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeListResolutionCallback: (locales, supportedLocales) {

        print('device locales=$locales supported locales=$supportedLocales');

        for (Locale locale in locales!) {
          if (supportedLocales.contains(locale)) {
            print('supported');
            return locale;
          }
        }
        return Locale('en', '');
      },
      supportedLocales: [Locale('cs', 'CZ'), Locale('en', '')],
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
            fontStyle: FontStyle.italic
          ),
          bodyText1: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
          )
        ),
        primarySwatch: generateMaterialColor(Colors.white),
      ),
      home: const LoginScreen(),
    );
  }
}
