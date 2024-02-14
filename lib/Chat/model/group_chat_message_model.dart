class GroupChatMessage {
  final String sender;
  final String message;
  final DateTime timestamp;

  GroupChatMessage({required this.sender, required this.message, required this.timestamp});

  factory GroupChatMessage.fromJson(Map<String, dynamic> json) {
    return GroupChatMessage(
      sender: json['sender'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
