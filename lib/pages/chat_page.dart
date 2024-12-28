import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/components/chat_bubble.dart';
import 'package:minimal_chat_app/services/auth/auth_service.dart';
import 'package:minimal_chat_app/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  ChatPage({super.key, required this.receiverId, required this.receiverEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  // chat and auth services
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(Duration(milliseconds: 500), () => scrollDown());
  }


  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
  }

  // send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverId, _messageController.text);
      log("message............");
      //clear the controller
      _messageController.clear();
      scrollDown();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Column(
        children: [
          //display all messages
          Expanded(child: _buildMessageList()),

          //user input
          _buildUserInput(),
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
            return Text("Loading");
          }

          return ListView(
            controller: _scrollController,
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList());
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //is current user
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;

    //align message to the right if sender is the current user , otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                ChatBubble(
                    message: data["message"], isCurrentUser: isCurrentUser)
              ]),
        ));
  }

  Widget _buildUserInput() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: myFocusNode,
              controller: _messageController,
              decoration: InputDecoration(
                  hintText: "Type message",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.green),
            margin: EdgeInsets.only(left: 10),
            child: IconButton(
                onPressed: () {
                  sendMessage();
                },
                icon: Icon(Icons.arrow_upward_rounded)),
          ),
        ],
      ),
    );
  }
}
