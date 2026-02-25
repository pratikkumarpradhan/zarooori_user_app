import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:zarooori_user/Authentication/login_screen.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/main_home_page/home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressWidth;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    // Natural loading: fast start → slow → medium → slow near end
    _progressWidth = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.38,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.38,
          end: 0.52,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 32,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.52,
          end: 0.78,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 28,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.78,
          end: 0.92,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 14,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.92,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 8,
      ),
    ]).animate(_progressController);
    _progressController.forward();
    // Start video initialization immediately - no delay
    _initVideo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateAfterSplash();
    });
  }

  static const List<String> _videoAssetPaths = ['assets/videos/splash.mp4'];

  Future<void> _initVideo() async {
    if (!mounted) return;
    await _disposeVideoControllers();

    for (final path in _videoAssetPaths) {
      if (!mounted) return;

      try {
        // Load asset - catch and handle errors explicitly
        ByteData data;
        try {
          data = await rootBundle.load(path);
        } catch (e) {
          // Asset not found - try next path
          continue;
        }

        if (!mounted || data.lengthInBytes == 0) return;

        // Get directory - prefer temp directory for release builds
        Directory dir;
        try {
          dir = await getTemporaryDirectory();
        } catch (_) {
          try {
            dir = await getApplicationDocumentsDirectory();
          } catch (_) {
            continue;
          }
        }

        if (!mounted) return;

        final fileName = path.split('/').last;
        final file = File('${dir.path}/$fileName');

        // Check if file exists and is valid
        bool shouldWrite = true;
        if (file.existsSync()) {
          try {
            final existingSize = await file.length();
            if (existingSize == data.lengthInBytes && existingSize > 0) {
              shouldWrite = false;
            } else {
              await file.delete();
            }
          } catch (_) {
            try {
              await file.delete();
            } catch (_) {}
          }
        }

        // Write file if needed
        if (shouldWrite) {
          try {
            final bytes = data.buffer.asUint8List(
              data.offsetInBytes,
              data.lengthInBytes,
            );
            await file.writeAsBytes(bytes, flush: true);

            // Verify write
            if (!file.existsSync()) continue;
            final writtenSize = await file.length();
            if (writtenSize != data.lengthInBytes || writtenSize == 0) continue;
          } catch (_) {
            continue;
          }
        }

        if (!mounted) return;

        // Try to play - simplified approach
        final ok = await _playFromFile(file);
        if (ok && mounted) {
          return;
        }
      } catch (_) {
        continue;
      }
    }
  }

  Future<bool> _playFromFile(File file) async {
    if (!mounted || !file.existsSync()) return false;

    // Verify file is readable and has content
    try {
      final fileSize = await file.length();
      if (fileSize == 0) return false;
    } catch (_) {
      return false;
    }

    VideoPlayerController? ctrl;
    try {
      ctrl = VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      // Initialize
      await ctrl.initialize().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw Exception('Video initialization timeout');
        },
      );

      if (!mounted || !ctrl.value.isInitialized || ctrl.value.hasError) {
        await ctrl.dispose();
        return false;
      }

      // Set up controller
      ctrl.addListener(_videoListener);
      ctrl.setLooping(true);

      // Set controller immediately
      _videoController = ctrl;
      _videoReady = true;

      // Update UI first
      if (mounted) {
        setState(() {});
      }

      // Try Chewie, but don't fail if it doesn't work
      if (mounted) {
        try {
          final chewie = ChewieController(
            videoPlayerController: ctrl,
            showControls: false,
            autoPlay: true,
            looping: true,
            allowFullScreen: false,
            allowMuting: false,
            errorBuilder: (_, __) => const SizedBox.shrink(),
          );
          _chewieController = chewie;
          if (mounted) setState(() {});
        } catch (_) {
          // Chewie failed, but VideoPlayer will work
          _chewieController = null;
        }
      }

      // Start playing
      if (mounted) {
        await ctrl.play();
        // Give it a moment to start
        await Future.delayed(const Duration(milliseconds: 300));

        // Update UI again after play starts
        if (mounted && ctrl.value.isInitialized) {
          setState(() {});
        }

        return true;
      }

      return false;
    } catch (e) {
      ctrl?.removeListener(_videoListener);
      await ctrl?.dispose();
      return false;
    }
  }

  Future<void> _disposeVideoControllers() async {
    _videoController?.removeListener(_videoListener);
    _chewieController?.dispose();
    _chewieController = null;
    _videoController?.dispose();
    _videoController = null;
    _videoReady = false;
  }

  void _videoListener() {
    if (_videoController != null && mounted) {
      if (_videoController!.value.isInitialized) {
        if (!_videoReady) {
          _videoReady = true;
        }
        setState(() {});
      } else if (_videoController!.value.hasError) {
        // Video has error, try to recover or show fallback
        setState(() {});
      }
    }
  }

  Widget _buildVideoCard() {
    // If video controller exists and is initialized (even if not playing yet), show it
    if (_videoController != null &&
        _videoController!.value.isInitialized &&
        !_videoController!.value.hasError) {
      final aspectRatio = _videoController!.value.aspectRatio > 0
          ? _videoController!.value.aspectRatio
          : 16 / 9;

      // Try Chewie first if available
      if (_chewieController != null) {
        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: 260 * aspectRatio,
              height: 260,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Chewie(controller: _chewieController!),
              ),
            ),
          ),
        );
      }

      // Direct VideoPlayer - this should always work if controller is initialized
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 260 * aspectRatio,
            height: 260,
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
        ),
      );
    }

    // Show black container while loading
    return Container(color: Colors.black);
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(milliseconds: 4000));
    if (!mounted) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (!mounted) return;
      if (user != null) {
        Get.offAll(
          () => const HomeScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      } else {
        Get.offAll(
          () => const LoginScreen(),
          transition: Transition.fade,
          duration: const Duration(milliseconds: 500),
        );
      }
    } catch (_) {
      if (!mounted) return;
      Get.offAll(
        () => const LoginScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFD600),
              Color(0xFFFFEA00),
              Color(0xFFFFF176),
              Color(0xFFFFE082),
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Bubble-like decorative elements (same as home screen)
            Positioned(
              top: 40,
              left: -30,
              child: _SplashBubbleWidget(
                size: 140,
                color: const Color(0xFFFF9800),
                highlightCenter: const Alignment(-0.35, -0.35),
              ),
            ),
            Positioned(
              top: 140,
              right: -40,
              child: _SplashBubbleWidget(
                size: 110,
                color: const Color(0xFFF57C00),
                highlightCenter: const Alignment(-0.4, -0.3),
              ),
            ),
            Positioned(
              top: 350,
              left: 60,
              child: _SplashBubbleWidget(
                size: 70,
                color: const Color(0xFFFFB74D),
                highlightCenter: const Alignment(-0.3, -0.4),
              ),
            ),
            Positioned(
              bottom: 220,
              right: 40,
              child: _SplashBubbleWidget(
                size: 100,
                color: const Color(0xFFFF9800),
                highlightCenter: const Alignment(-0.3, -0.35),
              ),
            ),
            Positioned(
              bottom: 120,
              left: -50,
              child: _SplashBubbleWidget(
                size: 150,
                color: const Color(0xFFF57C00),
                highlightCenter: const Alignment(-0.35, -0.3),
              ),
            ),
            Positioned(
              bottom: 70,
              right: -20,
              child: _SplashBubbleWidget(
                size: 65,
                color: const Color(0xFFFF9800),
                highlightCenter: const Alignment(-0.4, -0.35),
              ),
            ),
            Positioned(
              top: 180,
              left: 130,
              child: _SplashBubbleWidget(
                size: 105,
                color: const Color(0xFFFF9800),
                highlightCenter: const Alignment(-0.35, -0.3),
              ),
            ),
            Positioned(
              bottom: -20,
              left: MediaQuery.of(context).size.width * 0.42,
              child: _SplashBubbleWidget(
                size: 130,
                color: const Color(0xFFFF9800),
                highlightCenter: const Alignment(-0.35, -0.35),
              ),
            ),
            // Main content
            SafeArea(
              child: Transform.translate(
                offset: const Offset(0, -30),
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo / hero image – small card, image centred inside
                          Container(
                            height: 120,
                            width: 300, // 👈 fixed width prevents layout jump
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.55),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
    borderRadius: BorderRadius.circular(20), // 👈 corner radius
    child: Image.asset(
      'assets/images/app_icon.png',
      height: 110,
      fit: BoxFit.contain,
    ),
  ),
                          ),
                          const SizedBox(height: 8),
                          // Tagline (compact height)
                          AnimatedTextKit(
                            totalRepeatCount: 1,
                            isRepeatingAnimation: false,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'All in One Automobile Solution',
                                textStyle:
                                    GoogleFonts.openSans(
                                      fontSize: 18,
                                      color: AppColors.black,
                                    ).copyWith(
                                      letterSpacing: 0.3,
                                      fontWeight: FontWeight.w600,
                                    ),
                                speed: const Duration(milliseconds: 90),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          // ── TYRE SLIDING + LOADING ──
                          const SizedBox(
                            height: 32,
                          ), // space before the animation area

                          SizedBox(
                            height:
                                160, // adjust height of this container (tyre + some padding)
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Optional: subtle track / road line effect (visual cue that it's moving)
                                Positioned(
                                  bottom: 30,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.grey.withOpacity(0.1),
                                          Colors.grey.withOpacity(0.4),
                                          Colors.grey.withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),

                                // Sliding tyre
                                AnimatedBuilder(
                                  animation: _progressController,
                                  builder: (context, child) {
                                    // Slide from ~10% left to ~90% right
                                    final progress = _progressWidth.value.clamp(
                                      0.0,
                                      1.0,
                                    );
                                   final leftOffset =
    -50 +
    (MediaQuery.of(context).size.width - 140 - 50) *
        progress *
        1.4; // 🔥 speed increase
                                    return Positioned(
                                      left: leftOffset,
                                      child: Transform.rotate(
                                        angle:
                                            _progressController.value *
                                            10 *
                                            3.1416,
                                        // 🔥 multiplier adjust for faster/slower rotation
                                        child: child!,
                                      ),
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/images/splash2.png',
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // // Progress bar + text (centered below the sliding area)
                          // AnimatedBuilder(
                          //   animation: _progressController,
                          //   builder: (context, child) {
                          //     return Column(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         SizedBox(
                          //           width: 300,           // fixed width so it looks balanced
                          //           child: ClipRRect(
                          //             borderRadius: BorderRadius.circular(8),
                          //             child: LinearProgressIndicator(
                          //               value: _progressWidth.value,
                          //               backgroundColor: Colors.black.withOpacity(0.12),
                          //               valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF57C00)),
                          //               minHeight: 8,
                          //             ),
                          //           ),
                          //         ),
                          //         const SizedBox(height: 12),
                          //         // Text(
                          //         //   'Loading...',
                          //         //   style: AppTextStyles.textView(
                          //         //     size: 14,
                          //         //     color: AppColors.black.withOpacity(0.75),
                          //         //     //fontWeight: FontWeight.w500,
                          //         //   ),
                          //         // ),
                          //       ],
                          //     );
                          //   },
                          // ),
                          // Optional: small centered status text (very subtle)
                          AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, _) {
                              final progress = _progressWidth.value;
                              String status = progress < 0.3
                                  ? 'Preparing...'
                                  : progress < 0.7
                                  ? 'Rolling in...'
                                  : 'Almost there...';

                              return Opacity(
                                opacity: 0.7,
                                child: Text(
                                  status,
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: AppColors.black.withOpacity(0.65),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Same volumetric bubble as home screen - keeps splash UI consistent.
class _SplashBubbleWidget extends StatelessWidget {
  final double size;
  final Color color;
  final Alignment highlightCenter;

  const _SplashBubbleWidget({
    required this.size,
    required this.color,
    this.highlightCenter = const Alignment(-0.35, -0.35),
  });

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFFFD54F);
    const goldenYellow = Color(0xFFFFB74D);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: size * 0.2,
            spreadRadius: 0,
          ),
        ],
        gradient: RadialGradient(
          center: highlightCenter,
          radius: 0.9,
          colors: [
            Colors.white.withValues(alpha: 0.45),
            yellow.withValues(alpha: 0.5),
            goldenYellow.withValues(alpha: 0.55),
            color.withValues(alpha: 0.5),
            color.withValues(alpha: 0.35),
            color.withValues(alpha: 0.15),
          ],
          stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
        ),
      ),
    );
  }
}
