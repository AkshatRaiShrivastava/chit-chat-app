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

void main() async {


//Setting SystmeUIMode

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(create: (context)=>ThemeProvider(),
    child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        '/home':(context)=>HomePage(),
        '/settings':(context)=>SettingsPage()
      },

    );
  }
}
