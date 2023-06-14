import 'package:exam_buddy/helper/helper_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UpdateTaskAlertDialog extends StatefulWidget {
  final String taskId, taskName, taskDesc;

  const UpdateTaskAlertDialog(
      {Key? Key,
      required this.taskId,
      required this.taskName,
      required this.taskDesc})
      : super(key: Key);

  @override
  State<UpdateTaskAlertDialog> createState() => _UpdateTaskAlertDialogState();
}

class _UpdateTaskAlertDialogState extends State<UpdateTaskAlertDialog> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();

  String email = "";
  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    taskNameController.text = widget.taskName;
    taskDescController.text = widget.taskDesc;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      scrollable: true,
      title: const Text(
        'Update Task',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      content: SizedBox(
        height: height * 0.35,
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
            primary: Colors.red,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          onPressed: () {
            final taskName = taskNameController.text;
            final taskDesc = taskDescController.text;
            _updateTasks(taskName, taskDesc);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Update'),
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

  Future _updateTasks(String taskName, String taskDesc) async {
    var collection = FirebaseFirestore.instance.collection('AllTasks');
    collection
        .doc(email)
        .collection('tasks')
        .doc(widget.taskId)
        .update({'taskName': taskName, 'taskDesc': taskDesc})
        .then((_) => Get.snackbar("Success", "Task updated",
            backgroundColor: Colors.green))
        .catchError((error) => Get.snackbar("Error", error.toString(),
            backgroundColor: Colors.red));
  }
}
