import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const String _appVersion = '1.0.0';

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
          'About Us',
          style: GoogleFonts.openSans(
            fontSize: 18,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
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
                    //const SizedBox(height: 60),
                    _buildHeaderCard(),
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'About ZAROOORI',
                      children: [
                        _buildParagraph(
                          'ZAROOORI is a comprehensive vehicle services and marketplace platform built to simplify everything related to vehicles — for users and automotive businesses alike.',
                        ),
                        const SizedBox(height: 12),
                        _buildParagraph(
                          'From buying or selling vehicles to emergency assistance, spare parts, garages, insurance, rentals, and more, ZAROOORI brings the entire automotive ecosystem together under one powerful, easy-to-use digital platform.',
                        ),
                        const SizedBox(height: 12),
                        _buildParagraph(
                          'Our goal is simple: Make vehicle-related services transparent, accessible, and stress-free for everyone.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'What We Do',
                      children: [
                        _buildBulletItem('Vehicle owners'),
                        _buildBulletItem('Dealers & sellers'),
                        _buildBulletItem('Garages & mechanics'),
                        _buildBulletItem('Service providers'),
                        _buildBulletItem('Product and spare-part sellers'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'Our Vision',
                      children: [
                        _buildParagraph(
                          'To become India\'s most trusted and comprehensive digital automotive ecosystem — where every vehicle-related need is solved through one simple, transparent platform.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'Our Mission',
                      children: [
                        _buildBulletItem('To simplify vehicle ownership'),
                        _buildBulletItem(
                          'To eliminate overpricing and confusion',
                        ),
                        _buildBulletItem(
                          'To empower small and large automotive businesses digitally',
                        ),
                        _buildBulletItem(
                          'To build trust through transparency and technology',
                        ),
                      ],
                    ),
                       const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'Why ZAROOORI?',
                      children: [
                        _buildParagraph('Because vehicle problems shouldn\'t be complicated, because finding the right service shouldn\'t be stressful.'),
                        _buildParagraph(
                          'Because transparency should be the standard - not the exception.',
                        ),
                        _buildParagraph(
                          'ZAROOORI is not just an app.',
                        ),
                        _buildParagraph(
                          'It\'s your complete vehicle partner.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildVersionFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration:
          PremiumDecorations.card(
            backgroundColor: const Color(0xFFFFFDE7),
            border: Border.all(
              color: PremiumDecorations.cardBorder.withValues(alpha: 0.9),
              width: 1.5,
            ),
          ).copyWith(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.7),
                blurRadius: 0,
                offset: const Offset(0, -1),
              ),
            ],
          ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFF8E1),
                  Color(0xFFFFF59D),
                  Color(0xFFFFB74D),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.4),
                  blurRadius: 0,
                  offset: const Offset(-1, -1),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.directions_car_rounded,
                size: 36,
                color: AppColors.black.withValues(alpha: 0.85),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ZAROOORI',
                  style:  GoogleFonts.openSans(
                    fontSize: 17,
                    color: AppColors.black,
                  fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
                const SizedBox(height: 6),
                Text(
                  'One App. Every Vehicle Need.',
                  style: AppTextStyles.textView(
                    size: 12,
                    color: AppColors.gray,
                  ).copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String sectionTitle,
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
            _buildSectionTitle(sectionTitle),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.openSans(
        fontSize: 11,
        color: Colors.black.withValues(alpha: 0.6),
      ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 1.2),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: 14,
        color: AppColors.black,
      height: 1.5, fontWeight: FontWeight.w500,
      )
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

  Widget _buildVersionFooter() {
    return Center(
      child: Text(
        'Version $_appVersion',
        style: AppTextStyles.textView(
          size: 12,
          color: AppColors.black.withValues(alpha: 0.5),
        ).copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}