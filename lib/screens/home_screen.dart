// ignore_for_file: prefer_const_constructors

import 'package:face_recognition_system/screens/live_face_detection.dart';
import 'package:face_recognition_system/screens/recognition_screen.dart';
import 'package:face_recognition_system/screens/registration_screen.dart';
import 'package:face_recognition_system/strings/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.only(top: 100),
                child: Image.asset(
                  "assets/images/logo.jpg",
                  width: screenWidth - 40,
                  height: screenWidth - 40,
                )),
            Container(
              margin: EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        minimumSize: Size(screenWidth - 30, 50)),
                    child: Text(
                      "Register",
                      style: TextStyle(color: btnTextColor),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveFaceDetection(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: btnColor,
                        minimumSize: Size(screenWidth - 30, 50)),
                    child: Text(
                      "Recognize",
                      style: TextStyle(
                        color: btnTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
