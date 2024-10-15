import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.onTap, required this.text});

  final void Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
        child: Row(
          children: [
            const Icon(Icons.person_rounded),
            const SizedBox(width: 10.0),
            Text(text)
          ],
        ),
      ),
    );
  }
}
