// terms_and_conditions_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
          'Terms & Conditions',
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
              bottom: 220,
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // const SizedBox(height: 60),

                    // _buildHeaderCard(),

                    // const SizedBox(height: 24),

                    _buildSectionCard(
                      sectionTitle: 'Terms of Use',
                      children: [
                        _buildParagraph(
                          'These Terms of Use govern the access to and use of the Zarooori website and mobile application ("Platform"). The Platform is owned and operated by ZUVION GLOBAL TRADERS PRIVATE LIMITED, a company incorporated under the Companies Act, 2013, having its registered office at 18-13-6/C/4 1/A, Bandlaguda Cross Road, Chandrayangutta, Hyderabad - 500005, India (hereinafter referred to as "Company", "We", "Us", or "Our").',
                        ),
                        const SizedBox(height: 12),
                        _buildParagraph(
                          'For the purpose of these Terms of Use, the terms “You”, “Your”, “Yourself”, or “Buyer” shall mean any natural or legal person who accesses, browses, registers on, or uses the Platform for purchasing items or availing services offered through the Platform.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _buildSectionCard(
                      sectionTitle: 'Acceptance of Terms',
                      children: [
                        _buildParagraph(
                          'These Terms of Use are subject to revision at any time without prior notice. Revised terms will be made available on the Platform, and it is your responsibility to review them periodically.',
                        ),
                        const SizedBox(height: 12),
                        _buildParagraph(
                          'Your continued use of the Platform after any changes shall constitute your acceptance of the revised Terms.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _buildSectionCard(
                      sectionTitle: 'Eligibility to Use',
                      children: [
                        _buildBulletItem('You must be at least 18 years old and legally competent to contract.'),
                        _buildBulletItem('Minors, insolvent persons, or previously suspended users may not use the Platform.'),
                        _buildBulletItem('You represent that you are eligible to use our services.'),
                        _buildBulletItem('We may refuse or terminate access at any time.'),
                        _buildBulletItem('Accounts are non-transferable.'),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _buildSectionCard(
                      sectionTitle: 'Account Registration',
                      children: [
                        _buildBulletItem('Certain features require registration with accurate information.'),
                        _buildBulletItem('You are responsible for keeping your login credentials secure.'),
                        _buildBulletItem('Notify us immediately of any unauthorized access.'),
                        _buildBulletItem('We may suspend or terminate accounts for violations.'),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _buildSectionCard(
                      sectionTitle: 'User Obligations & Conduct',
                      children: [
                        _buildBulletItem('Use the Platform only for lawful purposes.'),
                        _buildBulletItem('Do not interfere with, damage, or misuse the service.'),
                        _buildBulletItem('No hacking, data mining, reverse engineering, or malicious activities.'),
                        _buildBulletItem('Uploaded content must comply with all applicable laws.'),
                        const SizedBox(height: 8),
                        _buildParagraph(
                          'You grant us a worldwide, perpetual, royalty-free license to use content you upload for platform purposes.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _buildSectionCard(
                      sectionTitle: 'Prohibited Activities',
                      children: [
                        _buildBulletItem('Harassment, defamation, impersonation'),
                        _buildBulletItem('Uploading obscene, harmful, or unlawful content'),
                        _buildBulletItem('Introducing viruses or malicious code'),
                        _buildBulletItem('Infringing intellectual property rights'),
                        _buildBulletItem('Interfering with platform security or functionality'),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _buildSectionCard(
                      sectionTitle: 'Intellectual Property',
                      children: [
                        _buildParagraph(
                          'All content, design, logos, and software on the Platform are owned by the Company and protected by law. No unauthorized use or reproduction is permitted.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _buildSectionCard(
                      sectionTitle: 'Disclaimer & Limitation of Liability',
                      children: [
                        _buildParagraph(
                          'The Platform is provided "as is" without any warranties. We are not liable for interruptions, data loss, third-party actions, or indirect/consequential damages.',
                        ),
                        const SizedBox(height: 8),
                        _buildBulletItem('Use of the Platform is at your own risk.'),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _buildSectionCard(
                      sectionTitle: 'Governing Law',
                      children: [
                        _buildParagraph(
                          'These Terms are governed by the laws of India. Disputes shall be subject to the exclusive jurisdiction of courts in Delhi, India.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHeaderCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: PremiumDecorations.card(
  //       backgroundColor: const Color(0xFFFFFDE7),
  //       border: Border.all(
  //         color: PremiumDecorations.cardBorder.withValues(alpha: 0.9),
  //         width: 1.5,
  //       ),
  //     ).copyWith(
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.08),
  //           blurRadius: 24,
  //           offset: const Offset(0, 8),
  //         ),
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.04),
  //           blurRadius: 12,
  //           offset: const Offset(0, 4),
  //         ),
  //         BoxShadow(
  //           color: Colors.white.withValues(alpha: 0.7),
  //           blurRadius: 0,
  //           offset: const Offset(0, -1),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 72,
  //           height: 72,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             gradient: const LinearGradient(
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //               colors: [
  //                 Color(0xFFFFF8E1),
  //                 Color(0xFFFFF59D),
  //                 Color(0xFFFFB74D),
  //               ],
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withValues(alpha: 0.12),
  //                 blurRadius: 20,
  //                 offset: const Offset(0, 6),
  //               ),
  //               BoxShadow(
  //                 color: Colors.white.withValues(alpha: 0.4),
  //                 blurRadius: 0,
  //                 offset: const Offset(-1, -1),
  //               ),
  //             ],
  //           ),
  //           child: const Center(
  //             child: Icon(
  //               Icons.description_rounded,
  //               size: 38,
  //               color: AppColors.black,
  //             ),
  //           ),
  //         ),
  //         // const SizedBox(width: 18),
  //         // Expanded(
  //         //   child: Column(
  //         //     crossAxisAlignment: CrossAxisAlignment.start,
  //         //     children: [
  //         //       Text(
  //         //         'Terms & Conditions',
  //         //         style: GoogleFonts.openSans(
  //         //           fontSize: 19,
  //         //           color: AppColors.black,
  //         //           fontWeight: FontWeight.w800,
  //         //           letterSpacing: 0.4,
  //         //         ),
  //         //       ),
  //         //       const SizedBox(height: 6),
  //         //       Text(
  //         //         'Last updated: February 2026',
  //         //         style: AppTextStyles.textView(
  //         //           size: 12,
  //         //           color: AppColors.gray,
  //         //         ).copyWith(fontWeight: FontWeight.w600),
  //         //       ),
  //         //     ],
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

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
      style: AppTextStyles.textView(
        size: 11,
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
              decoration: const BoxDecoration(
                color: Color(0xFFFFB300),
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
              ).copyWith(height: 1.5, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}