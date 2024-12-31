import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimal_chat_app/firebase_options.dart';
import 'package:minimal_chat_app/pages/home_page.dart';
import 'package:minimal_chat_app/pages/login_page.dart';
import 'package:minimal_chat_app/pages/register_page.dart';
import 'package:minimal_chat_app/pages/settings_page.dart';
import 'package:minimal_chat_app/services/auth/auth_gate.dart';
import 'package:minimal_chat_app/themes/light_mode.dart';
import 'package:minimal_chat_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
//Setting SystmeUIMode

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final theme_color = prefs.getInt('themeColor') ?? 0;
  final isDark = prefs.getBool('isDark') ?? false;
  ThemeProvider themeNotifier = ThemeProvider(theme_color, isDark);
  await themeNotifier.loadThemeColor();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(theme_color, isDark),
    child: MyApp(theme_color: theme_color),
  ));
}

class MyApp extends StatelessWidget {
  final int theme_color;
  const MyApp({super.key, required this.theme_color});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AuthGate(),
      routes: {
        // '/login' : (context)=>LoginPage(onTap: () {  },),
        // '/register' : (context)=>RegisterPage(onTap: () {  },),
        '/home': (context) => HomePage(),
        '/settings': (context) => SettingsPage()
      },
    );
  }
}
