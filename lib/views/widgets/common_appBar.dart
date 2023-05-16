import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final IconData? iconData;
  final VoidCallback onPress;
  CommonAppBar({
    super.key,
    required this.title,
    required this.iconData,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(iconData),
        onPressed: onPress,
      ),
      title: Text(
        title,
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
    );
  }
}
