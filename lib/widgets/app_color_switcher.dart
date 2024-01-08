import 'package:chat_room_demo/utils/theme_notifier.dart';
import 'package:flutter/material.dart';

class AppColorSwitcher extends StatelessWidget {
  final VoidCallback? onTap;
  final double? size;
  final Color? color;
  const AppColorSwitcher({
    super.key,
    this.onTap,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap ?? () => ColorSwitcherDialog.show(context),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color ?? primaryColor,
              border: Border.all(width: 4, color: Colors.white),
              borderRadius: BorderRadius.circular(100),
            ),
            height: size ?? 40,
            width: size ?? 40,
          ),
          if (color == primaryColor)
            Container(
              height: (size ?? 40),
              width: (size ?? 40),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.8),
                border: Border.all(width: 4, color: Colors.white),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(Icons.done, color: Colors.white),
            ),
        ],
      ),
    );
  }
}

class ColorSwitcherDialog extends StatelessWidget {
  const ColorSwitcherDialog({super.key});

  ColorSwitcherDialog.show(BuildContext context, {super.key}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Choose App theme Color!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AppColorSwitcher(
                          size: 60,
                          color: Colors.amber,
                          onTap: () {
                            currentTheme.updateTheme(ThemeEnum.amber);
                          },
                        ),
                        AppColorSwitcher(
                          size: 60,
                          color: Colors.cyan,
                          onTap: () {
                            currentTheme.updateTheme(ThemeEnum.cyan);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
