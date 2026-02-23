import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

/// Copies splash video and pre-initializes player so splash shows video immediately.
class SplashVideoPreload {
  SplashVideoPreload._();

  static const _assetPath = 'assets/videos/splash2.mp4';

  static File? _cachedFile;
  static Future<File?>? _future;
  static VideoPlayerController? _initializedController;

  static void start() {
    _future ??= _copy();
  }

  static Future<File?> getFile() async {
    start();
    return _future!;
  }

  /// Call from main() before runApp(). Copies file and initializes video so splash has no delay.
  static Future<void> prepareVideo() async {
    final file = await getFile();
    if (file == null || !file.existsSync()) return;
    try {
      final ctrl = VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await ctrl.initialize();
      ctrl.setLooping(true);
      ctrl.play();
      _initializedController = ctrl;
    } catch (e) {
      debugPrint('SplashVideoPreload prepareVideo: $e');
    }
  }

  /// Splash screen takes ownership of the pre-initialized controller (call once in initState).
  static VideoPlayerController? takeInitializedController() {
    final ctrl = _initializedController;
    _initializedController = null;
    return ctrl;
  }

  static Future<File?> _copy() async {
    if (_cachedFile != null && _cachedFile!.existsSync()) return _cachedFile;
    try {
      final data = await rootBundle.load(_assetPath);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/splash2.mp4');
      await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
      _cachedFile = file;
      return file;
    } catch (e) {
      debugPrint('SplashVideoPreload: $e');
      try {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/splash2.mp4');
        final data = await rootBundle.load(_assetPath);
        await file.writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
        _cachedFile = file;
        return file;
      } catch (e2) {
        debugPrint('SplashVideoPreload fallback: $e2');
        return null;
      }
    }
  }
}