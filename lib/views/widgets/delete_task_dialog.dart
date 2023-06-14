import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_buddy/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteTaskDialog extends StatefulWidget {
  final String taskId, taskName;

  const DeleteTaskDialog(
      {Key? key, required this.taskId, required this.taskName})
      : super(key: key);

  @override
  State<DeleteTaskDialog> createState() => _DeleteTaskDialogState();
}

class _DeleteTaskDialogState extends State<DeleteTaskDialog> {
  String email = "";
  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      scrollable: true,
      title: const Text(
        'Delete Task',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      content: SizedBox(
        child: Form(
          child: Column(
            children: <Widget>[
              const Text(
                'Are you sure you want to delete this task?',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                widget.taskName.toString(),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
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
            primary: Colors.blue,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _deleteTasks();
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  getEmail() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  Future _deleteTasks() async {
    var collection = FirebaseFirestore.instance.collection('AllTasks');
    collection
        .doc(email).collection("tasks").doc(widget.taskId).delete()
        .then((_) => Get.snackbar("Success", "Task Deleted Successfully",backgroundColor: Colors.green,),)
        .catchError((error) => Get.snackbar("Failed", "$error",backgroundColor: Colors.red),);
  }
}
