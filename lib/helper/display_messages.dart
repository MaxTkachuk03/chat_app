import 'package:flutter/material.dart';

void displayMessages(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              message,
              style: const TextStyle(fontSize: 20.0),
            ),
          ));
}
