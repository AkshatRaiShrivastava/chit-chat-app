import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:minimal_chat_app/pages/search_page.dart';
import 'package:minimal_chat_app/pages/settings_page.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';
import 'home_page.dart';

const Color bottomNavBgColor = Color(0xFF17203A);

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black
                    .withOpacity(0.7), // Semi-transparent background
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white54,
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Iconsax.home,
                        color: themeNotifier.themeColor,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Iconsax.search_normal,
                        color: themeNotifier.themeColor,
                      ),
                      label: 'Search',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Iconsax.user,
                        color: themeNotifier.themeColor,
                      ),
                      label: 'Settings',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
