// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerClass extends StatefulWidget {
  const ImagePickerClass({super.key});

  @override
  State<ImagePickerClass> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickerClass> {

  File? _image;

  chooseImages(){}

  captureImages(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Recognition Attendance System"),),
      body: Center(
        child: Column(
          children: [
            _image != null? Image.file(_image!) : Icon(Icons.image, size: 150,),
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
