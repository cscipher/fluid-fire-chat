import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String bubbleText;
  final String deliverTime;
  final bool isSent;
  const ChatBubble({
    super.key,
    required this.bubbleText,
    required this.isSent,
    required this.deliverTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [Flexible(child: _getBubble(context))],
        ),
        Container(
          alignment: isSent ? Alignment.topRight : Alignment.topLeft,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text(
            deliverTime,
            style: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _getBubble(BuildContext context) {
    final theme = Theme.of(context);
    final isPureEmoji = _isOnlyEmojis(bubbleText);

    if (isPureEmoji) {
      return Text(bubbleText.split(' ').join(), style: const TextStyle(fontSize: 40));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isSent ? theme.primaryColor : theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        bubbleText,
        style: TextStyle(
          color: isSent ? Colors.white : theme.colorScheme.tertiary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  bool _isOnlyEmojis(String input) {
    input = input.split(' ').join();
    for (var char in input.characters) {
      if (!_isEmoji(char)) {
        return false;
      }
    }
    return true;
  }

  bool _isEmoji(String character) {
    return character.characters.length > 1 || character.codeUnitAt(0) > 255;
  }
}
