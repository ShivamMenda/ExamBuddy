// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_buddy/helper/helper_function.dart';
import 'package:exam_buddy/views/widgets/add_task_dialog.dart';
import 'package:exam_buddy/views/widgets/delete_task_dialog.dart';
import 'package:exam_buddy/views/widgets/sidebar.dart';
import 'package:exam_buddy/views/widgets/update_task_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "To-Do-List",
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
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return AddTaskAlertDialog();
              }));
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Tasks(),
    );
  }
}

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final firestore = FirebaseFirestore.instance;
  String email = "";
  @override
  void initState() {
    getEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('AllTasks')
            .doc(email)
            .collection("tasks")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              "no data",
              style: TextStyle(backgroundColor: Colors.white),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Container(
                  height: 100,
                  margin: EdgeInsets.fromLTRB(0, 5.0, 0, 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        offset: Offset(0, 5), // shadow direction: bottom right
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      data['taskName'],
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    subtitle: Text(
                      data['taskDesc'],
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton(
                      color: Colors.white,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.black),
                            ),
                            onTap: () {
                              String taskId = (data['id']);
                              String taskName = (data['taskName']);
                              String taskDesc = (data['taskDesc']);
                              Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                  context: context,
                                  builder: (context) => UpdateTaskAlertDialog(
                                      taskId: taskId,
                                      taskName: taskName,
                                      taskDesc: taskDesc),
                                ),
                              );
                            },
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.black),
                            ),
                            onTap: () {
                              String taskId = (data['id']);
                              String taskName = (data['taskName']);
                              Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                  context: context,
                                  builder: (context) => DeleteTaskDialog(
                                      taskId: taskId, taskName: taskName),
                                ),
                              );
                            },
                          ),
                        ];
                      },
                    ),
                    dense: true,
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  getEmail() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  noTaskWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not added any tasks, tap on the add icon to get started",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
