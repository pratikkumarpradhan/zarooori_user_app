import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFFFF59D).withValues(alpha: 0.9),
              padding: const EdgeInsets.all(8),
            ),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          "FAQ's",
          style: GoogleFonts.openSans(
            fontSize: 18,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            // ── same gradient + bubbles as other screens ──
            Positioned.fill(
              child: Container(
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
              ),
            ),
            const Positioned(
              top: -40,
              right: -30,
              child: ProfileBubble(size: 140, color: Color(0xFFFF9800)),
            ),
            const Positioned(
              top: 140,
              left: -40,
              child: ProfileBubble(size: 110, color: Color(0xFFF57C00)),
            ),
            const Positioned(
              bottom: 200,
              right: -20,
              child: ProfileBubble(size: 90, color: Color(0xFFFF9800)),
            ),
            const Positioned(
              bottom: -60,
              left: -40,
              child: ProfileBubble(size: 180, color: Color(0xFFF57C00)),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      // sectionTitle: 'Privacy Policy',
                      children: [
                        _buildBulletItem(
                          'How to Change my Photo from Admin Dashboard?',
                        ),
                        _buildParagraph(
                          'Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      // sectionTitle: 'Information We Collect',
                      children: [
                        _buildBulletItem('How to Change my Password easily?'),
                        _buildParagraph(
                          'Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      // sectionTitle: 'How We Use Your Information',
                      children: [
                        _buildBulletItem(
                          'How to Change my Subscription Plan using PayPal',
                        ),
                        _buildParagraph(
                          'Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    // required String sectionTitle,
    required List<Widget> children,
  }) {
    return Container(
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //_buildSectionTitle(sectionTitle),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // Widget _buildSectionTitle(String title) {
  //   return Text(
  //     title.toUpperCase(),
  //     style: GoogleFonts.openSans(
  //       fontSize: 11,
  //       color: Colors.black.withValues(alpha: 0.6),
  //     ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 1.2),
  //   );
  // }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: 14,
        color: AppColors.black,
        height: 1.5,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB300),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.openSans(
                fontSize: 14,
                color: AppColors.black,
              ).copyWith(height: 1.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
