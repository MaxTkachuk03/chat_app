// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  MessageModel({
    required this.receiverId,
    required this.senderId,
    required this.senderEmail,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  final String receiverId;
  final String senderId;
  final String senderEmail;
  final String message;
  final Timestamp timestamp;
  final bool isRead;

  Map<String, dynamic> toMap() {
    return {
      'recieverId': receiverId,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'message': message,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}
