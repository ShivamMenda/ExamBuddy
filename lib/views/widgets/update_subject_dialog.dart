import 'package:exam_buddy/helper/helper_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UpdateSubjectAlertDialog extends StatefulWidget {
  final String SubjectId, SubjectName, SubjectDesc, SubjectTeacher, SubjectCode;

  const UpdateSubjectAlertDialog({
    Key? Key,
    required this.SubjectId,
    required this.SubjectCode,
    required this.SubjectName,
    required this.SubjectDesc,
    required this.SubjectTeacher,
  }) : super(key: Key);

  @override
  State<UpdateSubjectAlertDialog> createState() =>
      _UpdateSubjectAlertDialogState();
}

class _UpdateSubjectAlertDialogState extends State<UpdateSubjectAlertDialog> {
  final TextEditingController SubjectNameController = TextEditingController();
  final TextEditingController SubjectDescController = TextEditingController();
  final TextEditingController SubjectCodeController = TextEditingController();
  final TextEditingController SubjectTeacherController =
      TextEditingController();

  String email = "";
  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SubjectNameController.text = widget.SubjectName;
    SubjectDescController.text = widget.SubjectDesc;
    SubjectCodeController.text = widget.SubjectCode;
    SubjectTeacherController.text = widget.SubjectTeacher;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height + 200;
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      scrollable: true,
      title: const Text(
        'Update Subject',
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
                  controller: SubjectNameController,
                  style: const TextStyle(fontSize: 14),
                  decoration: textInputDecoration(
                      context, "Subject Name", CupertinoIcons.square_list)),
              const SizedBox(height: 15),
              TextFormField(
                  controller: SubjectDescController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(fontSize: 14),
                  decoration: textInputDecoration(context, "Description",
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
          onPressed: () {
            final SubjectName = SubjectNameController.text;
            final SubjectDesc = SubjectDescController.text;
            final SubjectCode = SubjectCodeController.text;
            final SubjectTeacher = SubjectTeacherController.text;
            _updateSubjects(
                SubjectName, SubjectDesc, SubjectCode, SubjectTeacher);
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

  Future _updateSubjects(String SubjectName, String SubjectDesc,
      String SubjectCode, String SubjectTeacher) async {
    var collection = FirebaseFirestore.instance.collection('AllSubjects');
    collection
        .doc(email)
        .collection('subs')
        .doc(widget.SubjectId)
        .update({
          'SubjectName': SubjectName,
          'SubjectDesc': SubjectDesc,
          'SubjectCode': SubjectCode,
          'SubjectTeacher': SubjectTeacher
        })
        .then((_) => Get.snackbar("Success", "Subject updated",
            backgroundColor: Colors.green))
        .catchError((error) => Get.snackbar("Error", error.toString(),
            backgroundColor: Colors.red));
  }
}
