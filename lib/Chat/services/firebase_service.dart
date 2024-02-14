import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_dos/Chat/model/chat_message_model.dart';

import '../model/group_chat_message_model.dart';
class FirestoreService {
  static Future<void> sendMessage(String currentUserEmail, String message) async {
    try {
      // Get a reference to the Firestore collection where you want to store messages
      final CollectionReference messagesCollection = FirebaseFirestore.instance.collection('messages');

      // Create a new document to store the message
      await messagesCollection.add({
        'sender': currentUserEmail,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp for the message
      });
    } catch (e) {
      print('Error sending message: $e');
      throw e; // Optionally, you can rethrow the error to handle it in the calling code
    }
  }

  static Future<List<ChatMessage>> fetchMessages(String userEmail) async {
    try {
      // Get a reference to the Firestore collection where messages are stored
      final CollectionReference messagesCollection = FirebaseFirestore.instance.collection('messages');

      // Query the messages collection for messages sent by the current user
      final QuerySnapshot querySnapshot = await messagesCollection.where('sender', isEqualTo: userEmail).get();

      // Convert documents to Message objects
      final List<ChatMessage> messages = querySnapshot.docs.map((doc) {
        return ChatMessage(
          sender: doc['sender'],
          message: doc['message'],
          timestamp: doc['timestamp'].toDate(),
        );
      }).toList();

      return messages;
    } catch (e) {
      print('Error fetching messages: $e');
      throw e; // Optionally, you can rethrow the error to handle it in the calling code
    }
  }

  static Future<List<GroupChatMessage>> fetchGroupMessages(String groupId) async {
    try {
      // Get a reference to the Firestore collection where group messages are stored
      final CollectionReference groupMessagesCollection = FirebaseFirestore.instance.collection('groups').doc(groupId).collection('messages');

      // Query the messages collection and get the documents
      final QuerySnapshot querySnapshot = await groupMessagesCollection.orderBy('timestamp', descending: true).get();

      // Convert documents to GroupChatMessage objects
      final List<GroupChatMessage> messages = querySnapshot.docs.map((doc) {
        return GroupChatMessage(
          sender: doc['sender'],
          message: doc['message'],
          timestamp: doc['timestamp'].toDate(), // Convert Firestore Timestamp to DateTime
        );
      }).toList();

      return messages;
    } catch (e) {
      print('Error fetching group messages: $e');
      throw e; // Optionally, you can rethrow the error to handle it in the calling code
    }
  }

  static Future<void> sendGroupMessage(String groupId, String senderEmail, String message) async {
    try {
      // Get a reference to the Firestore collection where group messages are stored
      final CollectionReference groupMessagesCollection = FirebaseFirestore.instance.collection('groups').doc(groupId).collection('messages');

      // Create a new document to store the message
      await groupMessagesCollection.add({
        'sender': senderEmail,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp for the message
      });
    } catch (e) {
      print('Error sending group message: $e');
      throw e; // Optionally, you can rethrow the error to handle it in the calling code
    }
  }

  static Future<void> createGroup(String groupName, List<String> memberEmails) async {
    try {
      // Get a reference to the Firestore collection where groups are stored
      final CollectionReference groupsCollection = FirebaseFirestore.instance.collection('groups');

      // Create a new document to store the group
      final DocumentReference newGroupRef = await groupsCollection.add({
        'name': groupName,
        'members': memberEmails,
      });

      // Optionally, you can update group members with the group ID for easier retrieval
      // This is an example of how you might update the group document with its ID
      await newGroupRef.update({'groupId': newGroupRef.id});
    } catch (e) {
      print('Error creating group: $e');
      throw e; // Optionally, you can rethrow the error to handle it in the calling code
    }
  }
}
