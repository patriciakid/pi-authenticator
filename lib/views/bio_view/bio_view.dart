// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as imglib;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:privacyidea_authenticator/utils/image/face_analyzer.dart';
import 'package:privacyidea_authenticator/utils/logger.dart';

import '../../utils/image/yuv420_image.dart';
import '../../utils/image/camera_manager.dart';

class BioView extends StatefulWidget {
  static const routeName = '/bio-view';

  const BioView({super.key});

  @override
  State<BioView> createState() => _BioViewState();
}

class _BioViewState extends State<BioView> {
  late final CameraController? cameraController;
  bool cameraInitialized = false;
  DateTime? lastProcessImageTimeStamp;
  Direction disiredDirection = _getRandomDirection();
  ImageConverter? lastImage;
  Size? lastImageSize;
  Face? lastFace;

  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      minFaceSize: 1,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  @override
  void initState() {
    availableCameras().then((cameras) {
      cameraController = CameraController(
        cameras.firstWhere((element) => element.lensDirection == CameraLensDirection.front, orElse: () => cameras.first),
        ResolutionPreset.low,
      );
      cameraController!.initialize().then((value) {
        setState(() {
          cameraInitialized = true;
        });
        return cameraController!.startImageStream(_handleImageStream);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final analyzer = lastFace == null ? null : FaceAnalyzer(face: lastFace!, imageSize: lastImageSize);
    final lastDirection = analyzer?.getDirection();
    final faceIsCentered = analyzer?.faceIsCenteredInThePicture() ?? false;
    return Stack(
      children: [
        if (cameraInitialized)
          Positioned.fill(
            child: Stack(
              children: [
                lastImage != null
                    ? Positioned.fill(
                        child: Center(
                          child: CameraPreview(cameraController!),
                        ),
                      )
                    : const SizedBox(),
                Center(
                  child: Container(
                    width: lastImageSize?.width ?? 0 * 0.8,
                    height: lastImageSize?.height ?? 0 * 0.8,
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(BorderSide(color: faceIsCentered ? Colors.green : Colors.red, width: 5)),
                      borderRadius: const BorderRadius.all(Radius.circular(99999999)),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'Current direction: ${lastDirection.toString().split(',').last}\nDesired direction: ${disiredDirection.toString().split('.').last}',
                        style: const TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('BioView'),
            centerTitle: true,
          ),
          body: const SizedBox(),
        ),
      ],
    );
  }

  void _handleImageStream(CameraImage image) async {
    if ((lastProcessImageTimeStamp == null || DateTime.now().difference(lastProcessImageTimeStamp!) > const Duration(milliseconds: 1000))) {
      lastProcessImageTimeStamp = DateTime.now();
      final camera = CameraManager.frontCamera;
      final rotation = camera.sensorOrientation;
      final yuv420Image = ImageConverter.fromCameraImage(image, rotation, isFrontCamera: camera.lensDirection == CameraLensDirection.front);
      final inputImage = await yuv420Image.toInputImage();
      setState(() {
        this.lastImage = yuv420Image;
        this.lastImageSize = yuv420Image.size;
      });

      Logger.warning("FaceDetector.processImage(inputImage) called.", name: "bio_view.dart#initState");

      faceDetector.processImage(inputImage).then((faces) async {
        setState(() {
          lastFace = faces.firstOrNull;
        });
        Logger.warning("FaceDetector.processImage(inputImage) called: ${faces.length} faces found.", name: "bio_view.dart#initState");
        if (faces.isNotEmpty) {
          if (faces.length > 1) {
            await showDialog(context: context, builder: (context) => const AlertDialog(title: Text("More than one face detected!")));
            return;
          }
          final image = yuv420Image.toImage();
          final analyzer = FaceAnalyzer(face: faces.first, imageSize: Size(image.width.toDouble(), image.height.toDouble()));
          if (!analyzer.faceIsCenteredInThePicture()) {
            return;
          }
          final direction = analyzer.getDirection();

          if (direction != disiredDirection) {
            Logger.info("Wrong direction: ${direction.toString().split('.').last}", name: "bio_view.dart#initState");
            return;
          }
          cameraController!.stopImageStream();
          await showDialog(context: context, builder: (context) => const AlertDialog(title: Text("Right direction!")));
          setState(() {
            disiredDirection = _getRandomDirection();
          });
          cameraController!.startImageStream(_handleImageStream);
        }
      });
    }
  }
}

Direction _getRandomDirection() {
  final random = Random();
  switch (random.nextInt(5)) {
    case 0:
      return Direction.front;
    case 1:
      return Direction.right;
    case 2:
      return Direction.left;
    case 3:
      return Direction.up;
    case 4:
      return Direction.down;
    default:
      return Direction.unknown;
  }
}
