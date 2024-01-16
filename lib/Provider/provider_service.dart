
import 'package:flutter/material.dart';

import '../database/firebase_service.dart';

class TodoProvider with ChangeNotifier{

  final FirebaseService firestore = FirebaseService();

  //add task
  String title ='';
  String description ='';

  String get nameOfTitle => title;

  void updateTitle(String value) {
    title = value;
    notifyListeners();
  }

  String get nameOfDescription => description;

  void updateDescription(String value) {
    description = value;
    notifyListeners();
  }

  //Add task
  addTask(String title, String description){
    firestore.addTask(title, description);
    notifyListeners();
  }

  //Update task
  updateTask(String id, String title, String description){
    firestore.updateTask(id, title, description);
    notifyListeners();
  }

  //Delete task
  deleteTask(String id){
    firestore.deleteTask(id);
    notifyListeners();
  }
}