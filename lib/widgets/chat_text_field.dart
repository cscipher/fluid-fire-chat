import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  final Function(String) onSendCallback;
  const ChatTextField({super.key, required this.onSendCallback});

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  bool isEnabled = false;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  Widget get _sendButton => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isEnabled ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: IconButton(
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.grey,
          ),
          icon: const Icon(Icons.send_rounded, size: 18),
          onPressed: isEnabled
              ? () {
                  widget.onSendCallback.call(_textEditingController.text);
                  _textEditingController.clear();
                  setState(() {
                    isEnabled = false;
                  });
                }
              : null,
        ),
      );
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewPadding.bottom + MediaQuery.of(context).viewInsets.bottom + 20,
        left: 16,
        right: 16,
        top: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        boxShadow: const [BoxShadow(blurRadius: 20, spreadRadius: 1, color: Color.fromARGB(255, 214, 214, 214))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _textEditingController,
              onChanged: (value) {
                if (value.isNotEmpty && !isEnabled) {
                  setState(() {
                    isEnabled = true;
                  });
                } else if (value.isEmpty && isEnabled) {
                  setState(() {
                    isEnabled = false;
                  });
                }
              },
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Type something to send...",
                fillColor:
                    _focusNode.hasFocus ? theme.colorScheme.tertiary.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                filled: true,
                focusColor: theme.primaryColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _sendButton,
        ],
      ),
    );
  }
}
