import 'package:flutter/material.dart';

/// Soft circular decorative bubble used on profile-related screens.
class ProfileBubble extends StatelessWidget {
  final double size;
  final Color color;
  final Alignment highlightCenter;

  const ProfileBubble({
    super.key,
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
            color: color.withValues(alpha: 0.16),
            blurRadius: size * 0.22,
            spreadRadius: 0,
          ),
        ],
        gradient: RadialGradient(
          center: highlightCenter,
          radius: 0.9,
          colors: [
            Colors.white.withValues(alpha: 0.5),
            yellow.withValues(alpha: 0.55),
            goldenYellow.withValues(alpha: 0.6),
            color.withValues(alpha: 0.55),
            color.withValues(alpha: 0.35),
            color.withValues(alpha: 0.16),
          ],
          stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
        ),
      ),
    );
  }
}