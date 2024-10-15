import 'package:chat_app/provider/theme_provider.dart';
import 'package:chat_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: context.watch<ThemeProvider>().themeData,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
        });
  }
}
