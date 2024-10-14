import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
