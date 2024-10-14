import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(email),
      ),
    );
  }
}
