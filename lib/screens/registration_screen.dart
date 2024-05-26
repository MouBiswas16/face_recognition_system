// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  // TODO declare variables
  late ImagePicker imagePicker;
  File? _image;

  // TODO declare detector
  late FaceDetector faceDetector;

  // TODO declare face recognition

  @override
  void initState(){
    super.initState();
    imagePicker = ImagePicker();

    // TODO initialize face detector
    final options = FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: options);

    // TODO initialize face recognition
  }

  // TODO capture image form Camera
  _imageFromCamera() async{
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if(pickedFile != null){
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  // TODO choose image using Gallery
  _imageFromGallery() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      _image = File(pickedFile.path);
      doFaceDetection();
    }
  }

  // TODO face detection code here
  doFaceDetection() async {

    // TODO remove rotation of camera images
    InputImage inputImage = InputImage.fromFile(_image!);

    // TODO passing input to face detector and getting detected faces
    final List<Face> faces = await faceDetector.processImage(inputImage);

    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      print("Rect = " + boundingBox.toString());
    }

    // TODO call the method to perform face recognition on detected faces
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Face Recognition"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _image != null ? Container(
            margin: EdgeInsets.only(top: 100),
            width: screenWidth - 50,
            height: screenHeight - 50,
            child: Image.file(_image!),
          ) : Container(),
        ],
      ),
    );
  }
}
