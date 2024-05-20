// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerClass extends StatefulWidget {
  const ImagePickerClass({super.key});

  @override
  State<ImagePickerClass> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickerClass> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  chooseImages() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        _image = File(image.path);
      });
    }
  }

  captureImages() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if(image != null){
        setState(() {
          _image = File(image.path);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        centerTitle: true,
        title: Text(
            "Face Recognition Attendance System"),
        titleTextStyle: TextStyle(
            fontSize: 19,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null? SizedBox(
              width: 200,
                height: 300,
                child: Image.file(_image!)) : Icon(
              Icons.image, size: 150,
            ),
            SizedBox(height: 18),
            ElevatedButton(
              onPressed: (){
                chooseImages();
              },
              onLongPress: (){
                captureImages();
              },
              child: Text("Choose/Capture"),
            ),
          ],
        ),
      ),
    );
  }
}
