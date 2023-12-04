import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_app/utils/constants.dart';
import 'package:flutter_chat_app/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  static const String route = "/auth_screen";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _fireBaseAuthInstance = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthFormWidget(
        submitForm: _submit,
      ),
    );
  }

  void _submit(
    String? name,
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
    File? pickedImage,
  ) async {
    UserCredential result;
    try {
      if (isLogin) {
        result = await _fireBaseAuthInstance
            .signInWithEmailAndPassword(email: email.trim(), password: password.trim());
        if(result.user == null){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
        }
      } else {
        result = await _fireBaseAuthInstance.createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim());
        String? imageUrl = null;
        if(pickedImage != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child("${result.user!.uid}.jpg");
          await ref.putFile(pickedImage).whenComplete(() => {});
          imageUrl = await ref.getDownloadURL();
        }
        await FirebaseFirestore.instance
            .collection(Constants.USERS_COLLECTION)
            .doc(result.user!.uid)
            .set({
          'userName': name,
          'email': email,
          'createdAt': DateTime.now().toUtc().toString(),
          'imageUrl': imageUrl
        });
      }
    } on PlatformException catch (error) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
    } catch (error) {
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
