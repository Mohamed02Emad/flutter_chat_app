import 'package:flutter/material.dart';

class MoLoadingButton extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onPressed;
  final bool isLoading;

  const MoLoadingButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  _MoLoadingButtonState createState() => _MoLoadingButtonState();
}

class _MoLoadingButtonState extends State<MoLoadingButton> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
      ),
      onPressed: _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await widget.onPressed();
              await Future.delayed(const Duration(milliseconds: 300));
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : widget.child,
    );
  }
}
