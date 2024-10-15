import 'package:chat_app/provider/theme_provider.dart';
import 'package:chat_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.messageId,
      required this.userId});

  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;

  // show options
  void _showOption(
      {required BuildContext context,
      required String messageId,
      required String userId}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(
                      context: context, messageId: messageId, userId: userId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block user'),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context: context, userId: userId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ));
        });
  }

  // report message
  void _reportMessage(
      {required BuildContext context,
      required String messageId,
      required String userId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Report Message'),
              content:
                  const Text('Are you sure you want to report this messgae?'),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    ChatServices()
                        .reportUser(messageId: messageId, userId: userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Message Reported")));
                  },
                  label: const Text('Report'),
                  icon: const Icon(Icons.report_gmailerrorred),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  label: const Text('Cancel'),
                  icon: const Icon(Icons.cancel),
                ),
              ],
            ));
  }

  // block user
  void _blockUser({required BuildContext context, required String userId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Block User'),
              content: const Text('Are you sure you want to block this user?'),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    ChatServices().blockUser(userId: userId);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User Blocked")));
                  },
                  label: const Text('Block'),
                  icon: const Icon(Icons.block),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  label: const Text('Cancel'),
                  icon: const Icon(Icons.cancel),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          _showOption(context: context, messageId: messageId, userId: userId);
        }
      },
      child: Padding(
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
      ),
    );
  }
}
