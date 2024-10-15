// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  MessageModel({
    required this.recieverId,
    required this.senderId,
    required this.senderEmail,
    required this.message,
    required this.timestamp,
  });

  final String recieverId;
  final String senderId;
  final String senderEmail;
  final String message;
  final Timestamp timestamp;

  Map<String, dynamic> toMap() {
    return {
      'recieverId': recieverId,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
