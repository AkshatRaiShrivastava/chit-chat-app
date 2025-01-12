import 'package:cloud_firestore/cloud_firestore.dart';

class ImageMessage {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final String type;
  final Timestamp timestamp;
  final bool isViewOnce;
  final bool hasOpened;

  ImageMessage(
      {required this.senderID,
      required this.hasOpened,
        required this.senderEmail,
        required this.receiverID,
        required this.message,
        required this.type,
        required this.isViewOnce,
        required this.timestamp,});

  // convert to a map

  Map<String, dynamic> toMap(){
    return {
      'senderId' : senderID,
      'senderEmail' : senderEmail,
      'receiverId' : receiverID,
      'message' : message,
      'type' : type,
      'hasOpened' : hasOpened,
      'isViewOnce' : isViewOnce,
      'timestamp' : timestamp
    };
  }
}