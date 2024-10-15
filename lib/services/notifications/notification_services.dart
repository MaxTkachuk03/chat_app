import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/subjects.dart';

class NotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _messageStreamController = BehaviorSubject<RemoteMessage>();

  // Request permission: call this in main on startup
  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User not accepted');
    }
  }

  // setup interactions
  void setupInteractions() {
    // user received message
    FirebaseMessaging.onMessage.listen((message) {
      print('foreground');
      print(message.data);

      _messageStreamController.sink.add(message);
    });

    // user opened message
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('open');
    });
  }

  void dispose() {
    _messageStreamController.close();
  }

  // setup token listeners
  Future<void> setupTokenListeners() async {
    await _firebaseMessaging.getToken().then((token) {
      saveTokenToDatabase(token);
    });

    _firebaseMessaging.onTokenRefresh.listen(saveTokenToDatabase);
  }

  // save device token
  void saveTokenToDatabase(String? token) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null && token != null) {
      FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
    }
  }

  // clear device token
  Future<void> clearTokenOnLogout(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
      });

      print('token deleted');
    } catch (e) {
      print('faild clear');
    }
  }
}
