import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minimal_chat_app/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
