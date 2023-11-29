// import 'dart:ffi';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
// import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;
import 'package:mutex/mutex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:privacyidea_authenticator/utils/image/camera_manager.dart';
// import 'package:privacyidea_authenticator/utils/image/camera_manager.dart';

class ImageConverter {
  static Mutex _mutex = Mutex();
  final imglib.Image image;

  ImageConverter({
    required this.image,
  });

  factory ImageConverter.fromCameraImage(CameraImage image, int rotation) {
    if (image.format.group != ImageFormatGroup.yuv420 || image.planes.length != 3) {
      throw ArgumentError('Only support YUV_420 format');
    }
    return ImageConverter._rotatedCameraImage(image, rotation);
  }

  factory ImageConverter._rotatedCameraImage(CameraImage image, int rotation) {
    const alpha = 0xFF;
    final height = image.height;
    final width = image.width;
    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];
    try {
      final int outputWidth = rotation == 90 || rotation == 270 ? height : width;
      final int outputHeight = rotation == 90 || rotation == 270 ? width : height;
      final int uvRowStride = uPlane.bytesPerRow;
      final int uvPixelStride = uPlane.bytesPerPixel!;

      // imgLib -> Image package from https://pub.dartlang.org/packages/image
      var img = imglib.Image(width: outputWidth, height: outputHeight); // Create Image buffer

      // Fill image buffer with plane[0] from YUV420_888
      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          final int index = (y * width + x);

          final yp = yPlane.bytes[index];
          final up = uPlane.bytes[uvIndex];
          final vp = vPlane.bytes[uvIndex];
          // Calculate pixel color

          final int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          final int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
          final int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R

          switch (rotation) {
            case 90:
              if (!(img.isBoundsSafe(outputWidth - y - 1, x))) break;
              img.setPixelRgba(outputWidth - y - 1, x, r, g, b, alpha);
              break;
            case 180:
              if (!(img.isBoundsSafe(outputWidth - x - 1, outputHeight - y - 1))) break;
              img.setPixelRgba(outputWidth - x - 1, outputHeight - y - 1, r, g, b, alpha);
              break;
            case 270:
              if (!(img.isBoundsSafe(y, outputHeight - x - 1))) break;
              img.setPixelRgba(y, outputHeight - x - 1, r, g, b, alpha);
              break;
            default:
              if (!(img.isBoundsSafe(x, y))) break;
              img.setPixelRgba(x, y, r, g, b, alpha);
              break;
          }
        }
      }
      return ImageConverter(image: img);
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
      throw e;
    }
  }

  factory ImageConverter.fromFile(String path) {
    final img = imglib.decodeImage(File(path).readAsBytesSync())!;
    return ImageConverter(image: img);
  }

  factory ImageConverter.fromBytes(Uint8List bytes) {
    final img = imglib.decodeImage(bytes)!;
    return ImageConverter(image: img);
  }

  Uint8List toBytes() {
    return Uint8List.fromList(imglib.encodePng(image));
  }

  imglib.Image toImage() {
    return image;
  }

  Future<InputImage> toInputImage() async {
    final tempDir = await getTemporaryDirectory();
    await _mutex.acquire();
    final file = File("${tempDir.path}/PiImageConverter.png");
    await file.writeAsBytes(toBytes());
    final inputImage = InputImage.fromFile(file);
    _mutex.release();
    return inputImage;
  }
}
