import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/mo_text_field.dart';

class MessageBox extends StatelessWidget {
  MessageBox({required this.sendMessage,super.key});

  final _sendMessageController = TextEditingController();
  final Function sendMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8 , left: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: MoTextField(
              fieldController: _sendMessageController,
              hint: "enter new message...",
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              sendMessage(_sendMessageController.text);
              _sendMessageController.text = "";
            },
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
