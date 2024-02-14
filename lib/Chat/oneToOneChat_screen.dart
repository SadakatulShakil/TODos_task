import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_dos/Chat/model/user.dart';
import 'package:to_dos/Chat/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/chat_message_model.dart';
class ChatScreen extends StatefulWidget {
  final User currentUser;
  final String token;

  ChatScreen({required this.currentUser, required this.token});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = [];
  StreamSubscription<QuerySnapshot>? messageStream;

  void listenToMessages() {
    messageStream = FirebaseFirestore.instance.collection('messages').snapshots().listen((snapshot) {
      final List<ChatMessage> updatedMessages = [];
      snapshot.docs.forEach((doc) {
        final message = ChatMessage(
          sender: doc['sender'],
          message: doc['message'],
          timestamp: doc['timestamp'].toDate(),
        );
        updatedMessages.add(message);
      });
      setState(() {
        _messages = updatedMessages;
      });
    });
  }
  @override
  void initState() {
    super.initState();
    listenToMessages();
  }

  Future<void> _fetchMessages() async {
    //Implement fetching messages from Firestore
    // Example:
    final messages = await FirestoreService.fetchMessages(widget.currentUser.email);
    setState(() {
      _messages = messages;
    });
  }

  Future<void> _sendMessage(String message) async {
    // Implement sending message to Firestore
    // Example:
    final currentUserEmail = widget.currentUser.email;
    await FirestoreService.sendMessage(currentUserEmail, message);
    _messageController.clear();
  }

  @override
  void dispose() {
    messageStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentUser.name),
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
