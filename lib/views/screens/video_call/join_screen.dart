import 'package:flutter/material.dart';

class JoinScreen extends StatelessWidget {
  final void Function() onCreateMeetingButtonPressed;
  final void Function() onJoinMeetingButtonPressed;
  final void Function(String) onMeetingIdChanged;

  const JoinScreen({
    Key? key,
    required this.onCreateMeetingButtonPressed,
    required this.onJoinMeetingButtonPressed,
    required this.onMeetingIdChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme(
          data: new ThemeData(
            primaryColor: Colors.white,
            primaryColorDark: Colors.white,
          ),
          child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Meeting ID",
                hintStyle: TextStyle(color: Colors.white),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(width: 1, color: Colors.orange),
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
              ),
              onChanged: onMeetingIdChanged),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                child: const Text("Create Meeting"),
                onPressed: onCreateMeetingButtonPressed),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              child: const Text("Join Meeting"),
              onPressed: onJoinMeetingButtonPressed,
            )
          ],
        ),
      ],
    );
  }
}
