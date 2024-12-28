import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    void logout() {
      final auth = AuthService();
      auth.signout();
    }

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(
              child: Icon(
            Icons.message,
            color: Theme.of(context).colorScheme.primary,
            size: 40,
          )),
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: ListTile(
              title: Text('H O M E'),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: ListTile(
              title: Text('S E T T I N G S'),
              leading: Icon(Icons.settings),
              onTap: () {
                Navigator.popAndPushNamed(context, '/settings');
              },
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: ListTile(
              title: Text('L O G O U T'),
              leading: Icon(Icons.logout),
              onTap: logout,
            ),
          ),
          Text(
            "Made with ❤️ by Akshat",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
