// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:face_recognition_system/strings/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../ML/Recognition.dart';
import '../ML/recognizer.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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

  //TODO capture image using camera
  _imgFromCamera() async {
    XFile? pickedFile =
        await imagePicker!.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        doFaceDetection();
      });
    }
  }

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

  doFaceDetection() async {
    //TODO remove rotation of camera images
    InputImage inputImage = InputImage.fromFile(_image!);
    image = await decodeImageFromList(_image!.readAsBytesSync());

    //TODO passing input to face detector and getting detected faces
    faces = await faceDetector!.processImage(inputImage);

    for (Face face in faces) {
      // Rect faceRect = face.boundingBox;
      final Rect boundingBox = face.boundingBox;
      print("Rect = " + boundingBox.toString());

      // num left = faceRect.left < 0 ? 0 : faceRect.left;
      // num top = faceRect.top < 0 ? 0 : faceRect.top;
      // num right =
      //     faceRect.right > image.width ? image.width - 1 : faceRect.right;
      // num bottom =
      //     faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;

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
      //await File(croppedFace!.path).readAsBytes();
      img.Image? faceImg = img.decodeImage(bytes);
      // img.Image faceImg2 = img.copyCrop(
      //   faceImg!,
      //   x: left.toInt(),
      //   y: top.toInt(),
      //   width: width.toInt(),
      //   height: height.toInt(),
      // );

      img.Image croppedFace = img.copyCrop(
        faceImg!,
        x: left.toInt(),
        y: top.toInt(),
        width: width.toInt(),
        height: height.toInt(),
      );

      Recognition recognition = recognizer!.recognize(croppedFace, boundingBox);
      showFaceRegistrationDialogue(
          Uint8List.fromList(img.encodeBmp(croppedFace)), recognition);

      //   Recognition recognition = recognizer.recognize(faceImg2, faceRect);
      //   showFaceRegistrationDialogue(
      //       Uint8List.fromList(img.encodeBmp(faceImg2)), recognition);
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
    // image = await _image?.readAsBytes();
    // image = await decodeImageFromList(image);
    // print("${image.width}   ${image.height}");
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          image != null
              ?
              // Container(
              //         margin: EdgeInsets.only(top: 100),
              //         width: screenWidth - 50,
              //         height: screenWidth - 50,
              //         child: Image.file(_image!),
              //       )
              Container(
                  margin:
                      EdgeInsets.only(top: 68, left: 48, right: 48, bottom: 0),
                  child: FittedBox(
                    child: SizedBox(
                      width: image.width.toDouble(),
                      height: image.width.toDouble(),
                      child: CustomPaint(
                        painter: FacePainter(
                          facesList: faces,
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
                      _imgFromCamera();
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
  List<Face> facesList;
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

    for (Face face in facesList) {
      canvas.drawRect(face.boundingBox, p);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
