import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waste_management_app/utils/Constants.dart';
import 'Driver/Accounts/Account Setting/language_provider.dart';
import 'Driver/Screens/Driver_dash_page.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Constants.prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, lang, _) {
          return MaterialApp(
            locale: lang.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            title: 'Waste Management',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Color(0XFF00A884)),
                useMaterial3: false,
                fontFamily: "Regular"
            ),

            // home: Constants.prefs!.getBool("loggedIn") == true
            //     ? Home()
            //     : LoginScreen(),
            home: driver_dash(),
          );
        },
      ),
    );

  }
}

