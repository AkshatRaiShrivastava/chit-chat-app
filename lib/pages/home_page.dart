import 'package:flutter/material.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';
import 'package:minimal_chat_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

import '../components/my_drawer.dart';
import '../components/user_tile.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
     // drawer: MyDrawer(),
      body: _buildUserList(context),
    );
  }

  // build a list of users except for the current logged in user

  Widget _buildUserList(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    return StreamBuilder(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: themeNotifier.themeColor,);
          }
          
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  // individual user tile for each user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all users exceppt the current user
    if (userData["email"] != _authService.getCurrentUser()?.email) {
      return UserTile(
          email: userData["email"],
          name: userData["name"],
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          receiverEmail: userData["email"],
                          receiverId: userData["uid"],
                          receiverName: userData["name"],
                        )));
          });
    } else {
      return Container();
    }
  }
}
