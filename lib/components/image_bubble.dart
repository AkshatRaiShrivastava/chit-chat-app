import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class ImageBubble extends StatelessWidget {
  final String url;
  final bool isCurrentUser;
  final String time;
  const ImageBubble(
      {super.key,
      required this.url,
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
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: isCurrentUser
              ? themeNotifier.themeColor
              : isDarkMode
              ? Colors.grey.shade800
              : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(20)),
      child: Image.network(url)
    );
  }
}
