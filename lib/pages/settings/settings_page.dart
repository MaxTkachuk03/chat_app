import 'package:chat_app/pages/pages.dart';
import 'package:chat_app/provider/theme_provider.dart';
import 'package:chat_app/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final authServices = AuthServices();

  Future<void> _confrimDeleting(BuildContext context) async {
    // store user's decision in this boolean
    bool confirm = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text(
                      'This will delete your account permanently.Are your sure to proceed?'),
                  actions: [
                    MaterialButton(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                    MaterialButton(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ],
                )) ??
        false;

    // if the user confirmed, proceed with deletion
    if (confirm) {
      try {
        if (context.mounted) Navigator.pop(context);
        await AuthServices().deleteAccount();
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          MySettingsList(
            textColor: Theme.of(context).colorScheme.inversePrimary,
            color: Theme.of(context).colorScheme.secondary,
            title: 'Dark Mode',
            action: CupertinoSwitch(
              value: context.watch<ThemeProvider>().isDarkMode,
              onChanged: (theme) => context.read<ThemeProvider>().toggleTheme(),
            ),
          ),
          MySettingsList(
            textColor: Theme.of(context).colorScheme.inversePrimary,
            color: Theme.of(context).colorScheme.secondary,
            title: 'Blocked Users',
            action: IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlockedUsersPages())),
                icon: Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                )),
          ),
          MySettingsList(
              textColor: Theme.of(context).colorScheme.tertiary,
              title: 'Delete Account',
              action: IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () => _confrimDeleting(context),
                  icon: Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 30,
                    color: Theme.of(context).colorScheme.tertiary,
                  )),
              color: Colors.red)
        ],
      ),
    );
  }
}
