// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:privacyidea_authenticator/utils/logger.dart';
import 'package:image/image.dart' as imglib;

import '../../utils/image/yuv420_image.dart';
import '../../utils/image/camera_manager.dart';

class BioView extends StatefulWidget {
  static const routeName = '/bio-view';

  const BioView({super.key});

  @override
  State<BioView> createState() => _BioViewState();
}

class _BioViewState extends State<BioView> {
  CameraController? cameraController;
  bool cameraInitialized = false;
  DateTime? lastProcessImageTimeStamp;

  FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: false,
      // enableClassification: true,
      enableClassification: false,
      enableLandmarks: false,
      performanceMode: FaceDetectorMode.accurate,
      minFaceSize: 0.1,
    ),
  );

  @override
  void initState() {
    availableCameras().then((cameras) {
      cameraController = CameraController(
        cameras.firstWhere((element) => element.lensDirection == CameraLensDirection.front, orElse: () => cameras.first),
        ResolutionPreset.low,
      );
      cameraController!.initialize().then((value) => cameraController!.startImageStream((image) async {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() => cameraInitialized = true);
            });

            if ((lastProcessImageTimeStamp == null || DateTime.now().difference(lastProcessImageTimeStamp!) > Duration(seconds: 3))) {
              if (lastProcessImageTimeStamp != null) Navigator.pop(context);
              lastProcessImageTimeStamp = DateTime.now();
              final rotation = CameraManager.frontCamera.sensorOrientation;
              final yuv420Image = ImageConverter.fromCameraImage(image, rotation);
              final inputImage = await yuv420Image.toInputImage();

              Logger.warning("FaceDetector.processImage(inputImage) called.", name: "bio_view.dart#initState");
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                      title: Text("Processing this image: "),
                      content: Image.memory(
                        Uint8List.fromList(yuv420Image.toBytes()),
                        fit: BoxFit.cover,
                      )));
              faceDetector.processImage(inputImage).then((faces) {
                Logger.warning("FaceDetector.processImage(inputImage) called: ${faces.length} faces found.", name: "bio_view.dart#initState");
                if (faces.length > 0) {
                  cameraController!.stopImageStream();
                  showDialog(context: context, builder: (context) => AlertDialog(title: Text("Face detected!")));
                }
              });
            }
          }));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: cameraInitialized ? CameraPreview(cameraController!) : const CircularProgressIndicator(),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('BioView'),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}

// InputImage _convertCameraImageToInputImage(CameraImage cameraImage) {
//   InputImageFormat? inputImageFormat = switch (cameraImage.format.group) {
//     ImageFormatGroup.bgra8888 => InputImageFormat.bgra8888,
//     ImageFormatGroup.jpeg => throw (UnsupportedError("jpeg is not supported by InputImageFormat")),
//     ImageFormatGroup.nv21 => InputImageFormat.nv21,
//     ImageFormatGroup.yuv420 => InputImageFormat.yuv420,
//     ImageFormatGroup.unknown => throw (UnsupportedError("unknown is not supported by InputImageFormat")),
//   };
//   InputImageMetadata inputImageData = InputImageMetadata(
//     size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
//     rotation: InputImageRotation.rotation90deg,
//     format: inputImageFormat,
//     bytesPerRow: cameraImage.planes[0].bytesPerRow,
//   );

//   return InputImage.fromBytes(bytes: cameraImage.planes[0].bytes, metadata: inputImageData);
// }

// const shift = (0xFF << 24);
// Future<Image> _convertYUV420toImageColor(CameraImage image) async {
//   try {
//     final int width = image.width;
//     final int height = image.height;
//     final int uvRowStride = image.planes[1].bytesPerRow;
//     final int uvPixelStride = image.planes[1].bytesPerPixel!;

//     print("uvRowStride: " + uvRowStride.toString());
//     print("uvPixelStride: " + uvPixelStride.toString());
//     print("width: " + width.toString());
//     print("height: " + height.toString());

//     // imgLib -> Image package from https://pub.dartlang.org/packages/image
//     var img = imglib.Image(height: height, width: width); // Create Image buffer

//     // Fill image buffer with plane[0] from YUV420_888
//     for (int x = 0; x < width; x++) {
//       for (int y = 0; y < height; y++) {
//         final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
//         final int index = y * width + x;

//         final yp = image.planes[0].bytes[index];
//         final up = image.planes[1].bytes[uvIndex];
//         final vp = image.planes[2].bytes[uvIndex];
//         // Calculate pixel color
//         int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
//         int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
//         int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
//         // color: 0x FF  FF  FF  FF
//         //           A   B   G   R
//         if (img.isBoundsSafe(height - y, x)) {
//           img.setPixelRgba(height - y, x, r, g, b, shift);
//         }
//       }
//     }

//     imglib.PngEncoder pngEncoder = imglib.PngEncoder(level: 0);
//     List<int> png = pngEncoder.encode(img);
//     Uint8List? bytes = Uint8List.fromList(png);
//     return Image.memory(bytes);
//   } catch (e) {
//     print(">>>>>>>>>>>> ERROR:" + e.toString());
//     throw e;
//   }
// }

// imglib.Image _yuv420ToRgb(CameraImage input) {
//   if (input.format.group != ImageFormatGroup.yuv420) {
//     throw ArgumentError('Only support YUV_420_888 format');
//   }
//   var startTime = DateTime.now();

//   //const shift = (0xFF << 24);
//   const shift = (255 << 24);

//   // Create image buffer
//   imglib.Image output = imglib.Image(width: input.width, height: input.height, numChannels: 1);

//   for (int y = 0; y < input.height; y++) {
//     int uvh = (y / 2).floor();

//     for (int x = 0; x < input.width; x++) {
//       int uvw = (x / 2).floor();
//       final yIndex = (y * input.yRowStride) + (x * input.yPixelStride);

//       // Y plane should have positive values belonging to [0...255]
//       //final int yp = input.yPlane[yIndex];
//       final int yp = input.planes[0].bytes[yIndex];

//       // U/V values are subsampled i.e. each pixel in U/V channel in a
//       // YUV_420 image act as chroma value for 4 neighbouring pixels
//       final int uvIndex = (uvh * input.uvRowStride) + (uvw * input.uvPixelStride);

//       // U/V values ideally fal under [-0.5, 0.5] range. To fit them into
//       // [0, 255] range they are scaled up and centered to 128
//       // Operation below brings U/V values to [-128, 127].

//       /*final int up = input.uPlane[uvIndex];
//         final int vp = input.vPlane[uvIndex];*/
//       final int up = input.planes[1].bytes[uvIndex];
//       final int vp = input.planes[2].bytes[uvIndex];

//       late int Red, Green, Blue;

//       // Compute RGB values per formula above
//       // Version 1
//       Red = (yp + 1.13983 * (vp - 128)).round().clamp(0, 255);
//       Green = (yp - 0.39465 * (up - 128) - 0.58060 * (vp - 128)).round().clamp(0, 255);
//       Blue = (yp + 2.03211 * (up - 128)).round().clamp(0, 255);
//       /*double redDouble = yp + 1.13983 * (vp - 128);
//         double greenDouble = yp - 0.39465 * (up - 128) - 0.58060 * (vp - 128);
//         double blueDouble = yp + 2.03211 * (up - 128);*/
//       //log.i('RawValues [R: $redDouble G: $greenDouble B: $blueDouble]');

//       /*Red = redDouble.round();
//         Green = greenDouble.round();
//         Blue = blueDouble.round();*/
//       //log.i('After round() [R: $Red G: $Green B: $Blue]');

//       /*Red = Red.clamp(0, 255);
//         Green = Green.clamp(0, 255);
//         Blue = Blue.clamp(0, 255);*/
//       //log.i('RGB Values [R: $Red G: $Green B: $Blue]');

//       // Version 2 FAILED
//       /*Blue = (yp + 1/0.493 * up).round().clamp(0, 255);
//         Red = (yp + 1/0.877 * vp).round().clamp(0, 255);
//         Green = (1/0.587 * yp - 0.299/0.587 * Red - 0.114/0.587 * Blue).round().clamp(0, 255);*/

//       // Version 3 FAILED
//       /*Red = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
//         Green = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
//         Blue = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);*/

//       // Version 4 FAILED
//       /*Red = (yp + 1.402 * vp).round().clamp(0, 255);
//         Green = (yp - 0.344 * up - 0.714 * vp).round().clamp(0, 255);
//         Blue = (yp + 1.772 * up).round().clamp(0, 255);*/

//       //log.i('RGB Values [R: $Red G: $Green B: $Blue]');
//       final int argbIndex = y * input.width + x;
//       output.toUint8List()[argbIndex] = shift | (Blue << 16) | (Green << 8) | Red;

//       /*if (output.isBoundsSafe(x, input.height - y)) {
//           output.setPixelRgba(x, input.height - y, Red, Green, Blue, shift);
//         }*/

//       /*output.toUint8List()[argbIndex] = 0xff000000 | ((blue << 16) & 0xff0000) | ((green << 8) & 0xff00) | (red & 0xff);*/
//     }
//   }
//   log.i('yuv420ToRgb() Dauer in millis ${DateTime.now().difference(startTime).inMilliseconds}');
//   return output;
// }
