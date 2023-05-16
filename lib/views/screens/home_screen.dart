// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:exam_buddy/views/widgets/common_appBar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(
            title: "Home",
            iconData: Icons.menu,
            onPress: () {},
          ),
        ],
      ),
    );
  }
}
