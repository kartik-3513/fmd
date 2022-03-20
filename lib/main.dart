import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fmd/appStateProvider.dart';
import 'package:fmd/cam_stack.dart';
import 'package:fmd/utils.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    camerasMap = initCameraMap();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(const CameraApp());
}

class CameraApp extends StatelessWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        lazy: false,
        create: (_) => AppStateProvider(),
        child: const CamStack(),
      ),
    );
  }
}



