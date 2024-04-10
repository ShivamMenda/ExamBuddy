import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_buddy/helper/helper_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSubjectAlertDialog extends StatefulWidget {
  AddSubjectAlertDialog({Key? key}) : super(key: key);

  @override
  State<AddSubjectAlertDialog> createState() => _AddSubjectAlertDialogState();
}

class _AddSubjectAlertDialogState extends State<AddSubjectAlertDialog> {
  final TextEditingController SubjectNameController = TextEditingController();
  final TextEditingController SubjectDescController = TextEditingController();
  final TextEditingController SubjectCodeController = TextEditingController();
  final TextEditingController SubjectTeacherController =
      TextEditingController();
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
    var height = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      scrollable: true,
      title: const Text(
        'New Subject',
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
                  controller: SubjectNameController,
                  style: const TextStyle(fontSize: 14),
                  decoration: textInputDecoration(
                      context, "Subject Name", CupertinoIcons.book_circle)),
              const SizedBox(height: 15),
              TextFormField(
                  controller: SubjectDescController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(fontSize: 14),
                  decoration: textInputDecoration(
                      context,
                      "Subject Description",
                      CupertinoIcons.bubble_left_bubble_right)),
              const SizedBox(height: 15),
              TextFormField(
                  controller: SubjectCodeController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(fontSize: 14),
                  decoration: textInputDecoration(
                      context, "Subject Code", CupertinoIcons.info)),
              const SizedBox(height: 15),
              TextFormField(
                  controller: SubjectTeacherController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(fontSize: 14),
                  decoration: textInputDecoration(
                      context, "Subject Teacher", CupertinoIcons.person)),
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
            backgroundColor: Colors.red,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          onPressed: () async {
            final SubjectName = SubjectNameController.text;
            final SubjectDesc = SubjectDescController.text;
            final SubjectCode = SubjectCodeController.text;
            final SubjectTeacher = SubjectTeacherController.text;
            await _addSubjects(
                SubjectName: SubjectName,
                SubjectDesc: SubjectDesc,
                SubjectCode: SubjectCode,
                SubjectTeacher: SubjectTeacher);
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

  Future _addSubjects(
      {required String SubjectName,
      required String SubjectDesc,
      required String SubjectCode,
      required String SubjectTeacher}) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('AllSubjects')
        .doc(email)
        .collection("subs")
        .add(
      {
        'SubjectName': SubjectName,
        'SubjectDesc': SubjectDesc,
        'SubjectCode': SubjectCode,
        'SubjectTeacher': SubjectTeacher
      },
    ).then((value) {
      Get.snackbar("Success", "Subject added", backgroundColor: Colors.green);
      return value;
    }).catchError((error) {
      Get.snackbar("Error", error.toString(), backgroundColor: Colors.red);
      return error;
    });

    String SubjectId = docRef.id;
    await FirebaseFirestore.instance
        .collection('AllSubjects')
        .doc(email)
        .collection("subs")
        .doc(docRef.id)
        .update(
      {'id': SubjectId},
    );
    _clearAll();
  }

  void _clearAll() {
    SubjectNameController.text = '';
    SubjectDescController.text = '';
    SubjectTeacherController.text = '';
    SubjectCodeController.text = '';
  }
}
