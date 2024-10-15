import 'package:flutter/material.dart';

class MySettingsList extends StatelessWidget {
  const MySettingsList(
      {super.key,
      required this.title,
      required this.action,
      required this.color,
      required this.textColor});

  final String title;
  final Widget action;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(16.0)),
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: textColor),
          ),
          action
        ],
      ),
    );
  }
}
