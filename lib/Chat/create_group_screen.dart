import 'package:flutter/material.dart';
import 'package:to_dos/Chat/services/firebase_service.dart';

import 'model/user.dart';
class CreateGroupScreen extends StatefulWidget {
  final List<User> userList;
  final String token;

  CreateGroupScreen({required this.userList, required this.token});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  List<String> _selectedMembers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Group'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _createGroup();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _groupNameController,
            decoration: InputDecoration(labelText: 'Group Name'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.userList.length,
              itemBuilder: (context, index) {
                final user = widget.userList[index];
                return CheckboxListTile(
                  title: Text(user.name),
                  value: _selectedMembers.contains(user.email),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        _selectedMembers.add(user.email);
                      } else {
                        _selectedMembers.remove(user.email);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createGroup() async {
    final String groupName = _groupNameController.text.trim();
    if (groupName.isNotEmpty && _selectedMembers.isNotEmpty) {
      // Implement creating group in Firestore
      // Example:
      final List<String> memberEmails = _selectedMembers.toList();
      await FirestoreService.createGroup(groupName, memberEmails);
      Navigator.pop(context);
    }
  }
}
