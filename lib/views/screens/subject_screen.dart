// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:exam_buddy/views/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ResourceScreen extends StatelessWidget {
  const ResourceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text(
          "Resources",
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
      body: Column(
        children: [],
      ),
    );
  }
}
