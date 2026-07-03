// ignore_for_file: file_names

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  late CameraController _controller;
  late List<CameraDescription> _cameras;

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras.first, ResolutionPreset.high);
    await _controller.initialize();
  }

  Future<void> captureImage() async {
    try {
      final image = await _controller.takePicture();
      if (kDebugMode) {
        print("Image captured: ${image.path}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error capturing image: $e");
      }
    }
  }
}
