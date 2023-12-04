import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/utils/extentions.dart';
import 'package:flutter_chat_app/widgets/auth/insert_image_widget.dart';
import 'package:flutter_chat_app/widgets/mo_loading_button.dart';
import 'package:flutter_chat_app/widgets/mo_text_field.dart';

class AuthFormWidget extends StatefulWidget {
  const AuthFormWidget({required this.submitForm, super.key});

  final Function(String? name, String email, String password, bool isLogin,
      BuildContext ctx, File? imagePicked) submitForm;

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  File? _selectedImage = null;
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  var validEmail = false;
  var validName = false;
  var validPassword = false;

  var _isLogin = true;

  var warningHeight = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 8,
                ),
                AnimatedContainer(
                  height: _isLogin ? 0 : 160,
                  duration: const Duration(milliseconds: 200),
                  child: _isLogin
                      ? const SizedBox(
                          width: 0,
                          height: 0,
                        )
                      :  InsertImageWidget(selectImage: _selectImage,),
                ),
                _isLogin
                    ? const SizedBox(
                        height: 0,
                      )
                    : MoTextField(
                        fieldController: _userNameController,
                        hint: "User Name",
                        icon: Icons.person,
                        showIcon: true,
                        validate: (String text) {
                          final condition = text.length < 4 && text.isNotEmpty;
                    validName = condition;
                    return condition;
                  },
                  validationMessage: "Short Name",
                ),
                const SizedBox(
                  height: 8,
                ),
                MoTextField(
                  fieldController: _emailController,
                  inputType: TextInputType.emailAddress,
                  hint: "Email Address",
                  icon: Icons.email,
                  showIcon: true,
                  validate: (String text) {
                    final condition = (text.contains("@").not() ||
                        text.contains(".").not()) &&
                        text.isNotEmpty;
                    validEmail = condition;
                    return condition;
                  },
                  validationMessage: "wrong email pattern",
                ),
                const SizedBox(
                  height: 10,
                ),
                MoTextField(
                  fieldController: _passwordController,
                  hint: "Password",
                  icon: Icons.lock,
                  showIcon: true,
                  isPassword: true,
                  validate: (String text) {
                    final condition = text.length < 8;
                    validPassword = condition;
                    return condition;
                  },
                  validationMessage: "Short Password",
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: double.infinity,
                  child: MoLoadingButton(
                    onPressed: () async {
                      await _trySubmit();
                    },
                    child: Text(
                      _isLogin ? "Login" : "Signup",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin ? "Create new account" : "Login",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _trySubmit() async{
    final isValid = validPassword.not() &&
        (_isLogin ? true : validName.not()) &&
        validEmail.not();
    if (isValid.not()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "isValid $isValid , \npass ${validPassword.not()} \nname ${(_isLogin ? true : validName.not())} \nmail ${validEmail.not()} ")));
    }

    FocusScope.of(context).unfocus();

    if (isValid) {
      widget.submitForm(_userNameController.text, _emailController.text,
          _passwordController.text, _isLogin, context, _selectedImage);
    }
  }

  void _selectImage(File? file) {
    if (file != null) {
      _selectedImage = file;
    }
  }
}
