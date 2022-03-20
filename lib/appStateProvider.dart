import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  AppStateProvider();

  bool isDetecting = false;
  bool isDetected = false;
  String detectionMessage = "Start detecting to see the results";

  void setDetecting(bool val) {
    isDetecting = val;
    // if (val == false) isDetected = false;
    if (val == false) setDetected(false);
    decideDetectionMessage();
    notifyListeners();
  }

  void setDetected(bool val) {
    isDetected = val;
    decideDetectionMessage();
    notifyListeners();
  }

  void decideDetectionMessage() {
    if (!isDetecting) {
      detectionMessage = "Start detecting to see the results";
    } else if (isDetected) {
      detectionMessage = "Mask detected! You are Safe";
    } else {
      detectionMessage = "Mask not detected! Please wear a mask";
    }
  }
}
