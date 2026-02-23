import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWidget extends StatelessWidget {
  final String userName;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;
  final VoidCallback onLanguageTap;

  const HeaderWidget({
    super.key,
    required this.userName,
    required this.onMenuTap,
    required this.onNotificationTap,
    required this.onLanguageTap,
  });

  /// 🔹 Glass Icon Button
  Widget glassIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.4)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.black, size: 20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF59D), Color(0xFFFFEB3B)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Transform.translate(
        offset: const Offset(0, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ☰ Glass Menu Button
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: GestureDetector(
                  onTap: onMenuTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.35)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.menu_rounded,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// 👤 Username + Welcome
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                       letterSpacing: 0.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Welcome to Zarooori",
                    style: GoogleFonts.openSans(
                      fontSize: 11,
                      //fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            /// 🔔 💼 🌐 Glass Action Icons
            glassIcon(Icons.notifications_outlined, onNotificationTap),
            glassIcon(Icons.account_balance_wallet_outlined, () {}),
            glassIcon(Icons.language, onLanguageTap),
          ],
        ),
      ),
    );
  }
}