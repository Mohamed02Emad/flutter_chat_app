import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/utils/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const String route = "/chat_screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
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
              if (value == 'logout'){
                FirebaseAuth.instance.signOut();
              }
            },
          )

        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(Constants.MESSAGES_COLLECTION)
            .snapshots(),
        builder: (ctx, snapShot) {

          if(snapShot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: Colors.blue ,),);
          }

          return ListView.builder(
            itemCount: snapShot.data?.docs.length ?? 0,
            itemBuilder: (ctx, index) => Center(
              child: Container(
                margin: const EdgeInsets.all(12),
                // color: Colors.red,
                child: Text(snapShot.data?.docs[index]['text']),
              ),
            ),
          );
        },
      ),
      floatingActionButton:
          FloatingActionButton(child: const Icon(Icons.add), onPressed: () {
            FirebaseFirestore.instance.collection(Constants.MESSAGES_COLLECTION).add(
              {
                'text' : "Added From Button"
              }
            );
          }),
    );
  }
}
