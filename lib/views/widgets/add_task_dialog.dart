import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_buddy/helper/helper_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTaskAlertDialog extends StatefulWidget {
  AddTaskAlertDialog({Key? key}) : super(key: key);

  @override
  State<AddTaskAlertDialog> createState() => _AddTaskAlertDialogState();
}

class _AddTaskAlertDialogState extends State<AddTaskAlertDialog> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();
  String email = "";
  bool isSuccess = false;
  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      scrollable: true,
      title: const Text(
        'New Task',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      content: SizedBox(
        height: height * 0.45,
        width: width,
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                  controller: taskNameController,
                  style: const TextStyle(fontSize: 14),
                  decoration: textInputDecoration(
                      context, "Task", CupertinoIcons.square_list)),
              const SizedBox(height: 15),
              TextFormField(
                  controller: taskDescController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(fontSize: 14),
                  decoration: textInputDecoration(context, "Description",
                      CupertinoIcons.bubble_left_bubble_right)),
              const SizedBox(height: 7),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          onPressed: () async {
            final taskName = taskNameController.text;
            final taskDesc = taskDescController.text;
            await _addTasks(taskName: taskName, taskDesc: taskDesc);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  InputDecoration textInputDecoration(
      BuildContext context, String? label, IconData? icon) {
    return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Colors.white),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(
              width: 1,
            )),
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ));
  }

  getEmail() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  Future _addTasks({required String taskName, required String taskDesc}) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('AllTasks')
        .doc(email)
        .collection("tasks")
        .add(
      {
        'taskName': taskName,
        'taskDesc': taskDesc,
      },
    ).then((value) {
      Get.snackbar("Success", "Task added", backgroundColor: Colors.green);
      Get.back();
      return value;
    }).catchError((error) {
      Get.snackbar("Error", error.toString(), backgroundColor: Colors.red);
    });

    String taskId = docRef.id;
    await FirebaseFirestore.instance
        .collection('AllTasks')
        .doc(email)
        .collection("tasks")
        .doc(docRef.id)
        .update(
      {'id': taskId},
    );
    _clearAll();
  }

  void _clearAll() {
    taskNameController.text = '';
    taskDescController.text = '';
  }
}
