import 'package:flutter/material.dart';
import 'package:fmd/camera_screen.dart';
import 'package:tflite/tflite.dart';

class CamStack extends StatefulWidget {
  const CamStack({Key? key}) : super(key: key);

  @override
  State<CamStack> createState() => _CamStackState();
}

class _CamStackState extends State<CamStack> {
  // List<dynamic>? _recognitions;
  // int _imageHeight = 0;
  // int _imageWidth = 0;

  // setRecognitions(recognitions, imageHeight, imageWidth) {
  //   setState(() {
  //     _recognitions = recognitions;
  //     _imageHeight = imageHeight;
  //     _imageWidth = imageWidth;
  //   });
  // }
  @override
  void initState() {
    super.initState();
    Tflite.loadModel(
      numThreads: 2,
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      useGpuDelegate: true,
    ).then(
      (value) => print(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CameraExampleHome(
        // setRecognitions: setRecognitions,
        );
  }
}
