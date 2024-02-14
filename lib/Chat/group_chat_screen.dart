import 'package:flutter/material.dart';
import 'package:to_dos/Chat/services/firebase_service.dart';

import 'model/group_chat_message_model.dart';
class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String token;

  GroupChatScreen({required this.groupId, required this.groupName, required this.token});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<GroupChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    // Implement fetching group chat messages from Firestore
    // Example:
    final messages = await FirestoreService.fetchGroupMessages(widget.groupId);
    setState(() {
      _messages = messages;
    });
  }

  Future<void> _sendMessage(String message) async {
    // Implement sending message to group chat in Firestore
    // Example:
    await FirestoreService.sendGroupMessage(widget.groupId, widget.token, message);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.sender),
                  subtitle: Text(message.message),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter your message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
