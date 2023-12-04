import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/utils/constants.dart';
import 'package:flutter_chat_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser!),
        builder: (BuildContext context, AsyncSnapshot<User> idSnapShot) {
          if (idSnapShot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              color: Colors.white,
            );
          }

          return Container(
            padding: const EdgeInsets.all(8),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(Constants.MESSAGES_COLLECTION)
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.blue,
                    ));
                  } else {
                    return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) {
                          final isMe = idSnapShot.data!.uid ==
                              snapshot.data?.docs[index]['userId'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: MessageBubble(
                                userName: snapshot.data!.docs[index]
                                    ['userName'],
                                userImage: snapshot.data!.docs[index]
                                    ['userImage'],
                                isMe: isMe,
                                userId: snapshot.data!.docs[index]['userId'],
                                message: snapshot.data!.docs[index]['text']
                                    .toString()),

                          );
                        });
                  }
                }),
          );
        });
  }
}
