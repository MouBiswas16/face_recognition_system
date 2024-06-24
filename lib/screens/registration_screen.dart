// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:face_recognition_system/strings/colors.dart';
import 'package:face_recognition_system/widgets_&_classes/face_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // TODO declare variables
  ImagePicker? imagePicker;
  File? _image;

  // TODO declare detector
  FaceDetector? faceDetector;

  // TODO declare face recognition

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();

    // TODO initialize face detector
    final options =
        FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: options);

    // TODO initialize face recognition
  }

  // TODO capture image form Camera
  _imageFromCamera() async {
    XFile? pickedFile =
        await imagePicker!.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  // TODO choose image using Gallery
  _imageFromGallery() async {
    XFile? pickedFile =
        await imagePicker!.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      doFaceDetection();
    }
  }

  // TODO face detection code here
  List<Face> faces = [];
  doFaceDetection() async {
    // TODO remove rotation of camera images
    InputImage inputImage = InputImage.fromFile(_image!);

    // TODO passing input to face detector and getting detected faces
    faces = await faceDetector!.processImage(inputImage);

    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);

    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      print("Rect = " + boundingBox.toString());

      num left = boundingBox.left < 0 ? 0 : boundingBox.left;
      num right = boundingBox.right > image.width ? image.width - 1 : boundingBox.right;
      num top = boundingBox.top < 0 ? 0 : boundingBox.top;
      num bottom = boundingBox.bottom > image.height ? image.height - 1 : boundingBox.bottom;
      num width = right - left;
      num height = top - bottom;

      final bytes = _image!.readAsBytesSync();
      img.Image? faceImg = img.decodeImage(bytes);
      img.Image croppedFace =
          img.copyCrop(faceImg!, x: left.toInt(), y: top.toInt(), width: width.toInt(), height: height.toInt());
    }
    drawRectangleAroundFaces();
    // TODO call the method to perform face recognition on detected faces
  }

  //TODO remove rotation of camera images

  // TODO perform Face Recognition

  // TODO Face Registration Dialogue

  // TODO draw rectangle
  var image;
  drawRectangleAroundFaces() async {
    print("${image.width}    ${image.height}");
    setState(() {
      image;
      faces;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Face Recognition",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image != null
                ? Container(
                    margin: EdgeInsets.only(
                        top: 68, left: 30, right: 30, bottom: 0),
                    child: FittedBox(
                      child: SizedBox(
                        width: (image.width as int).toDouble(),
                        height: (image.height as int).toDouble(),
                        child: CustomPaint(
                          painter: FacePainter(
                            facesList: faces,
                            imageFile: image,
                          ),
                        ),
                      ),
                    ),
                  )
                : Icon(
                    Icons.image_outlined,
                    size: 200,
                    color: Color(0xffBBBBBB),
                  ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    elevation: 10,
                    child: IconButton(
                      onPressed: () {
                        _imageFromGallery();
                      },
                      icon: Icon(
                        size: 56,
                        Icons.image,
                        color: btnColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    elevation: 10,
                    child: IconButton(
                      onPressed: () {
                        _imageFromCamera();
                      },
                      icon: Icon(
                        size: 56,
                        Icons.camera,
                        color: btnColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
