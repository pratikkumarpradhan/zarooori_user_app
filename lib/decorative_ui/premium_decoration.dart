import 'package:flutter/material.dart';

/// Premium-style decorations for cards, inputs, and buttons across Zarooori screens.
class PremiumDecorations {
  PremiumDecorations._();

  static const Color cardBackground = Color(0xFFFFF8E1);
  static const Color cardBorder = Color(0xFFFFE082);
  static const Color inputFill = Color(0xFFFFF59D);
  static const Color primaryButton = Color(0xFFFFB300);
  static const Color primaryButtonBorder = Color(0xFFF57C00);

  /// Premium card: layered shadow, soft border, 24px radius.
  static BoxDecoration card({
    Color? backgroundColor,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? cardBackground,
      borderRadius: BorderRadius.circular(24),
      border: border ??
          Border.all(
            color: cardBorder.withValues(alpha: 0.85),
            width: 1.5,
          ),
      boxShadow: boxShadow ??
          [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 28,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.6),
              blurRadius: 0,
              offset: const Offset(0, -1),
              spreadRadius: 0,
            ),
          ],
    );
  }

  /// Premium input/textarea container (for dropdowns and custom fields).
  static BoxDecoration input({
    Color? fillColor,
  }) {
    return BoxDecoration(
      color: fillColor ?? inputFill.withValues(alpha: 0.65),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: cardBorder.withValues(alpha: 0.7),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.5),
          blurRadius: 0,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  /// InputDecoration for TextField with premium look (enabled + focused borders).
  static InputDecoration textField({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
    int maxLines = 1,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.black.withValues(alpha: 0.4),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.black.withValues(alpha: 0.6),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: inputFill.withValues(alpha: 0.65),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: cardBorder.withValues(alpha: 0.6),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: primaryButtonBorder,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Colors.red.shade400,
          width: 1.5,
        ),
      ),
    );
  }

  /// Primary action button style (elevation, gradient, border).
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryButton,
        foregroundColor: Colors.black,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: BorderSide(
          color: primaryButtonBorder.withValues(alpha: 0.9),
          width: 1.5,
        ),
      );
}