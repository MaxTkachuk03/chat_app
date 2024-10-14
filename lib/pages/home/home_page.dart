import 'package:chat_app/pages/pages.dart';
import 'package:chat_app/services/services.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:nil/nil.dart';

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
      drawerScrimColor: Theme.of(context).colorScheme.primary,
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Home"),
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
                print(userData['email']);
                if (userData['email'] !=
                    _authServices.getCurrentUser()?.email) {
                  return UserTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                    email: userData['email'],
                                  )));
                    },
                    text: userData['email'],
                  );
                }
                return nil;
              }).toList(),
            );
          }),
    );
  }
}
