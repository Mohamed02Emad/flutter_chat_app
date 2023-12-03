import 'package:cloud_firestore/cloud_firestore.dart';
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
