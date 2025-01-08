import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minimal_chat_app/components/image_bubble.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/components/chat_bubble.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  final String receiverName;
  const ChatPage(
      {super.key,
      required this.receiverId,
      required this.receiverEmail,
      required this.receiverName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // chat and auth services
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //scrollDown();
    // add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 500), () => scrollDown());
      }
    });
    Future.delayed(Duration(milliseconds: 300), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //pick image
  // Improved pickImage function
  Future<void> pickImage() async {
    try {
      // Request necessary permissions
      await requestPermissions();

      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);

      if (images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No images selected')),
        );
        return;
      }

      for (var image in images) {
        log('Image path: ${image.path}');
        await _sendImage(File(image.path));
      }
    } catch (e) {
      log('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  // Function to send the image to Cloudinary
  Future<void> _sendImage(File file) async {
    try {
      // Show a loading indicator during the upload
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Call ChatService's sendImages method
      await _chatService.sendImages(widget.receiverId, file);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image sent successfully')),
      );
    } catch (e) {
      log('Error sending image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send image: $e')),
      );
    } finally {
      Navigator.of(context).pop(); // Dismiss the loading indicator
    }
  }

  // Improved requestPermissions function
  Future<void> requestPermissions() async {
    try {
      if (await Permission.camera.isDenied) {
        await Permission.camera.request();
      }
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }
    } catch (e) {
      log('Permission request error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission request failed: $e')),
      );
    }
  }

  //scroll controller

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
  }

  // send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverId, _messageController.text);
      //log("message............");
      //clear the controller
      _messageController.clear();
      //scrollDown();
    }
  }

  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;

    _tapPosition = renderBox.globalToLocal(tapPosition.globalPosition);
    log(_tapPosition.toString());
  }

  void _showContextMenu(
      context, textToCopy, docId, senderId, bool isImage) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();
    if (isImage) {
      final result = await showMenu(
          context: context,
          position: RelativeRect.fromRect(
              Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 15, 10),
              Rect.fromLTWH(0, 0, overlay!.paintBounds.size.height,
                  overlay!.paintBounds.size.width)),
          items: [
            PopupMenuItem(
              child: Row(children: [
                Icon(Icons.save_alt_sharp),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Save',
                  style: TextStyle(fontSize: 16),
                )
              ]),
              value: 'save',
            ),
            PopupMenuItem(
              child: Row(children: [
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Delete',
                  style: TextStyle(fontSize: 16),
                )
              ]),
              value: 'delete',
            ),
          ]);
      if (result == 'save') {
        await downloadImage(textToCopy, docId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved !')),
        );
      } else if (result == 'delete') {
        if (senderId == _authService.getCurrentUser()!.uid) {
          await _chatService.deleteMessage(docId, widget.receiverId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not delete this message')),
          );
        }
      }
    } else {
      final result = await showMenu(
          context: context,
          position: RelativeRect.fromRect(
              Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 15, 10),
              Rect.fromLTWH(0, 0, overlay!.paintBounds.size.height,
                  overlay.paintBounds.size.width)),
          items: [
            PopupMenuItem(
              child: Row(children: [
                Icon(Icons.copy),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Copy',
                  style: TextStyle(fontSize: 16),
                )
              ]),
              value: 'copy',
            ),
            PopupMenuItem(
              child: Row(children: [
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Delete',
                  style: TextStyle(fontSize: 16),
                )
              ]),
              value: 'delete',
            ),
          ]);
      if (result == 'copy') {
        Clipboard.setData(ClipboardData(text: textToCopy));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copied to clipboard!')),
        );
      } else if (result == 'delete') {
        if (senderId == _authService.getCurrentUser()!.uid) {
          await _chatService.deleteMessage(docId, widget.receiverId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not delete this message')),
          );
        }
      }
    }
  }

  Future<void> downloadImage(String imageUrl, String fileName) async {
    try {
      // Send HTTP GET request
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Get the directory to save the image
        Directory? downloadsDir = await getDownloadsDirectory();
        if (downloadsDir == null) {
          debugPrint("Downloads directory not available");
          return;
        }
        final filePath = '${downloadsDir.path}/$fileName.jpg';

        // Write the file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        debugPrint('Image downloaded to $filePath');
      } else {
        debugPrint(
            'Failed to download image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error downloading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    //scrollDown();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          
          children: [
          ProfilePicture(
              name: widget.receiverName, radius: 20, fontsize: 20,
            ),
            SizedBox(width: 10,),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.receiverName,
              style: TextStyle(fontSize: 18),
            ),
            Text(widget.receiverEmail, style: TextStyle(fontSize: 16)),
          ]),
        ]),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                _buildMessageList(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildUserInput(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverId, senderId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: Colors.green,
            );
          }
          // scrollDown();
          return ListView(
              reverse: true,
              padding: EdgeInsets.only(bottom: 100),
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList());
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;
    Timestamp timestamp = data['timestamp'];
    DateTime time = timestamp.toDate();
    //align message to the right if sender is the current user , otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    String formattedTime = DateFormat('hh:mm a').format(time);
    if (data['type'] != 'url') {
      return Container(
          alignment: alignment,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Column(
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTapDown: (position) {
                      _getTapPosition(position);
                    },
                    onLongPress: () {
                      _showContextMenu(context, data["message"], doc.id,
                          data['senderId'], false);
                    },
                    child: ChatBubble(
                        message: data["message"],
                        isCurrentUser: isCurrentUser,
                        time: time.hour.toString()),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        formattedTime,
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.secondary),
                      )),
                ]),
          ));
    } else {
      return Container(
          alignment: alignment,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Column(
                crossAxisAlignment: isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTapDown: (position) {
                      _getTapPosition(position);
                    },
                    onLongPress: () {
                      _showContextMenu(context, data["message"], doc.id,
                          data['senderId'], true);
                    },
                    child: ImageBubble(
                        url: data["message"],
                        isCurrentUser: isCurrentUser,
                        time: time.hour.toString()),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        formattedTime,
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.secondary),
                      )),
                ]),
          ));
    }
  }

  Widget _buildUserInput() {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Container(
          decoration: BoxDecoration(
            // Semi-transparent black overlay
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    pickImage();
                  },
                  icon: Icon(
                    Icons.image_rounded,
                    color: themeNotifier.themeColor,
                    size: 35,
                  )),
              Expanded(
                child: TextField(
                  focusNode: myFocusNode,
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Type message...",
                    fillColor: Theme.of(context).colorScheme.primary,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: themeNotifier.themeColor,
                child: IconButton(
                  icon: Icon(Icons.arrow_upward_rounded, color: Colors.white),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
