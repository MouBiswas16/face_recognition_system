// ignore_for_file: prefer_const_constructors

import 'package:face_recognition_system/screens/recognition_screen.dart';
import 'package:face_recognition_system/screens/registration_screen.dart';
import 'package:face_recognition_system/strings/colors.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 70,
        ),
        child: Center(
          child: Column(
            children: [
                SizedBox(height: 30),
              Image.asset(
                width: MediaQuery.of(context).size.width * 0.85,
                "assets/images/logo.jpg",
              ),
              Spacer(),
              Column(
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
                      foregroundColor: btnTextColor,
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.85, 40),
                      elevation: 10,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                    ),
                    child: Text(
                      "Register",
                      // style: GoogleFonts.aboreto(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecognitionScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      foregroundColor: btnTextColor,
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.85, 40),
                      elevation: 10,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                    ),
                    child: Text(
                      "Recognition",
                      // style: GoogleFonts.aboreto(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
