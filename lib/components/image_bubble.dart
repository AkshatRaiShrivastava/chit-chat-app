import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class ImageBubble extends StatelessWidget {
  final String url;
  final bool isCurrentUser;
  final String time;
  final bool isViewOnce;
  final String messageId;
  final String receiverId;
  final bool? hasOpened;

  const ImageBubble({
    super.key,
    required this.isViewOnce,
    required this.url,
    required this.isCurrentUser,
    required this.time,
    required this.messageId,
    required this.receiverId,
    required this.hasOpened,
  });

  @override
  Widget build(BuildContext context) {
    ChatService chatService = ChatService();

    void showViewOnceImage(BuildContext context) {
      if (hasOpened == null || hasOpened == false) {
        // Show the image only if it hasn't been opened before
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Image.network(
                url,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // The image has fully loaded
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return const Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.red, // Fallback for failed loading
                  );
                },
              ),
            );
          },
        ).then((_) {
          // Update the backend to mark the image as opened
          chatService.openedViewOnce(messageId, receiverId);
        });
      } else {
        // Show a message indicating the image has already been viewed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This image can only be viewed once.')),
        );
      }
    }

    final themeNotifier = Provider.of<ThemeProvider>(context);
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return isViewOnce
        ? GestureDetector(
            onTap: () {
              isCurrentUser
                  ? showDialog(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content: const SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Sorry, you can not open this image !'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    )
                  : showViewOnceImage(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? themeNotifier.themeColor
                    : isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                
                children: [
                  const Icon(Iconsax.shield_tick),
                  const SizedBox(width: 10),
                  Text(
                    hasOpened == true ? 'Viewed' : 'View once image',
                    style: TextStyle(
                      color: hasOpened == true ? Colors.grey : null,
                      fontStyle: hasOpened == true
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Image.network(
                        url,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // The image has fully loaded
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return const Icon(
                            Icons.error,
                            size: 50,
                            color: Colors.red, // Fallback for failed loading
                          );
                        },
                      ),
                    );
                  });
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? themeNotifier.themeColor
                    : isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  url,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // The image has fully loaded
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Icon(
                      Icons.error,
                      size: 50,
                      color: Colors.red, // Fallback for failed loading
                    );
                  },
                ),
              ),
            ),
          );
  }
}
