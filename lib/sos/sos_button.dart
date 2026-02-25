import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/sos/sos_service.dart';

class SosFloatingButton extends StatefulWidget {
  const SosFloatingButton({super.key});

  @override
  State<SosFloatingButton> createState() => _SosFloatingButtonState();
}

class _SosFloatingButtonState extends State<SosFloatingButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.99, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    HapticFeedback.heavyImpact();
    try {
      await SosService.sendSOSToTrustedContacts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SOS sent successfully from server to your trusted one'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send SOS: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const buttonSize = 70.0;
    const waveSize = 140.0;

    return SizedBox(
      width: waveSize,
      height: waveSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(waveSize, waveSize),
                  painter: _BoxRipplePainter(
                    progress: _waveController.value,
                    baseSize: buttonSize,
                    color: const Color(0xFFC62828),
                  ),
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: child,
              );
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _onTap,
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                splashColor: Colors.white.withValues(alpha: 0.35),
                highlightColor: Colors.white.withValues(alpha: 0.12),
                child: Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: const Color(0xFFC62828).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 2),
                        spreadRadius: -2,
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, -1),
                        spreadRadius: 0,
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 3,
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment(-0.6, -1.0),
                      end: Alignment(0.7, 1.0),
                      colors: [
                        Color(0xFFFF9A9A),
                        Color(0xFFF76C6C),
                        Color(0xFFE84A4A),
                        Color(0xFFD32F2F),
                        Color(0xFFC62828),
                        Color(0xFFB71C1C),
                      ],
                      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Premium gloss overlay
                      Positioned(
                        top: 0,
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.55),
                                Colors.white.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.05),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.4, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Inner highlight edge
                      Positioned(
                        top: 2,
                        left: 8,
                        right: 8,
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_active_rounded,
                              color: Colors.white,
                              size: 22,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Madad',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 11,
                               fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                                height: 1.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws expanding rounded-rectangle (box) ripples emanating from center.
class _BoxRipplePainter extends CustomPainter {
  final double progress;
  final double baseSize;
  final Color color;

  _BoxRipplePainter({
    required this.progress,
    required this.baseSize,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const waveCount = 3;
    const maxExpand = 1.8;
    const borderRadius = 16.0;

    for (var i = 0; i < waveCount; i++) {
      final adjusted = (progress + (i / waveCount)) % 1.0;
      final scale = 1.0 + (maxExpand - 1.0) * adjusted;
      final currentSize = baseSize * scale;

      // Opacity fades as ripple expands
      final opacity = (1 - adjusted) * (1 - adjusted) * 0.35;

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: currentSize,
          height: currentSize,
        ),
        Radius.circular(borderRadius * scale),
      );

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BoxRipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}