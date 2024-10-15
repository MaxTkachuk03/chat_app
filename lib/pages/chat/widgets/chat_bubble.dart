import 'package:chat_app/main.dart';
import 'package:chat_app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:nil/nil.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  final String message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Container(
          constraints: BoxConstraints(maxWidth: width / 1.3),
          decoration: BoxDecoration(
              color: isCurrentUser
                  ? isDarkMode
                      ? Colors.green.shade700
                      : Colors.green.shade500
                  : isDarkMode
                      ? Theme.of(context).colorScheme.inversePrimary
                      : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(16.0)),
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
            style: TextStyle(
                color: isCurrentUser
                    ? Theme.of(context).colorScheme.tertiary
                    : isDarkMode
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.inversePrimary),
          )),
    );
  }
}
