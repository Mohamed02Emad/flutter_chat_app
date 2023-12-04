import 'package:flutter/material.dart';

class MoTextField extends StatefulWidget {
  final bool isPassword;

  final String hint;

  final IconData icon;

  final bool showIcon;

  final TextEditingController fieldController;

  final TextInputType inputType;

  final Function? validate;

  final String? validationMessage;

  const MoTextField({
    super.key,
    this.icon = Icons.email,
    this.hint = "",
    this.isPassword = false,
    this.showIcon = false,
    this.inputType = TextInputType.text,
    this.validate,
    this.validationMessage,
    required this.fieldController,
  });

  @override
  State<MoTextField> createState() => _MoTextFieldState();
}

class _MoTextFieldState extends State<MoTextField> {
  bool _isPasswordVisible = false;

  double mHeight = 15;
  bool showValidate = false;

  _MoTextFieldState();

  @override
  Widget build(BuildContext context) {
    changeSize();
    String message = widget.validationMessage ?? "Error";

    if (widget.isPassword) {
      return passwordTextField(
          fieldController: widget.fieldController, hint: widget.hint);
    } else {
      return Column(
        children: [
          normalTextField(
              fieldController: widget.fieldController,
              hint: widget.hint,
              isPassword: widget.isPassword),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: double.infinity,
            height: mHeight,
            curve: Curves.fastOutSlowIn,
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          )
        ],
      );
    }
  }

  checkValidation() {
    setState(() {
      if (widget.validate != null) {
        showValidate = widget.validate!(widget.fieldController.text);
      } else {
        showValidate = false;
      }
    });
    changeSize();
  }

  void changeSize() {
    setState(() {
      mHeight = (showValidate) ? 19 : 0;
    });
  }

  Widget passwordTextField({
    required TextEditingController fieldController,
    String hint = "",
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: TextField(
        onChanged: (txt) {
          checkValidation();
        },
        keyboardType: widget.inputType,
        controller: fieldController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: hint,
          icon: const Icon(Icons.lock),
          iconColor: Colors.grey[400],
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[400],
            ),
          ),
        ),
        cursorColor: Colors.grey[400],
      ),
    );
  }

  Widget normalTextField({
    required TextEditingController fieldController,
    String hint = "",
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: TextField(
        onChanged: (txt) {
          checkValidation();
        },
        keyboardType: widget.inputType,
        controller: fieldController,
        decoration: InputDecoration(
          hintText: hint,
          icon: widget.showIcon ? Icon(widget.icon) : null,
          iconColor: Colors.grey[400],
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        cursorColor: Colors.grey[400],
      ),
    );
  }
}