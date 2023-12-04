import 'package:cloud_firestore/cloud_firestore.dart';
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
  Widget build(BuildContext context)  {

    return FutureBuilder(
      future: getUserName(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Chat Screen"),
            centerTitle: true,
            actions: [
              DropdownButton(
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
              )
            ],
          ),
          body: Container(
            child: Column(
              children: [
                const Expanded(child: Messages()),
                MessageBox(sendMessage: (String message) {
                  sendMessage(message , snapshot.data!);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void sendMessage(String message, String userName) async {
    if (message.trim().isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance.collection(Constants.MESSAGES_COLLECTION).add({
        'text': message,
        'created_at': DateTime.now(),
        'userId': user.uid,
        'userName': userName,
      });
    }
  }

  Future<String> getUserName() async {
    final userNameSnapshot = await FirebaseFirestore.instance
        .collection(Constants.USERS_COLLECTION)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return userNameSnapshot.data()?['userName'];

  }

}
