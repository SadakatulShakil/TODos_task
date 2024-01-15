import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //add tasks to database
  Future<void> addTask(String title, String description)async{
    await _firestore.collection('tasks').add({
      'title': title,
      'description': description
    });
  }

  //get all tasks from database
  Future<List<Map<String, dynamic>>> getTasks()async{
    QuerySnapshot querySnapshot = await _firestore.collection('tasks').get();
    return querySnapshot.docs.map((doc){
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['documentId'] = doc.id;
      return data;
    }).toList();
  }

  //update task from database
  Future<void> updateTask(String id, String title, String description)async{
    await _firestore.collection('tasks').doc(id).update({
      'title': title,
      'description': description
    });
  }

  //delete task from database
  Future<void> deleteTask(String id)async{
    await _firestore.collection('tasks').doc(id).delete();
  }
}