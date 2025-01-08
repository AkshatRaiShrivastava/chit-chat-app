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
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: isCurrentUser
                ? themeNotifier.themeColor
                : isDarkMode
                    ? Colors.grey.shade800
                    : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              url,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child; // The image has fully loaded
                }
                return CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                );
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Icon(Icons.error,
                    size: 50, color: Colors.red); // Fallback for failed loading
              },
            )));
  }
}
