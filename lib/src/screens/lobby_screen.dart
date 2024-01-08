// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'dart:math' show pi;
import 'package:chat_room_demo/commons/asset-constants.dart';
import 'package:chat_room_demo/src/screens/chat_room_screen.dart';
import 'package:chat_room_demo/src/screens/lobby_screen_controller.dart';
import 'package:chat_room_demo/widgets/app_color_switcher.dart';
import 'package:chat_room_demo/widgets/join_chat_widget.dart';
import 'package:flutter/material.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> with SingleTickerProviderStateMixin {
  bool isAbsorbing = false;

  /// TODO: remove hardcoded colors when the image color palette algorithm is fixed.
  final _gradientColors = <Color>[
    Colors.amberAccent,
    Colors.white,
    Colors.white,
    Colors.lightBlue,
    Colors.white,
    Colors.transparent,
    Colors.amberAccent,
    Colors.white,
    Colors.lightBlue
  ];

  late final LobbyScreenController _screenController;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _screenController = LobbyScreenController();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 6), upperBound: pi);

    _animationController.addListener(() {
      setState(() {});
    });

    /// This animation controller is responsible for background gradient rotation
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  colors: _gradientColors,
                  transform: GradientRotation(_animationController.value),
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 200,
              sigmaY: 70,
            ),
            child: Container(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AssetConstants.sparkyDashGif,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height / 4,
            child: AbsorbPointer(
              absorbing: isAbsorbing,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white.withOpacity(0.65),
                ),
                padding: const EdgeInsets.all(40),
                margin: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Chat Lobby",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Join an existing friend's room"),
                    const SizedBox(height: 8),
                    JoinChatWidget(joinCallback: _joinRoomCallback),
                    const SizedBox(height: 40),
                    const Text("or Create a new chat room here!"),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _createRoomCallback,
                      child: const Text("Create room"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isAbsorbing)
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.grey.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator.adaptive()),
            ),
          const Positioned(
            right: 10,
            top: 50,
            child: AppColorSwitcher(),
          ),
        ],
      ),
    );
  }

  void _joinRoomCallback(String code) async {
    if (code.isNotEmpty) {
      setState(() => isAbsorbing = true);
      final response = await _screenController.joinExistingRoom(code);
      setState(() => isAbsorbing = false);
      if (response) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(roomCode: code),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No room found!")));
    }
  }

  void _createRoomCallback() async {
    setState(() => isAbsorbing = true);
    final createRoomDetails = await _screenController.createNewRoom();
    setState(() => isAbsorbing = false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatRoomScreen(
          roomCode: createRoomDetails['roomCode']!,
        ),
      ),
    );
  }
}
