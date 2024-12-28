import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context,listen:false).isDarkMode;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: isCurrentUser?Colors.green:isDarkMode?Colors.grey.shade800:Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20)
      ),
      child: Text(message),
    );
  }
}
