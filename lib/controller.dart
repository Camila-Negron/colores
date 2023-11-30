import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;
import 'package:flutter/foundation.dart';

class CameraControllerX extends GetxController {
  CameraController? cameraController;
  RxString colorHex = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(cameras.first, ResolutionPreset.high, enableAudio: false);
        await cameraController!.initialize();
      } else {
        print('No cameras available');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> captureColor() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      print('Controller is not initialized');
      return;
    }

    try {
      XFile file = await cameraController!.takePicture();
      File imageFile = File(file.path);
      colorHex.value = await compute(processImageToGetColor, imageFile);
    } catch (e) {
      print('Error capturing color: $e');
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}

Future<String> processImageToGetColor(File imageFile) async {
  try {
    imglib.Image? image = imglib.decodeImage(await imageFile.readAsBytes());
    if (image == null) return '';

    int centerX = image.width ~/ 2;
    int centerY = image.height ~/ 2;
    int radius = min(centerX, centerY) ~/ 2; // Usar la menor dimensión para el radio

    List<int> pixels = [];
    for (int y = -radius; y <= radius; y++) {
      for (int x = -radius; x <= radius; x++) {
        if (x * x + y * y <= radius * radius) {
          pixels.add(image.getPixel(centerX + x, centerY + y));
        }
      }
    }

    double avgRed = 0, avgGreen = 0, avgBlue = 0;
    for (int color in pixels) {
      avgRed += imglib.getRed(color);
      avgGreen += imglib.getGreen(color);
      avgBlue += imglib.getBlue(color);
    }
    int numPixels = pixels.length;
    avgRed /= numPixels;
    avgGreen /= numPixels;
    avgBlue /= numPixels;

    String hexColor = '#${avgRed.round().toRadixString(16).padLeft(2, '0')}${avgGreen.round().toRadixString(16).padLeft(2, '0')}${avgBlue.round().toRadixString(16).padLeft(2, '0')}';
    return hexColor;
  } catch (e) {
    print('Error processing image: $e');
    return '';
  }
}
