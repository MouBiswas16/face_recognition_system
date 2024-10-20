import 'package:camera/camera.dart';
import 'package:face_recognition_system/screens/live_face_detection.dart';
import 'package:face_recognition_system/screens/splash_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomeScreen(),
      home: SplashScreen(),
    ),
  );
}
