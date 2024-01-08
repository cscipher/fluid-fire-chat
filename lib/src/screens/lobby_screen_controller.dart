import 'package:chat_room_demo/services/firebase_service.dart';
import 'package:chat_room_demo/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';

class LobbyScreenController {
  Future<bool> joinExistingRoom(final String roomCode) async {
    final path = 'chat_rooms/$roomCode';
    final firebaseRoomStatus = (await FirebaseService.getDbSnapshot(path)) as Map?;

    final isRoomOccupied = (firebaseRoomStatus?["roomOccupied"] as bool?) ?? false;
    final roomAvailability = (firebaseRoomStatus?["roomAvailable"] as bool?) ?? false;

    if (firebaseRoomStatus != null && !isRoomOccupied && roomAvailability) {
      await FirebaseService.updateToPath(path, updatedData: {"roomOccupied": true});
      return true;
    }
    return false;
  }

  Future<Map<String, String>> createNewRoom() async {
    final String roomCode = AppUtils.generateRoomCode();
    final String creatorID = await AppUtils.getId();

    await FirebaseService.setToPath("chat_rooms/$roomCode", data: {
      "creatorID": creatorID,
      "roomOccupied": false,
      "roomAvailable": true,
    });
    return {
      "roomCode": roomCode,
      "creatorID": creatorID,
    };
  }
}
