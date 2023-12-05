import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/chat/message_box.dart';
import 'package:flutter_chat_app/widgets/chat/messages.dart';

import '../../utils/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const String route = "/chat_screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  @override
  void initState() {
    super.initState();
    setupFirebaseMessaging();
  }

  void setupFirebaseMessaging() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Listen when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.notification?.body}");
    });

    // Listen when the app is opened from a background or terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: ${message.notification?.body}");
    });
  }


  @override
  Widget build(BuildContext context)  {

    return FutureBuilder(
      future: getUserData(),
      builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Chat Screen"),
            centerTitle: true,
            actions: [
              DropdownButton(
                underline: Container(),
                icon: const Icon(Icons.more_vert),
                dropdownColor: Theme.of(context).primaryIconTheme.color,
                items: const [
                  DropdownMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text("Logout"),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                },
              ),
            ],
          ),
          body: Container(
            child: Column(
              children: [
                const Expanded(child: Messages()),
                MessageBox(sendMessage: (String message) {
                  sendMessage(message , snapshot.data!['userName']!,
                      snapshot.data!['userImage']);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void sendMessage(String message, String userName , String? userImage) async {
    if (message.trim().isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance.collection(Constants.MESSAGES_COLLECTION).add({
        'text': message,
        'created_at': DateTime.now(),
        'userId': user.uid,
        'userName': userName,
        'userImage' : userImage
      });
    }
  }

  Future<Map<String , String>> getUserData() async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection(Constants.USERS_COLLECTION)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return {
      'userName':userSnapshot.data()?['userName'],
      'userImage': userSnapshot.data()?['imageUrl']
    };

  }

}
