// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:exam_buddy/services/api.dart';
import 'package:exam_buddy/views/screens/video_call/join_screen.dart';
import 'package:exam_buddy/views/screens/video_call/meeting_screen.dart';
import 'package:exam_buddy/views/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  String meetingId = "";
  bool isMeetingActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Call",
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isMeetingActive
              ? MeetingScreen(
                  meetingId: meetingId,
                  token: token,
                  leaveMeeting: () {
                    setState(() => isMeetingActive = false);
                  },
                )
              : JoinScreen(
                  onMeetingIdChanged: (value) => meetingId = value,
                  onCreateMeetingButtonPressed: () async {
                    meetingId = await createMeeting();
                    setState(() => isMeetingActive = true);
                  },
                  onJoinMeetingButtonPressed: () {
                    setState(() => isMeetingActive = true);
                  },
                ),
        ),
      ),
    );
  }
}
