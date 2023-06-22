// ignore_for_file: prefer_const_constructors
import 'package:exam_buddy/views/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: GoogleFonts.interTextTheme()
              .apply(bodyColor: Colors.white, displayColor: Colors.white),
          scaffoldBackgroundColor: Color(0xFF1A1A1A),
          appBarTheme: AppBarTheme(color: Colors.transparent, elevation: 0),
          buttonTheme: ButtonThemeData(
            buttonColor: Color(0xFF2A90FF),
          ),
        ),
        home: LoginPage(),
      ),
    );
  }
}
