import 'dart:async';

import 'package:chat_room_demo/models/chat_model.dart';
import 'package:chat_room_demo/services/firebase_service.dart';
import 'package:chat_room_demo/utils/utils.dart';

class ChatRoomController {
  final String roomCode;
  ChatRoomController({
    required this.roomCode,
  });

  String? senderID;
  late final String _dbRef;
  late final StreamController<List<ChatModel>> chatStreamController = StreamController.broadcast();

  Future<void> init() async {
    _dbRef = 'chat_rooms/$roomCode';
    senderID = await AppUtils.getId();

    _listenForMessages();
  }

  Future<void> sendMessage(String text) async {
    final timestamp = DateTime.now();
    final messageToSend = ChatModel(
      message: text,
      timestamp: timestamp.millisecondsSinceEpoch,
      senderID: senderID!,
    ).toMap();

    await FirebaseService.updateToPath(
      _dbRef,
      updatedData: {(timestamp.millisecondsSinceEpoch.toString()): messageToSend},
      childPath: "chats",
    );
  }

  Future<void> leaveRoom() async {
    final isOccupied = ((await FirebaseService.getDbSnapshot(_dbRef)) as Map?)?["roomOccupied"] as bool? ?? false;
    if (!isOccupied) {
      await Future.delayed(const Duration(milliseconds: 300));
      await FirebaseService.removeFromDB(_dbRef);
    } else {
      await FirebaseService.updateToPath(_dbRef, updatedData: {"roomOccupied": false, "roomAvailable": false});
    }
  }

  void _listenForMessages() {
    FirebaseService.getRef(_dbRef).onValue.listen(
      (event) async {
        if (event.snapshot.value != null) {
          final firebaseMap = (event.snapshot.value as Map);

          final chats = (firebaseMap['chats'] as Map?)?.values.map((e) => ChatModel.fromMap(e)).toList();
          chats?.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          chatStreamController.sink.add(chats ?? []);
        }
      },
    );
  }
}
