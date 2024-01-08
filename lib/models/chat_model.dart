class ChatModel {
  final String message;
  final int timestamp;
  final String senderID;

  const ChatModel({
    required this.message,
    required this.timestamp,
    required this.senderID,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'timestamp': timestamp,
      'senderID': senderID,
    };
  }

  factory ChatModel.fromMap(Map map) {
    return ChatModel(
      message: map['message'] as String,
      timestamp: map['timestamp'] as int,
      senderID: map['senderID'] as String,
    );
  }
}
