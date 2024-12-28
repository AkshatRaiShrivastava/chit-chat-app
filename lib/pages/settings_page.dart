import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(25),
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //dark mode
            Text("Dark Mode"),
            //switch toggle
            CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context, listen: false)
                    .isDarkMode,
                onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme() )
          ],
        ),
      ),
    );
  }
}
