import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  // bool _isLoading = true;
  // late final WebViewController _webController;

  // @override
  // void initState() {
  //   super.initState();
  //   _webController = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onPageStarted: (_) {
  //           if (mounted) setState(() => _isLoading = true);
  //         },
  //         onPageFinished: (_) {
  //           if (mounted) setState(() => _isLoading = false);
  //         },
  //         onWebResourceError: (_) {
  //           if (mounted) setState(() => _isLoading = false);
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse('https://aswack.com/privacy.php'));
  // }

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
          'Privacy Policy',
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
                    //const SizedBox(height: 60),
                    //_buildHeaderCard(),
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'Privacy Policy',
                      children: [
                        _buildParagraph(
                          'Last Updated: 25th December 2025 — ZAROOORI (“we”, “our”, “us”) respects your privacy and is committed to protecting the personal information of users (“you”, “your”). This Privacy Policy explains how we collect, use, store, share, and protect your information when you use the ZAROOORI mobile application, website, and related services (collectively, the “Platform”). By accessing or using ZAROOORI, you agree to the collection and use of information in accordance with this Privacy Policy.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'Information We Collect',
                      children: [
                        _buildParagraph(
                          'a) Personal Information When you register or use the platform, we may collect:',
                        ),
                        _buildBulletItem('Name'),
                        _buildBulletItem('Mobile number'),
                        _buildBulletItem('Email address'),
                        _buildBulletItem('Location (city/area) '),
                        _buildBulletItem('Vehicle-related details (optional)'),
                        const SizedBox(height: 12),
                        _buildParagraph(
                          'b) Business Information (Dealers / Service Providers)',
                        ),
                        _buildBulletItem('Business name'),
                        _buildBulletItem('Contact details'),
                        _buildBulletItem('Service categories'),
                        _buildBulletItem('Listings, offers, pricing details'),
                        _buildBulletItem('Uploaded images and descriptions'),
                        const SizedBox(height: 12),

                        _buildParagraph('c) Usage & Technical Information'),
                        _buildBulletItem(
                          'Device information (model, OS version)',
                        ),
                        _buildBulletItem('App usage data'),
                        _buildBulletItem('IP address'),
                        _buildBulletItem('Log data and analytics'),
                        _buildBulletItem('Crash reports'),
                        const SizedBox(height: 12),
                        _buildParagraph('d) Location Information'),
                        _buildParagraph(
                          'We may collect approximate or real-time location data (with your permission) to:',
                        ),
                        _buildBulletItem('Show nearby services'),
                        _buildBulletItem('Enable emergency assistance'),
                        _buildBulletItem('Improve service accuracy'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'How We Use Your Information',
                      children: [
                        _buildParagraph('We use collected information to:'),
                        _buildBulletItem(
                          'Provide and improve platform services',
                        ),
                        _buildBulletItem(
                          'Connect users with relevant dealers and service providers',
                        ),
                        _buildBulletItem(
                          'Enable RFQ (Request For Quotation) functionality',
                        ),
                        _buildBulletItem(
                          'Facilitate emergency and service requests',
                        ),
                        _buildBulletItem(
                          'Communicate updates, offers, and notifications',
                        ),
                        _buildBulletItem(
                          'Ensure platform security and prevent misuse',
                        ),
                        _buildBulletItem('Comply with legal obligations'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'RFQ & Communication',
                      children: [
                        _buildParagraph('When a user raises an RFQ:'),
                        _buildBulletItem(
                          'Relevant details are shared with matching dealers/service providers',
                        ),
                        _buildBulletItem(
                          'Dealers respond directly with quotations',
                        ),
                        _buildBulletItem(
                          'ZAROOORI does not control dealer responses or pricing',
                        ),
                        _buildParagraph(
                          'Communication between users and service providers may occur via the platform or external contact methods shared voluntarily.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'Sharing of Information',
                      children: [
                        _buildParagraph('We may share your information:'),
                        _buildBulletItem('With dealers, service providers, or sellers to fulfil your request'),
                        _buildBulletItem('With third-party service partners for analytics, notifications, or hosting'),
                        _buildBulletItem('When required by law, regulation, or legal process'),
                        _buildParagraph('We do not sell or rent your personal data to third parties for marketing purposes.'),
                      ],
                    ),
                       const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'Data Storage & Security',
                      children: [

                        _buildBulletItem('We implement reasonable security measures to protect your data'),
                        _buildBulletItem('Data is stored on secure servers'),
                        _buildBulletItem('Access is restricted to authorised personnel only'),
                        _buildParagraph('However, no digital platform can guarantee 100% security.'),
                      ],
                    ),
                       const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'User Responsibilities',
                      children: [
                        _buildParagraph('Users are responsible for:'),
                      
                        _buildBulletItem('Maintaining confidentiality of their login credentials'),
                        _buildBulletItem('Ensuring accuracy of information shared'),
                        _buildBulletItem('Interactions and transactions with third-party providers'),
                        _buildParagraph('ZAROOORI is not responsible for data shared outside the platform by users.'),
                      ],
                    ),
                       const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'Third-Party Services & Links',
                      children: [
                        _buildParagraph('The platform may contain links to third-party websites or services. ZAROOORI is not responsible for the privacy practices of external platforms. We encourage users to review third-party privacy policies independently.'),
           
                      ],
                    ),
                       const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'Children’s Privacy',
                      children: [
                        _buildParagraph('ZAROOORI is not intended for users under the age of 18. We do not knowingly collect personal data from minors.'),
                 
                      ],
                    ),
                       const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'Your Rights',
                      children: [
                        _buildParagraph('You may:'),
                      
                        _buildBulletItem('Access or update your personal information'),
                        _buildBulletItem('Request deletion of your account (subject to legal requirements)'),
                        _buildBulletItem('Opt out of non-essential communications'),
                        _buildParagraph('Requests can be made via the contact details below.'),
                      ],
                    ),
                       const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: 'Changes to This Privacy Policy',
                      children: [
                        _buildParagraph('We may update this Privacy Policy from time to time. Any changes will be reflected on this page with an updated “Last Updated” date. Continued use of the platform indicates acceptance of the updated policy.'),
                     
                      ],
                    ),
                       const SizedBox(height: 18),
                    _buildSectionCard(
                      sectionTitle: '	Contact Us',
                      children: [
                        _buildParagraph('If you have any questions or concerns regarding this Privacy Policy, please contact us at:'),
                    
                        _buildParagraph('Website: [zarooori.com]'),
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
