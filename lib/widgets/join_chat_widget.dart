import 'package:flutter/material.dart';

class JoinChatWidget extends StatefulWidget {
  final Function(String) joinCallback;
  const JoinChatWidget({super.key, required this.joinCallback});

  @override
  State<JoinChatWidget> createState() => _JoinChatWidgetState();
}

class _JoinChatWidgetState extends State<JoinChatWidget> {
  final TextEditingController _controller = TextEditingController();
  bool activeJoin = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Enter Joining code...",
                hintStyle: const TextStyle(color: Color.fromARGB(255, 118, 118, 118)),
                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                counterText: '',
                suffixIcon: GestureDetector(
                  onTap: !activeJoin
                      ? null
                      : () async {
                          widget.joinCallback.call(_controller.text);
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    color: activeJoin ? theme.primaryColor : Colors.transparent,
                    child: Icon(
                      Icons.chevron_right,
                      color: activeJoin ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                border: const OutlineInputBorder(),
              ),
              controller: _controller,
              maxLength: 6,
              onChanged: (value) {
                if (value.length == 6 && !activeJoin) {
                  setState(() => activeJoin = true);
                } else if (activeJoin) {
                  setState(() => activeJoin = false);
                }
              },
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
