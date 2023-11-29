import 'package:camera/camera.dart';

class CameraManager {
  static List<CameraDescription> _cameras = [];
  static late CameraDescription _backCamera;
  static late CameraDescription _frontCamera;

  static Future<void> ensureInitialized() async {
    if (_cameras.isNotEmpty) {
      return;
    }
    _cameras = await availableCameras();
    _backCamera = _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back, orElse: () => _cameras.first);
    _frontCamera = _cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front, orElse: () => _cameras.first);
  }

  static List<CameraDescription> get cameras => _cameras;
  static CameraDescription get frontCamera => _frontCamera;
  static CameraDescription get backCamera => _backCamera;
}
