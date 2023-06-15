import 'package:exam_buddy/helper/helper_function.dart';
import 'package:exam_buddy/services/auth_service.dart';
import 'package:exam_buddy/views/screens/auth/login_screen.dart';
import 'package:exam_buddy/views/screens/group_chat/group_chat_screen.dart';
import 'package:exam_buddy/views/screens/home_screen.dart';

import 'package:exam_buddy/views/screens/profile_screen.dart';
import 'package:exam_buddy/views/screens/subject_screen.dart';
import 'package:exam_buddy/views/screens/todo_screen.dart';
import 'package:exam_buddy/views/screens/video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideBar extends StatefulWidget {
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String email = "";
  String name = "";
  AuthService authService = AuthService();
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        name = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  "assets/user.jpg",
                  fit: BoxFit.cover,
                  height: 90,
                  width: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/profile-bg3.jpg")),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text('Home'),
            onTap: () => Get.to(() => HomeScreen()),
          ),
          ListTile(
            leading: Icon(
              Icons.book,
              color: Colors.white,
            ),
            title: Text('Resources'),
            onTap: () => Get.to(() => ResourceScreen()),
          ),
          ListTile(
            leading: Icon(
              Icons.list,
              color: Colors.white,
            ),
            title: Text('To-do List'),
            onTap: () => Get.to(() => ToDoScreen()),
          ),
          ListTile(
            leading: Icon(
              Icons.group,
              color: Colors.white,
            ),
            title: Text('Groups'),
            onTap: () => Get.to(() => GroupChatHomePage()),
          ),
          ListTile(
            leading: Icon(
              Icons.video_call,
              color: Colors.white,
            ),
            title: Text('Call'),
            onTap: () => Get.to(() => VideoCallScreen()),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: Text('Profile'),
            onTap: () => Get.to(() => ProfileScreen()),
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onTap: () {
              authService.signOut();
              Get.to(() => LoginPage());
            },
          ),
        ],
      ),
    );
  }
}
