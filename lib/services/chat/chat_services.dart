import 'package:chat_app/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatServices with ChangeNotifier {
  // get instance
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

// get all user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    Stream<List<Map<String, dynamic>>> users =
        _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.data()['email'] != _auth.currentUser!.email)
          .map((doc) => doc.data())
          .toList();
    });

    return users;
  }

// send message
  Future<void> sendMessage(
      {required String recieverId, required String message}) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    MessageModel newMessage = MessageModel(
      receiverId: recieverId,
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      message: message,
      timestamp: timestamp,
      isRead: false,
    );

    List<String> ids = [currentUserId, recieverId];
    ids.sort();
    String chatroomId = ids.join('_');

    _firestore
        .collection('chat_room')
        .doc(chatroomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

// get message
  Stream<QuerySnapshot> getMessage(
      {required String senderId, required String receiverId}) {
    List<String> ids = [senderId, receiverId];
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

  // report user
  Future<void> reportUser(
      {required String messageId, required String userId}) async {
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('Reports').add(report);
  }

  // block user
  Future<void> blockUser({required String userId}) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});
    notifyListeners();
  }

  //unblock user
  Future<void> unBlockUser({required String blockedUserId}) async {
    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
  }

  //get blocked users stream
  Stream<List<Map<String, dynamic>>> blockedUsersStream(
      {required String userId}) {
    final result = _firestore
        .collection('Users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      // get list of blocked user ids
      final blockedUsersId = snapshot.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(blockedUsersId
          .map((id) => _firestore.collection('Users').doc(id).get()));

      // return as a list
      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });

    return result;
  }

  // get all users stream except the blocked
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;
    final result = _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {
      // get list of blocked user ids
      final blockedUsersId = snapshot.docs.map((doc) => doc.id).toList();
      // get all users
      final usersSnapshot = await _firestore.collection('Users').get();

      // return as a list, excluding current user and blocked users
      final usersData = await Future.wait(
        // get all docs
        usersSnapshot.docs
            .where((doc) =>
                doc.data()['email'] != _auth.currentUser!.email &&
                !blockedUsersId.contains(doc.id))
            .map((doc) async {
          // look at each user
          final userData = doc.data();
          // sort users id
          final sortedIds = [currentUser.uid, doc.id]..sort();
          // users chat rooms
          final chatRoomId = sortedIds.join('_');
          // count the numbers of unread messages
          final unreadMessagesSnapshot = await _firestore
              .collection('chat_room')
              .doc(chatRoomId)
              .collection('messages')
              .where('recieverId', isEqualTo: currentUser.uid)
              .where('isRead', isEqualTo: false)
              .get();

          userData['unreadCount'] = unreadMessagesSnapshot.docs.length;
          return userData;
        }).toList(),
      );

      return usersData;
    });

    return result;
  }

  // mark messages as reAd
  Future<void> markMessages({required String receiverId}) async {
    final String currentUserId = _auth.currentUser!.uid;

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');
    final unreadMessagesSnapshot = await _firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .where('recieverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in unreadMessagesSnapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }
}
