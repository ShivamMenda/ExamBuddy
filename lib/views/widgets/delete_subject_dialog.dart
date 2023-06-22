import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_buddy/helper/helper_function.dart';
import 'package:exam_buddy/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteSubjectDialog extends StatefulWidget {
  final String SubjectId, SubjectName;

  const DeleteSubjectDialog(
      {Key? key, required this.SubjectId, required this.SubjectName})
      : super(key: key);

  @override
  State<DeleteSubjectDialog> createState() => _DeleteSubjectDialogState();
}

class _DeleteSubjectDialogState extends State<DeleteSubjectDialog> {
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
        'Delete Subject',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      content: SizedBox(
        child: Form(
          child: Column(
            children: <Widget>[
              const Text(
                'Are you sure you want to delete this subject?',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                widget.SubjectName.toString(),
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
            // Navigator.of(context, rootNavigator: true).pop();
            Get.to(() => HomeScreen());
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _deleteSubjects();
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

  Future _deleteSubjects() async {
    var collection = FirebaseFirestore.instance.collection('AllSubjects');
    collection
        .doc(email)
        .collection("subs")
        .doc(widget.SubjectId)
        .delete()
        .then(
          (_) => Get.snackbar(
            "Success",
            "Subject Deleted Successfully",
            backgroundColor: Colors.green,
          ),
        )
        .catchError(
          (error) =>
              Get.snackbar("Failed", "$error", backgroundColor: Colors.red),
        );
  }
}
