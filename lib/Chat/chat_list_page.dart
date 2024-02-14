import 'package:flutter/material.dart';

import 'create_group_screen.dart';
import 'group_chat_screen.dart';
import 'model/combine_user_model.dart';
import 'model/group_model.dart';
import 'model/user.dart';
import 'oneToOneChat_screen.dart';
class ChatListPage extends StatefulWidget {
  final String token;

  ChatListPage({required this.token});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<User> _userList = [
  User(name: 'shakil', email: 'shakil@gmail.com'),
  User(name: 'akash', email: 'akash@gmail.com'),
  User(name: 'palash', email: 'palash@gmail.com'),
  User(name: 'sadnan', email: 'sadnan@gmail.com'),
  User(name: 'billah', email: 'billah@gmail.com'),
  User(name: 'asif', email: 'asif@gmail.com'),
  ];

  List<Group> _groups = [
    Group(id: '1', name: 'Group 1', memberEmails: ['shakil@gmail.com', 'akash@gmail.com']),
    Group(id: '2', name: 'Group 2', memberEmails: ['palash@gmail.com', 'shakil@gmail.com']),
  ];

  List<ChatItem> totalChatList = [];



  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  Future<void> _fetchUserList() async {
    // Add users to the chat list
    totalChatList.addAll(_userList.map((user) => ChatItem(id: user.email, name: user.name, memberEmails: [user.email])));

// Add groups to the chat list
    totalChatList.addAll(_groups.map((group) => ChatItem(id: group.id, name: group.name, memberEmails: group.memberEmails)));

// You can sort the chat list if needed
    totalChatList.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List'),
        actions: [
          IconButton(
            icon: Icon(Icons.group_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateGroupScreen(userList: _userList, token: widget.token),
                ),
              );
            },
          ),
        ],
      ),
      body: totalChatList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: totalChatList.length,
        itemBuilder: (context, index) {
          final user = totalChatList[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text('your quote'),
            onTap: () {
              // Navigate to chat screen with selected user
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    if (user.memberEmails.length > 1) {
                      // Navigate to group chat screen
                      return GroupChatScreen(groupId: user.id, groupName: user.name, token: widget.token);
                    } else {
                      // Navigate to normal chat screen
                      return ChatScreen(currentUser: User(name: user.name, email: user.id), token: widget.token);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
