// import 'dart:developer';

// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// import '../image/Yuv420Image.dart';
// import '../logging/loggerUtil.dart';

// class FaceDetection {
//   FaceDetection() {
//     faceDetector = FaceDetector(
//       options: FaceDetectorOptions(
//           enableContours: true,
//           // enableClassification: true,
//           enableClassification: false,
//           enableLandmarks: true,

//           //performanceMode: FaceDetectorMode.fast,
//           minFaceSize: 0.3),
//     );
//   }

//   late final FaceDetector faceDetector;
//   late List<Face> faces;

//   Future<bool> containsFrontalFace(Yuv420Image image) async {
//     int faceCount = await _getFaceCount(image.asInputImage());
//     if (faceCount == 0 || faceCount > 1) {
//       return false;
//     }
//     if (isFaceFrontal(faces.elementAt(0))) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> containsFace(Yuv420Image image) async {
//     var startTime = DateTime.now();
//     int faceCount = await _getFaceCount(image.asInputImage());
//     log('Faces: $faceCount');
//     getLogger().i('FaceDetection.containsFace() Dauer in millis ${DateTime.now().difference(startTime).inMilliseconds}');
//     return faceCount > 0;
//   }

//   void close() {
//     faceDetector.close();
//   }

//   Future<int> _getFaceCount(InputImage image) async {
//     //List<Face> faces = await faceDetector.processImage(image);
//     faces = await faceDetector.processImage(image);
//     return faces.length;
//   }

//   // Wurde ein Photo frontal aufgenommen
//   bool isFaceFrontal(Face face) {
//     // headEulerAngleX > 0 => Kopf ist nach oben gerichtet
//     // headEulerAngleX < 0 => Kopf ist nach unten gerichtet
//     double xValue = 10;
//     bool xPositionOk = false;
//     if (face.headEulerAngleX! >= -xValue && face.headEulerAngleX! <= xValue) {
//       xPositionOk = true;
//     }

//     // headEulerAngleY > 0 => Kopf zeigt nach rechts
//     // headEulerAngleY < 0 => Kopf zeigt nach links
//     double yValue = 10;
//     bool yPositionOk = false;
//     if (face.headEulerAngleY! >= -yValue && face.headEulerAngleY! <= yValue) {
//       yPositionOk = true;
//     }

//     // headEulerAngleZ > 0 => Kopf relativ zu Kamera gegen den Uhrzeigersinn gedreht
//     // headEulerAngleZ < 0 => Kopf relativ zu Kamera entlang des Uhrzeigersinn gedreht
//     double zValue = 10;
//     bool zPositionOk = false;
//     if (face.headEulerAngleZ! >= -zValue && face.headEulerAngleZ! <= zValue) {
//       zPositionOk = true;
//     }

//     return xPositionOk && yPositionOk && zPositionOk;
//   }

//   // Hat das Gesicht eine passende Größe
//   bool isFaceBigEnough(Face face) {
//     // Wird durch minFaceSize im Constructor bestimmt
//     return false;
//   }
// }
