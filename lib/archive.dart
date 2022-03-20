//  import 'package:camera/camera.dart';

// Future<XFile?> takePicture() async {
//     final CameraController? cameraController = controller;
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       showInSnackBar('Error: select a camera first.');
//       return null;
//     }

//     if (cameraController.value.isTakingPicture) {
//       // A capture is already pending, do nothing.
//       return null;
//     }

//     try {
//       final XFile file = await cameraController.takePicture();
//       return file;
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }
//   }

//    Future<void> onPausePreviewButtonPressed() async {
//     final CameraController? cameraController = controller;

//     if (cameraController == null || !cameraController.value.isInitialized) {
//       showInSnackBar('Error: select a camera first.');
//       return;
//     }

//     if (cameraController.value.isPreviewPaused) {
//       await cameraController.resumePreview();
//     } else {
//       await cameraController.pausePreview();
//     }

//     if (mounted) {
//       setState(() {});
//     }
//   }
//   void onTakePictureButtonPressed() {
//     takePicture().then((XFile? file) {
//       if (mounted) {
//         setState(() {
//           imageFile = file;
//         });
//         if (file != null) {
//           showInSnackBar('Picture saved to ${file.path}');
//         }
//       }
//     });
//   }
