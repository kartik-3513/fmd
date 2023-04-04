import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fmd/appStateProvider.dart';
import 'package:fmd/components/control_row.dart';
import 'package:provider/provider.dart';
import 'package:fmd/utils.dart';
import 'package:tflite/tflite.dart';

class CameraExampleHome extends StatefulWidget {
  final Callback? setRecognitions;
  const CameraExampleHome({Key? key, this.setRecognitions}) : super(key: key);

  @override
  _CameraExampleHomeState createState() {
    return _CameraExampleHomeState();
  }
}

class _CameraExampleHomeState extends State<CameraExampleHome>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  // XFile? imageFile;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addObserver(this);
    onNewCameraSelected(camerasMap[CameraLensDirection.front]!);
  }

  @override
  void dispose() {
    // WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Face Mask Detector'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Expanded(
            // child: _cameraPreviewWidget(),
            child: Consumer<AppStateProvider>(
              builder: (context, value, child) => Center(
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: value.isDetected ? Colors.green : Colors.red,
                      width: 2.0,
                    ),
                  ),
                  child: child,
                ),
              ),
              child: _cameraPreviewWidget(),
            ),
          ),
          SizedBox(
            height: 70,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Consumer<AppStateProvider>(
                builder: (context, value, child) => Text(
                  value.detectionMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: value.isDetected ? Colors.green : Colors.red,
                      fontSize: 20.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ControlButtons(
              toggleDetectionCallback: _toggleDetectionCallback,
              cameraSwitchCallback: _switchCameraCallback,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return Container();
    } else {
      return CameraPreview(
        controller!,
      );
    }
  }

  // String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.low,
    );

    controller = cameraController;
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize().then((value) => setState(() {}));
    } on CameraException catch (e) {
      showCameraException(e);
    }
  }

  Future<void> _switchCameraCallback() async {
    if (camerasMap.length == 2) {
      await resetVariables();
      final currentCameraDirection = controller?.description.lensDirection;
      final newCamera = currentCameraDirection == CameraLensDirection.back
          ? camerasMap[CameraLensDirection.front]
          : camerasMap[CameraLensDirection.back];
      onNewCameraSelected(newCamera!);
    }
  }

  Future<void> resetVariables() async {
    if (controller != null && controller!.value.isStreamingImages) {
      await controller!.stopImageStream();
    }
    Provider.of<AppStateProvider>(context, listen: false).setDetecting(false);
    isProcessing = false;
  }

  void _toggleDetectionCallback() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    if (controller != null) {
      if (controller!.value.isStreamingImages) {
        resetVariables();
      } else {
        appState.setDetecting(true);
        await controller!.startImageStream(
          (img) {
            if (!isProcessing) {
              isProcessing = true;
              try {
                Tflite.runModelOnFrame(
                  bytesList: img.planes.map((plane) => plane.bytes).toList(),
                  imageHeight: img.height,
                  imageWidth: img.width,
                  numResults: 2,
                  threshold: 0.9,
                  imageMean: 127.5,
                  imageStd: 127.5,
                ).then(
                  (recognitions) {
                    if (recognitions!.isNotEmpty && appState.isDetecting) {
                      final result = recognitions[0]["index"];
                      // result 1 is no mask, result 0 is mask
                      appState.setDetected(result == 0);
                    }
                    isProcessing = false;
                    // Future.delayed(Duration(seconds: 5), (() {
                    //   isDetecting = false;
                    // }));
                    // widget.setRecognitions(recognitions, img.height, img.width);
                  },
                );
              } catch (e) {}
            }
          },
        );
      }
    }
  }
}
