import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = <CameraDescription>[];
late Map<CameraLensDirection, CameraDescription> camerasMap;
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

typedef Callback = void Function(List<dynamic> list, int h, int w);

Map<CameraLensDirection, CameraDescription> initCameraMap() {
  camerasMap = {};
  for (CameraDescription camera in cameras) {
    camerasMap[camera.lensDirection] = camera;
  }
  return camerasMap;
}

void showInSnackBar(String message) {
  scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
}

void showCameraException(CameraException e) {
  logError(e.code, e.description);
  showInSnackBar('Error: ${e.code}\n${e.description}');
}

void logError(String code, String? message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}
