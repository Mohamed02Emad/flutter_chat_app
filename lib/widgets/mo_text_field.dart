import 'package:flutter/material.dart';

class MoTextField extends StatefulWidget {
  final bool isPassword ;
  final String hint ;
  final IconData icon ;
  final bool showIcon ;
  final TextEditingController fieldController ;

   const MoTextField(
      {super.key,
        this.icon = Icons.email,
        this.hint = "",
        this.isPassword = false,
        this.showIcon = false,
        required this.fieldController,
      });

  @override
  State<MoTextField> createState() => _MoTextFieldState();
}

class _MoTextFieldState extends State<MoTextField> {
  bool _isPasswordVisible = false;

  _MoTextFieldState();

  @override
  Widget build(BuildContext context) {
    if (widget.isPassword) {
      return passwordTextField(fieldController: widget.fieldController, hint: widget.hint);
    } else {
      return normalTextField(
          fieldController: widget.fieldController,
          hint: widget.hint,
          isPassword: widget.isPassword);
    }
  }

  Widget passwordTextField({
    required TextEditingController fieldController,
    String hint = "",
  }) {
    return Container(
      // margin: const EdgeInsets.only(left: 12, right: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: TextField(
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
      // margin: const EdgeInsets.only(left: 12, right: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: TextField(
        controller: fieldController,
        decoration: InputDecoration(
          hintText: hint,
          icon: widget.showIcon ?  Icon(widget.icon) : null,
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