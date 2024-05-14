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

  captureImages(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Recognition Attendance System"),),
      body: Center(
        child: Column(
          children: [
            _image != null? SizedBox(
              width: 200,
                height: 200,
                child: Image.file(_image!)) : Icon(Icons.image, size: 150,),
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
