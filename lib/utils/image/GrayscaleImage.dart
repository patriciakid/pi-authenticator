import 'dart:typed_data';

/// Class representing the grayscale part of a YUV_420_888 image
class GrayscaleImage {
  GrayscaleImage({required this.data, required this.width, required this.height});

  late final Uint8List data;
  late final int width;
  late final int height;
}
