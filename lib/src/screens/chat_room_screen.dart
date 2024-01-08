import 'dart:ui';
import 'dart:math' show pi;
import 'package:chat_room_demo/commons/asset-constants.dart';
import 'package:chat_room_demo/models/chat_model.dart';
import 'package:chat_room_demo/widgets/app_color_switcher.dart';
import 'package:chat_room_demo/widgets/chat_bubble.dart';
import 'package:chat_room_demo/widgets/chat_text_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:chat_room_demo/src/screens/chat_room_controller.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomCode;
  const ChatRoomScreen({
    required this.roomCode,
    super.key,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> with SingleTickerProviderStateMixin {
  late final ChatRoomController _chatRoomController;
  late final ScrollController _scrollController;
  late final AnimationController _animationController;

  bool joineeExists = false;

  /// TODO: remove hardcoded colors when the image color palette algorithm is fixed.
  final _gradientColors = <Color>[
    Colors.amberAccent,
    Colors.amberAccent,
    Colors.white,
    Colors.lightBlue,
    Colors.lightBlue,
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _chatRoomController = ChatRoomController(roomCode: widget.roomCode)..init();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 6), upperBound: pi);
    _animationController.repeat(reverse: true);

    _animationController.addListener(() {
      setState(() {});
    });

    _chatRoomController.chatStreamController.stream.listen((_) {
      _handleScroll();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance.ref("chat_rooms/${widget.roomCode}").onValue,
        builder: (context, roomStatusSnapshot) {
          /// this is to check if any other person has joined the created room or not
          /// and based on this we will update the UI
          joineeExists = (roomStatusSnapshot.hasData &&
              ((roomStatusSnapshot.requireData.snapshot.value as Map?)?['roomOccupied'] as bool? ?? false));

          return WillPopScope(
            onWillPop: () async => false, // to disable back button
            child: Scaffold(
              bottomNavigationBar: _sendMessageTextField(),
              body: Column(
                children: [
                  // animated app bar widget
                  _AnimatedAppBar(
                    gradientColors: _gradientColors,
                    animationController: _animationController,
                    chatRoomController: _chatRoomController,
                    widget: widget,
                  ),

                  // Chat list view widget
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: StreamBuilder(
                        stream: _chatRoomController.chatStreamController.stream,
                        builder: (context, snapshot) {
                          /// This means -> show the list of convo only if data exists on firebase.
                          if (snapshot.hasData && snapshot.requireData.isNotEmpty) {
                            /// parsing chats from stream snapshot.
                            final List<ChatModel> chats = snapshot.requireData;

                            return chatListView(chats, joineeExists);
                          }

                          /// If no chats exists in firebase then show placeholder widget respectively.
                          return defaultPlaceholderOnChatList(joineeExists);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget? _sendMessageTextField() => !joineeExists
      ? null
      : ChatTextField(onSendCallback: (String text) {
          _chatRoomController.sendMessage(text);
        });

  Center defaultPlaceholderOnChatList(bool joineeExists) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            joineeExists ? AssetConstants.sparkyPizza : AssetConstants.emptyRoom,
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(
            joineeExists ? "No chats yet!\nSay Hi to your friend!" : "No one has\njoined the room!",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Column chatListView(List<ChatModel> chats, bool joineeExists) {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: chats.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ChatBubble(
                bubbleText: chats[index].message,
                deliverTime: _getFormattedTime(chats[index].timestamp),
                isSent: _chatRoomController.senderID == chats[index].senderID,
              ),
            ),
          ),
        ),

        /// If the other left the room while still some messages are in the chat,
        /// we will show a chat encounter message.
        if (!joineeExists) ...{
          Container(margin: const EdgeInsets.symmetric(vertical: 16), child: const Divider()),
          const Flexible(
            child: Text("The other person left the chat room!"),
          ),
        }
      ],
    );
  }

  String _getFormattedTime(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dt.day}/${dt.month}, ${dt.hour}:${dt.second}';
  }

  /// This function is responsible for auto scrolling the message list when a message appears
  /// and goes out the viewport.
  void _handleScroll() {
    if (_scrollController.hasClients && _scrollController.offset <= _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    }
  }
}

class _AnimatedAppBar extends StatelessWidget {
  const _AnimatedAppBar({
    required List<Color> gradientColors,
    required AnimationController animationController,
    required ChatRoomController chatRoomController,
    required this.widget,
  })  : _gradientColors = gradientColors,
        _animationController = animationController,
        _chatRoomController = chatRoomController;

  final List<Color> _gradientColors;
  final AnimationController _animationController;
  final ChatRoomController _chatRoomController;
  final ChatRoomScreen widget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradientColors,
                transform: GradientRotation(_animationController.value),
              ),
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 150,
            sigmaY: 70,
          ),
          child: Container(),
        ),
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 2, bottom: 10),
          child: BackButton(
            color: Colors.black,
            onPressed: () {
              _chatRoomController.leaveRoom();
              Navigator.pop(context);
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 10, bottom: 10),
            child: Text(
              "Room ${widget.roomCode}!",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Positioned(
          right: 10,
          top: 60,
          child: AppColorSwitcher(),
        )
      ],
    );
  }
}
