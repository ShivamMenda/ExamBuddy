// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_buddy/helper/helper_function.dart';
import 'package:exam_buddy/views/widgets/add_subject_dialog%20.dart';
import 'package:exam_buddy/views/widgets/delete_subject_dialog.dart';
import 'package:exam_buddy/views/widgets/sidebar.dart';
import 'package:exam_buddy/views/widgets/update_subject_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  String email = "";
  @override
  void initState() {
    getName();
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 20,
                  foregroundImage: AssetImage("assets/user.jpg"),
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
            ],
          ),
        ],
      ),
      drawer: SideBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 3.h,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 21.0, vertical: 10.0),
              child: Text(
                "${greeting()},",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25.sp),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('AllTasks')
                    .doc(email)
                    .collection('tasks')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 5.0),
                      child: Text(
                        "You have 0 Task(s) remaining for the day",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17.sp),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 5.0),
                      child: Text(
                        "You have ${snapshot.data?.docs.length} Task(s) remaining for the day",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17.sp),
                      ),
                    );
                  }
                }),
            SizedBox(
              height: 3.5.h,
            ),
            Center(
              child: Text(
                "Subjects",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
              ),
            ),
            SizedBox(
              height: 2.5.h,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("AllSubjects")
                  .doc(email)
                  .collection("subs")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: InkWell(
                          onLongPress: () {
                            Future.delayed(
                              const Duration(seconds: 0),
                              () => showDialog(
                                context: context,
                                builder: (context) => DeleteSubjectDialog(
                                    SubjectId: snapshot.data!.docs[index]['id'],
                                    SubjectName: snapshot.data!.docs[index]
                                        ['SubjectName']),
                              ),
                            );
                          },
                          onTap: () {
                            Future.delayed(
                              const Duration(seconds: 0),
                              () => showDialog(
                                context: context,
                                builder: (context) => UpdateSubjectAlertDialog(
                                  SubjectCode: snapshot.data!.docs[index]
                                      ['SubjectCode'],
                                  SubjectDesc: snapshot.data!.docs[index]
                                      ['SubjectDesc'],
                                  SubjectName: snapshot.data!.docs[index]
                                      ['SubjectName'],
                                  SubjectTeacher: snapshot.data!.docs[index]
                                      ['SubjectTeacher'],
                                  SubjectId: snapshot.data!.docs[index]['id'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                            ),
                            child: Column(children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Icon(
                                Icons.book,
                                size: 50,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(
                                snapshot.data!.docs[index]['SubjectName'],
                                style: TextStyle(fontSize: 22),
                              ),
                              Text(
                                snapshot.data!.docs[index]['SubjectCode'],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                snapshot.data!.docs[index]['SubjectTeacher'],
                                style: TextStyle(fontSize: 14),
                              ),
                            ]),
                          ),
                        ),
                      );
                    },
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No subjects added",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "No subjects added",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return AddSubjectAlertDialog();
              }));
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  getName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        name = value!;
      });
    });
  }

  getEmail() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
  }
}

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12 && hour > 5) {
    return 'Good Morning';
  }
  if (hour < 17) {
    return 'Good Afternoon';
  }

  return 'Good Evening';
}
