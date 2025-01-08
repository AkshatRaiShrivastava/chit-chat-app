import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minimal_chat_app/models/imageMessage.dart';
import 'package:minimal_chat_app/models/message.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String cloudinaryApiKey = "746222329139784";
  final String cloudinaryApiSecret = "uLrnd6eyX2C6iOeSfQdtuXx_F8w";
  final String cloudinaryCloudName = "di22keonp";
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverId, message) async {
    // get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    try {
      // create a new message
      Message newMessage = Message(
          senderID: currentUserId,
          senderEmail: currentUserEmail,
          receiverID: receiverId,
          message: message,
          timestamp: timestamp);
      // construct chat room ID for the two users (sorted to ensure uniqueness)
      List<String> ids = [currentUserId, receiverId];
      ids.sort();
      String chatroomId = ids.join('_');

      // add new message to database
      await _firestore
          .collection("chat_rooms")
          .doc(chatroomId)
          .collection("messages")
          .add(newMessage.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  //delete messages
  Future<void> deleteMessage(String messageId, String receiverId) async {
    try {
      final String currentUserId = _auth.currentUser!.uid;
      List<String> ids = [currentUserId, receiverId];
      ids.sort();
      String chatroomId = ids.join('_');
      await _firestore
          .collection("chat_rooms")
          .doc(chatroomId)
          .collection('messages')
          .doc(messageId)
          .delete();
      log('Message deleted successfully.');
    } catch (e) {
      log('Failed to delete message: $e');
    }
  }

  // send images
  Future<void> sendImages(String receiverId, File file) async {
    try {
      final String currentUserId = _auth.currentUser!.uid;
      final String currentUserEmail = _auth.currentUser!.email.toString();

      // Construct chat room ID
      List<String> ids = [currentUserId, receiverId];
      ids.sort();
      String chatroomId = ids.join('_');

      // Upload file to Cloudinary
      final String imageUrl = await uploadToCloudinary(file);

      if (imageUrl.isEmpty) {
        throw Exception('Image upload failed.');
      }

      // Create an image message
      ImageMessage imgMsg = ImageMessage(
        senderID: currentUserId,
        senderEmail: currentUserEmail,
        receiverID: receiverId,
        message: imageUrl,
        type: "url",
        timestamp: Timestamp.now(),
      );

      // Add the image message to Firestore
      await _firestore
          .collection("chat_rooms")
          .doc(chatroomId)
          .collection("messages")
          .add(imgMsg.toMap());

      log('Image message sent successfully.');
    } catch (e) {
      log('Failed to send image: $e');
    }
  }

  

  Future<String> uploadToCloudinary(File file) async {
    try {
      final Uri uri = Uri.parse(
          "https://api.cloudinary.com/v1_1/$cloudinaryCloudName/upload");

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = 'akshat'
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['secure_url'] as String;
      } else {
        log('Cloudinary upload failed: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      log('Error uploading to Cloudinary: $e');
      return '';
    }
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userId, otherUserId) {
    // construct a chatroom id for the two users
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatroomID = ids.join("_");

    return _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
