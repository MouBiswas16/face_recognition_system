// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';
import 'package:face_recognition_system/ML/Recognition.dart';
import 'package:face_recognition_system/ML/recognizer.dart';
import 'package:face_recognition_system/screens/live_face_detection.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../strings/colors.dart';

class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({super.key});

  @override
  State<RecognitionScreen> createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  //TODO declare variables
  ImagePicker? imagePicker;
  File? _image;

  // //TODO declare detector
  FaceDetector? faceDetector;

  //TODO declare face recognizer
  Recognizer? recognizer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();

    //TODO initialize face detector
    final options =
        FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: options);

    //TODO initialize face recognizer
    recognizer = Recognizer();
  }

  // //TODO capture image using camera
  // _imgFromCamera() async {
  //   XFile? pickedFile =
  //       await imagePicker!.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //       doFaceDetection();
  //     });
  //   }
  // }

  //TODO choose image using gallery
  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker!.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

  //TODO face detection code here
  List<Face> faces = [];
  List<Recognition> recognitions = [];

  doFaceDetection() async {
    //TODO remove rotation of camera images
    InputImage inputImage = InputImage.fromFile(_image!);
    recognitions.clear();

    image = await decodeImageFromList(_image!.readAsBytesSync());

    //TODO passing input to face detector and getting detected faces
    faces = await faceDetector!.processImage(inputImage);

    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;
      // print("Rect = " + boundingBox.toString());

      num left = boundingBox.left < 0 ? 0 : boundingBox.left;
      num top = boundingBox.top < 0 ? 0 : boundingBox.top;
      num right =
          boundingBox.right > image.width ? image.width - 1 : boundingBox.right;
      num bottom = boundingBox.bottom > image.height
          ? image.height - 1
          : boundingBox.bottom;

      num width = right - left;
      num height = bottom - top;

      //TODO crop face
      final bytes = _image!.readAsBytesSync();

      img.Image? faceImg = img.decodeImage(bytes);

      img.Image croppedFace = img.copyCrop(
        faceImg!,
        x: left.toInt(),
        y: top.toInt(),
        width: width.toInt(),
        height: height.toInt(),
      );

      Recognition recognition = recognizer!.recognize(croppedFace, boundingBox);
      if (recognition.distance > 1.25) {
        recognition.name = "Unknown";
      }
      recognitions.add(recognition);
      print("Recognized Faces " + recognition.name);

      // showFaceRegistrationDialogue(
      //     Uint8List.fromList(img.encodeBmp(croppedFace)), recognition);
    }
    drawRectangleAroundFaces();

    // TODO call the method to perform face recognition on detected faces
  }

//TODO remove rotation of camera images
  removeRotation(File inputImage) async {
    final img.Image? capturedImage =
        img.decodeImage(await File(inputImage.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
  }

//TODO perform Face Recognition

//TODO Face Registration Dialogue
  TextEditingController textEditingController = TextEditingController();
  showFaceRegistrationDialogue(Uint8List croppedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Face Registration",
          textAlign: TextAlign.center,
        ),
        alignment: Alignment.center,
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Image.memory(
                croppedFace,
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Enter Name",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  recognizer!.registerFaceInDB(
                      textEditingController.text, recognition.embeddings);
                  textEditingController.text = "";
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Face Registered",
                        style: TextStyle(color: btnTextColor),
                      ),
                      backgroundColor: btnColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor, minimumSize: Size(200, 40)),
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: btnTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

//TODO draw rectangles
  var image;
  drawRectangleAroundFaces() async {
    setState(() {
      image;
      recognitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          image != null
              ? Container(
                  margin:
                      EdgeInsets.only(top: 68, left: 48, right: 48, bottom: 0),
                  child: FittedBox(
                    child: SizedBox(
                      width: image.width.toDouble(),
                      height: image.width.toDouble(),
                      child: CustomPaint(
                        painter: FacePainter(
                          facesList: recognitions,
                          imageFile: image,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 100),
                  child: Icon(
                    color: btnColor,
                    Icons.image_outlined,
                    size: screenHeight * 0.42,
                    shadows: const [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),

          //TODO section which displays buttons for choosing and capturing images
          Container(
            margin: EdgeInsets.only(bottom: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 8,
                  shadowColor: Colors.black,
                  color: Color(0xffededed),
                  child: InkWell(
                    onTap: () {
                      _imgFromGallery();
                    },
                    child: SizedBox(
                      width: screenWidth / 2 - 100,
                      height: screenWidth / 2 - 100,
                      child: Icon(
                        Icons.image,
                        color: btnColor,
                        size: screenWidth / 7,
                      ),
                    ),
                  ),
                ),
                Card(
                  elevation: 8,
                  shadowColor: Colors.black,
                  color: Color(0xffededed),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        LiveFaceDetection();
                      });
                    },
                    child: SizedBox(
                      width: screenWidth / 2 - 100,
                      height: screenWidth / 2 - 100,
                      child: Icon(
                        Icons.camera,
                        color: btnColor,
                        size: screenWidth / 7,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Recognition> facesList;
  dynamic imageFile;

  FacePainter({required this.facesList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 12;

    for (Recognition face in facesList) {
      canvas.drawRect(face.location, p);

      TextSpan textSpan = TextSpan(
        text: face.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
      TextPainter tp =
          TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
        canvas,
        Offset(face.location.left, face.location.right),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
