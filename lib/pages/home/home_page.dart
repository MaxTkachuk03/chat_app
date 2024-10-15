import 'package:chat_app/pages/pages.dart';
import 'package:chat_app/services/services.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authServices = AuthServices();
  final _chatServices = ChatServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
        title: const Text("H O M E"),
      ),
      body: StreamBuilder(
          stream: _chatServices.getUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.data == null) {
              return const Text("No data!");
            }
            return ListView(
              children: snapshot.data!.map<Widget>((userData) {
                return UserTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  recieverEmail: userData['email'],
                                  recieverId: userData['uid'],
                                )));
                  },
                  text: userData['email'],
                );
              }).toList(),
            );
          }),
    );
  }
}
