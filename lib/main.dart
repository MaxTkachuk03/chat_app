import 'package:chat_app/chat_app.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/provider/theme_provider.dart';
import 'package:chat_app/services/notifications/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final notify = NotificationServices();
  await notify.requestPermission();
  notify.setupInteractions();

  runApp(
    MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
        child: const ChatApp()),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Повідомлення у фоновому режимі: ${message.messageId}");
}
