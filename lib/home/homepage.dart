import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:to_dos/database/firebase_service.dart';
import 'package:to_dos/home/widget/appbar.dart';
import 'package:to_dos/home/widget/drawer_content.dart';
import 'package:to_dos/home/widget/emptylist.dart';
import 'package:to_dos/home/widget/no_internet.dart';
import 'package:to_dos/home/widget/topside.dart';
import '../Provider/provider_service.dart';
import '../database/database_helper.dart';


class FinalView extends StatefulWidget {
  const FinalView({Key? key}) : super(key: key);

  @override
  _FinalViewState createState() => _FinalViewState();
}

class _FinalViewState extends State<FinalView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> allData = [];
  bool isLoading = true;
  List<bool> selectedItems = [];
  bool isCompleted = false;

  /// Refreshing Data After every User action
  Future<void> refreshData() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoInternetScreen()));
    }else{
      final data = await SQLHelper.getItems();//local database function
      final online_data = await _firebaseService.getTasks();

      setState(() {
        allData = online_data;
        isLoading = false;
        selectedItems = List.generate(allData.length, (index) => false); // Initialize selectedItems here
      });
    }
  }

  /// Show Form for adding a new task / update task
  void showForm(String? documentId) async {
    var read = context.read<TodoProvider>();
    if (documentId != null) {
      // id != null -> update an existing item
      final existingJournal =
      allData.firstWhere((element) => element['documentId'] == documentId);
      read.updateTitle(existingJournal['title']);
      read.updateDescription(existingJournal['description']);
      _titleController.text = read.nameOfTitle;
      _descriptionController.text = read.nameOfDescription;

    }
    // id == null -> create new item
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  Text(
                    documentId == null ? 'Add New One!' : 'Update Current',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Tell me about Your Task:)",
                    style: TextStyle(color: Colors.grey, fontSize: 25),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _titleController,
                    onChanged: read.updateTitle,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      prefixIcon: Icon(Icons.title),
                      hintText: 'Enter task headline',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    onChanged: read.updateDescription,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.description),
                      hintText: 'Enter task description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.green.withOpacity(.5)),
                    ),
                    onPressed: () async {
                      if (documentId  == null) {
                        //await addItem();//local database function
                        await addItemOnline();//firebase function
                      }

                      if (documentId != null) {
                        //await updateItem(id);//local database function
                        await updateItemOnline(documentId);//firebase function
                      }

                      _titleController.text = '';
                      _descriptionController.text = '';

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: Text(documentId == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  /// Add Task Function
  Future<void> addItem() async {
    await SQLHelper.createItem(_titleController.text, _descriptionController.text);
    refreshData();
  }
  /// Firebase Add Task Function
  Future<void> addItemOnline() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none){
      refreshData();
    }else{
      var read = context.read<TodoProvider>();
      read.addTask(read.nameOfTitle, read.nameOfDescription);
      //await _firebaseService.addTask(_titleController.text, _descriptionController.text);
      refreshData();
    }
  }

  /// Update Task Function
  Future<void> updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    refreshData();
  }

  /// Firebase Add Task Function
  Future<void> updateItemOnline(String documentId) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none){
      refreshData();
    }else{
      var read = context.read<TodoProvider>();
      read.updateTask(documentId, read.nameOfTitle, read.nameOfDescription);
      //await _firebaseService.updateTask(documentId, _titleController.text, _descriptionController.text);
      refreshData();
    }
  }

  /// Delete
  void deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
      content: MaterialBanner(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.0),
        content: AwesomeSnackbarContent(
          inMaterialBanner: true,
          title: 'Success!',
          message: 'Successfully removed task',
          contentType: ContentType.success,
        ), actions: [
        Container()
      ],
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);

    refreshData();
  }

  /// Firebase Delete task
  void deleteItemOnline(String documentId) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none){
      refreshData();
    }else{
      var read = context.read<TodoProvider>();
      read.deleteTask(documentId);
     // await _firebaseService.deleteTask(documentId);
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: MaterialBanner(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.0),
          content: AwesomeSnackbarContent(
            inMaterialBanner: true,
            title: 'Success!',
            message: 'Successfully removed task',
            contentType: ContentType.success,
          ), actions: [
          Container()
        ],
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      refreshData();
    }
  }

  void deleteSelectedItems() {
    List<String> selectedDocumentIds = [];
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) {
        selectedDocumentIds.add(allData[i]['documentId']);
      }
    }

    for (String documentId in selectedDocumentIds) {
      deleteItemOnline(documentId);
    }

    setState(() {
      selectedItems = List.generate(allData.length, (index) => false);
    });
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerContent(),
      backgroundColor: const Color(0xffFFFDFF),
      appBar: const HomeAppBar(),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.deepPurpleAccent,
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopSideTitles(allData: allData, selectedItems: selectedItems, onDeleteSelected: deleteSelectedItems),
          allData.isEmpty
              ? const Expanded(child: EmptyListState())
              : Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: allData.length,
              itemBuilder: (context, index) => Slidable(
                key: const ValueKey(0),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.3,
                  children: [
                    SlidableAction(
                      flex: 3,
                      onPressed: (_) =>
                          // deleteItem(allData[index]['id']),
                      deleteItemOnline(allData[index]['documentId']),
                      foregroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Remove',
                      autoClose: true,
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 110,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  showForm(allData[index]['documentId']),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                            ),
                            const Text(
                              "Edit",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(15)),
                          color: selectedItems[index]?Colors.green
                              .withOpacity(0.5):Colors.deepPurpleAccent
                            .withOpacity(0.5),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 12, left: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      allData[index]['title'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30),
                                    ),
                                    Text(
                                      allData[index]['description'],
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedItems[index] = !selectedItems[index];
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: selectedItems[index]?Colors.green:Colors.deepPurple),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: selectedItems[index]
                                            ? Icon(
                                          Icons.check,
                                          size: 15.0,
                                          color: Colors.white,
                                        )
                                            : Icon(
                                          Icons.check_box_outline_blank,
                                          size: 15.0,
                                          color: selectedItems[index]?Colors.green:Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      /// Floating Action Button
      floatingActionButton: _buildFAB(),
    );
  }

  /// Floating Action Button
  Widget _buildFAB() {
    return SizedBox(
      width: 220,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: const Color.fromARGB(255, 36, 140, 60),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add a new Task"),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.add),
          ],
        ),
        onPressed: () => showForm(null),
      ),
    );
  }
}