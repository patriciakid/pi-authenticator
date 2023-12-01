import 'dart:developer';
import 'dart:ui';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:privacyidea_authenticator/utils/logger.dart';

enum Direction {
  front,
  right,
  left,
  up,
  down,
  upLeft,
  upRight,
  downLeft,
  downRight,
  unknown,
}

class FaceAnalyzer {
  final Face face;
  final Size? imageSize;
  FaceAnalyzer({required this.face, this.imageSize});

  bool faceIsCenteredInThePicture() {
    const minPadding = 0.15;
    const maxPadding = 0.37;
    if (imageSize == null) {
      Logger.warning("Cant check if face is centered without knowing the image bounds", name: "face_analyzer.dart#faceIsCenteredInThePicture");
      return false;
    }
    // Padding between 10% and 20% of the image size is allowed
    final boundingBox = face.boundingBox;
    // log("Image size height: ${imageSize!.height}");
    // log("Image size width: ${imageSize!.width}");

    // log("Bounding box top: ${boundingBox.top}");
    // log("Space to top: ${boundingBox.top}");
    // log("Bounding box left: ${boundingBox.left}");
    // log("Space to left: ${boundingBox.left}");
    // log("Bounding box bottom: ${boundingBox.bottom}");
    // log("Space to bottom: ${imageSize!.height - boundingBox.bottom}");
    // log("Bounding box right: ${boundingBox.right}");
    // log("Space to right: ${imageSize!.width - boundingBox.right}");

    final normalizedSpaceFromImageZeroToTop = boundingBox.top / imageSize!.height;
    final normalizedSpaceFromImageZeroToLeft = boundingBox.left / imageSize!.width;
    final normalizedSpaceFromImageHeihtToBottom = (imageSize!.height - boundingBox.bottom) / imageSize!.height;
    final normalizedSpaceFromImageWidthToRight = (imageSize!.width - boundingBox.right) / imageSize!.width;

    final isBoundingBoxCenteredInImageSize = normalizedSpaceFromImageZeroToTop > minPadding &&
        normalizedSpaceFromImageZeroToTop < maxPadding &&
        normalizedSpaceFromImageZeroToLeft > minPadding &&
        normalizedSpaceFromImageZeroToLeft < maxPadding &&
        normalizedSpaceFromImageHeihtToBottom > minPadding &&
        normalizedSpaceFromImageHeihtToBottom < maxPadding &&
        normalizedSpaceFromImageWidthToRight > minPadding &&
        normalizedSpaceFromImageWidthToRight < maxPadding;
    if (isBoundingBoxCenteredInImageSize) {
      log('Face is Centered in the image');
    } else {
      log('Face is not centered in the image');
    }
    return isBoundingBoxCenteredInImageSize;
  }

  Direction getDirection() {
    log("Face headEulerAngleX: ${face.headEulerAngleX}");
    log("Face headEulerAngleY: ${face.headEulerAngleY}");

    if (face.headEulerAngleY == null || face.headEulerAngleZ == null) return Direction.unknown;
    if (faceIsLookingToTheRight && faceIsLookingUp) return Direction.upRight;
    if (faceIsLookingToTheRight && faceIsLookingDown) return Direction.downRight;
    if (faceIsLookingToTheLeft && faceIsLookingUp) return Direction.upLeft;
    if (faceIsLookingToTheLeft && faceIsLookingDown) return Direction.downLeft;
    if (faceIsLookingToTheRight) return Direction.right;
    if (faceIsLookingToTheLeft) return Direction.left;
    if (faceIsLookingUp) return Direction.up;
    if (faceIsLookingDown) return Direction.down;
    if (faceIsLookingAtCamera) return Direction.front;
    return Direction.unknown;
  }

  bool get faceIsLookingAtCamera =>
      face.headEulerAngleY != null && face.headEulerAngleZ != null ? face.headEulerAngleY!.abs() < 15 && face.headEulerAngleX!.abs() < 15 : false;

  bool get faceIsLookingToTheRight => face.headEulerAngleY != null ? face.headEulerAngleY! > 15 : false;

  bool get faceIsLookingToTheLeft => face.headEulerAngleY != null ? face.headEulerAngleY! < -15 : false;

  bool get faceIsLookingUp => face.headEulerAngleX != null ? face.headEulerAngleX! > 15 : false;

  bool get faceIsLookingDown => face.headEulerAngleX != null ? face.headEulerAngleX! < -15 : false;
}
