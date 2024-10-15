import 'package:chat_app/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

/*
  List<Map<String, dynamic>> = 
  [
    {
      'email': test@gmail.com,
      'id': ..
    },
    {
      'email': ronaldo@gmail.com,
      'id': ..
    },
  ]

 */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    Stream<List<Map<String, dynamic>>> users =
        _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });

    return users;
  }

  Future<void> sendMessage(
      {required String recieverId, required String message}) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    MessageModel newMessage = MessageModel(
        recieverId: recieverId,
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        message: message,
        timestamp: timestamp);

    List<String> ids = [currentUserId, recieverId];
    ids.sort();
    String chatroomId = ids.join('_');

    _firestore
        .collection('chat_room')
        .doc(chatroomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(
      {required String userId, required String otherUserId}) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatroomId = ids.join('_');

    final getMessage = _firestore
        .collection('chat_room')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();

    return getMessage;
  }
}
