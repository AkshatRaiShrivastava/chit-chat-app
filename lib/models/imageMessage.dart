import 'package:cloud_firestore/cloud_firestore.dart';

class ImageMessage {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final String type;
  final Timestamp timestamp;

  ImageMessage(
      {required this.senderID,
        required this.senderEmail,
        required this.receiverID,
        required this.message,
        required this.type,
        required this.timestamp});

  // convert to a map

  Map<String, dynamic> toMap(){
    return {
      'senderId' : senderID,
      'senderEmail' : senderEmail,
      'receiverId' : receiverID,
      'message' : message,
      'type' : type,
      'timestamp' : timestamp
    };
  }
}