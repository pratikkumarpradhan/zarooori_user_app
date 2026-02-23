import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  static const String _supportEmail = 'zarooori.com';
  static const String _websiteUrl = 'https://zarooori.com';

  Future<void> _launchUrl(BuildContext context, String url) async {
    if (!context.mounted) return;
    final uri = Uri.parse(url);
    try {
      final useBrowser = url.startsWith('http://') || url.startsWith('https://');
      final mode = useBrowser ? LaunchMode.externalApplication : LaunchMode.platformDefault;
      bool launched = false;
      try {
        launched = await launchUrl(uri, mode: mode);
      } catch (_) {
        try {
          launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (_) {}
      }
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open. Please try again.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black87,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open link. Please try again.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black87,
          ),
        );
      }
    }
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

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: GoogleFonts.openSans(
        fontSize: 14,
        color: AppColors.black,
        fontWeight: FontWeight.w500
      ).copyWith(height: 1.5, ),
    );
  }

  Widget _buildContactIntroCard() {
    return _buildSectionCard(
      sectionTitle: 'Get in touch',
      children: [
        _buildParagraph(
          'ZAROOORI is a digital marketplace platform that connects users with independent dealers, service providers, garages, mechanics, sellers, and other automotive businesses. ZAROOORI itself does not own, manufacture, sell, repair, transport, or service vehicles, spare parts, or equipment listed on the platform. All services, products, quotations, prices, timelines, and offers displayed on the platform are provided directly by third-party',
        ),
        const SizedBox(height: 12),
        _buildParagraph(
          'service providers and sellers. ZAROOORI does not guarantee the accuracy, quality, pricing, availability, or performance of any service or product listed on the platform.',
        ),
        const SizedBox(height: 12),
        _buildParagraph(
          'Users are advised to independently verify service details, pricing, terms, warranties, and credentials of dealers or service providers before proceeding with any transaction. Any agreement, service delivery, or transaction entered into is solely between the user and the respective service provider or seller. ZAROOORI shall not be held responsible or liable for:',
        ),
        const SizedBox(height: 12),
        _buildParagraph('Service delays, cancellations, or non-performance'),
        const SizedBox(height: 12),
        _buildParagraph('Quality of products or services delivered'),
        const SizedBox(height: 12),
        _buildParagraph('Pricing disputes or payment-related issues'),
        const SizedBox(height: 12),
        _buildParagraph(
          'Damages, losses, accidents, or injuries arising from services availed Actions or omissions of third-party providers',
        ),
        const SizedBox(height: 12),
        _buildParagraph(
          'Emergency and medical services listed on the platform are provided by independent third parties. ZAROOORI does not guarantee response times, outcomes, or service availability during emergency situations. While ZAROOORI strives to onboard verified dealers and service providers, verification does not imply endorsement or warranty of their services. User ratings, reviews, and listings are provided for informational purposes only. By using the ZAROOORI app or website, users acknowledge and agree to this disclaimer and accept full responsibility for their decisions and transactions made through the platform.',
        ),
      ],
    );
  }

  Widget _buildContactRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required String url,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchUrl(context, url),
        borderRadius: BorderRadius.circular(16),
        splashColor: const Color(0xFFFFD600).withValues(alpha: 0.3),
        highlightColor: const Color(0xFFFFF59D).withValues(alpha: 0.2),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: PremiumDecorations.input(
            fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
          ).copyWith(
            border: Border.all(color: const Color(0xFFFFD600), width: 2),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: AppColors.black.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.textView(
                        size: 11,
                        color: Colors.black.withValues(alpha: 0.65),
                      ).copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: AppTextStyles.textView(
                        size: 14,
                        color: AppColors.black,
                      ).copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFFF57C00),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.black.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Container(
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Contact Us'),
            const SizedBox(height: 14),
            _buildContactRow(
              context: context,
              icon: Icons.email_outlined,
              label: 'Email Support',
              value: _supportEmail,
              url: 'mailto:$_supportEmail',
            ),
            const SizedBox(height: 14),
            _buildContactRow(
              context: context,
              icon: Icons.language_rounded,
              label: 'Website',
              value: _websiteUrl.replaceFirst('https://', ''),
              url: _websiteUrl,
            ),
          ],
        ),
      ),
    );
  }

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
            icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          'Contact Us',
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
            Positioned.fill(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //const SizedBox(height: 60),
                      _buildContactIntroCard(),
                      const SizedBox(height: 18),
                      _buildContactCard(context),
                      const SizedBox(height: 24),
                    ],
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