import 'package:chat_app/services/services.dart';
import 'package:chat_app/theme/theme.dart';
import 'package:flutter/material.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ligthMode,
      home: const AuthPage(),
    );
  }
}
