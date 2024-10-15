import 'package:chat_app/pages/home/home.dart';
import 'package:chat_app/services/services.dart';
import 'package:flutter/material.dart';

class BlockedUsersPages extends StatelessWidget {
  BlockedUsersPages({super.key});

  final _authServices = AuthServices();
  final _chatServices = ChatServices();

  // unblock boc
  void _unblockUser({required BuildContext context, required String userId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Unblock User'),
              content:
                  const Text('Are you sure you want to unblock this user?'),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    _chatServices.unBlockUser(blockedUserId: userId);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User Blocked")));
                  },
                  label: const Text('Unblock'),
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
    final userId = _authServices.getCurrentUser()!.uid;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: const Text("B L O C K E D  U S E R S"),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chatServices.blockedUsersStream(userId: userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null) {
              return const Center(child: Text("No data!"));
            }
            final blockedUser = snapshot.data ?? [];

            if (blockedUser.isEmpty) {
              return const Center(child: Text("No blocked users!"));
            }

            return ListView.builder(
                itemCount: blockedUser.length,
                itemBuilder: (context, index) {
                  final user = blockedUser[index];
                  return UserTile(
                      onTap: () =>
                          _unblockUser(context: context, userId: user['uid']),
                      text: user['email']);
                });
          }),
    );
  }
}
