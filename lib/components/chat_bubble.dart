import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String time;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.time});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);

    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Container(
      constraints: BoxConstraints(
        maxWidth: 300
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: isCurrentUser
              ? themeNotifier.themeColor
              : isDarkMode
                  ? Colors.grey.shade800
                  : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(20)),
      child: Text(message),
    );
  }
}
