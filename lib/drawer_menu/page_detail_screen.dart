// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import '../../utils/app_colors.dart';
// import '../../utils/app_text_styles.dart';
// import '../../utils/premium_decorations.dart';
// import 'profile_bubble.dart';

// class PageDetailScreen extends StatefulWidget {
//   final String pageNo;

//   const PageDetailScreen({super.key, required this.pageNo});

//   @override
//   State<PageDetailScreen> createState() => _PageDetailScreenState();
// }

// class _PageDetailScreenState extends State<PageDetailScreen> {
//   bool _isLoading = true;
//   WebViewController? _webController;

//   static const Map<String, String> _titles = {
//     '2': 'Contact Us',
//     '3': 'Privacy Policy',
//     '4': 'Terms and Condition',
//   };
//   static const Map<String, String> _urls = {
//     '2': 'https://aswack.com/contact.php',
//     '3': 'https://aswack.com/privacy.php',
//     '4': 'https://aswack.com/terms.php',
//   };

//   static const String _supportEmail = 'zarooori.com';
//   static const String _websiteUrl = 'https://zarooori.com';

//   @override
//   void initState() {
//     super.initState();
//     // Only use WebView for Privacy Policy (3); Contact Us (2) and Terms (4) use native content
//     if (widget.pageNo == '3') {
//       final url = _urls[widget.pageNo]!;
//       _webController = WebViewController()
//         ..setJavaScriptMode(JavaScriptMode.unrestricted)
//         ..setNavigationDelegate(
//           NavigationDelegate(
//             onPageStarted: (_) {
//               if (mounted) setState(() => _isLoading = true);
//             },
//             onPageFinished: (_) {
//               if (mounted) setState(() => _isLoading = false);
//             },
//             onWebResourceError: (_) {
//               if (mounted) setState(() => _isLoading = false);
//             },
//           ),
//         )
//         ..loadRequest(Uri.parse(url));
//     }
//   }

//    Widget _buildBulletItem(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 6),
//             child: Container(
//               width: 6,
//               height: 6,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFFB300),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: GoogleFonts.openSans(
//                 fontSize: 14,
//                 color: AppColors.black,
//               ).copyWith(height: 1.5, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _launchUrl(BuildContext context, String url) async {
//     if (!context.mounted) return;
//     final uri = Uri.parse(url);
//     try {
//       final useBrowser = url.startsWith('http://') || url.startsWith('https://');
//       final mode = useBrowser ? LaunchMode.externalApplication : LaunchMode.platformDefault;
//       bool launched = false;
//       try {
//         launched = await launchUrl(uri, mode: mode);
//       } catch (_) {
//         try {
//           launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
//         } catch (_) {}
//       }
//       if (!launched && context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Could not open. Please try again.'),
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: Colors.black87,
//           ),
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Could not open link. Please try again.'),
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: Colors.black87,
//           ),
//         );
//       }
//     }
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title.toUpperCase(),
//       style: AppTextStyles.textView(
//         size: 11,
//         color: Colors.black.withValues(alpha: 0.6),
//       ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 1.2),
//     );
//   }

//   Widget _buildSectionCard({
//     required String sectionTitle,
//     required List<Widget> children,
//   }) {
//     return Container(
//       decoration: PremiumDecorations.card().copyWith(
//         border: Border.all(color: Colors.black87, width: 2),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildSectionTitle(sectionTitle),
//             const SizedBox(height: 12),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildParagraph(String text) {
//     return Text(
//       text,
//       style: GoogleFonts.delius(
//         fontSize: 14,
//         color: AppColors.black,
//       ).copyWith(height: 1.5, fontWeight: FontWeight.bold),
//     );
//   }

//   Widget _buildContactIntroCard() {
//     return _buildSectionCard(
//       sectionTitle: 'Get in touch',
//       children: [
//         _buildParagraph(
//           'ZAROOORI is a digital marketplace platform that connects users with independent dealers, service providers, garages, mechanics, sellers, and other automotive businesses. ZAROOORI itself does not own, manufacture, sell, repair, transport, or service vehicles, spare parts, or equipment listed on the platform. All services, products, quotations, prices, timelines, and offers displayed on the platform are provided directly by third-party',
//         ),
//         const SizedBox(height: 12),
//         _buildParagraph(
//           'service providers and sellers. ZAROOORI does not guarantee the accuracy, quality, pricing, availability, or performance of any service or product listed on the platform.',
//         ),
//          const SizedBox(height: 12),
//         _buildParagraph(
//           'Users are advised to independently verify service details, pricing, terms, warranties, and credentials of dealers or service providers before proceeding with any transaction. Any agreement, service delivery, or transaction entered into is solely between the user and the respective service provider or seller. ZAROOORI shall not be held responsible or liable for:',
//         ),
//          const SizedBox(height: 12),
//         _buildParagraph(
//           'Service delays, cancellations, or non-performance',
//         ),
//          const SizedBox(height: 12),
//         _buildParagraph(
//           'Quality of products or services delivered',
//         ),
//          const SizedBox(height: 12),
//         _buildParagraph(
//           'Pricing disputes or payment-related issues',
//         ),
//          const SizedBox(height: 12),
//         _buildParagraph(
//           'Damages, losses, accidents, or injuries arising from services availed Actions or omissions of third-party providers',
//         ),
//          const SizedBox(height: 12),
//         _buildParagraph(
//           'Emergency and medical services listed on the platform are provided by independent third parties. ZAROOORI does not guarantee response times, outcomes, or service availability during emergency situations. While ZAROOORI strives to onboard verified dealers and service providers, verification does not imply endorsement or warranty of their services. User ratings, reviews, and listings are provided for informational purposes only. By using the ZAROOORI app or website, users acknowledge and agree to this disclaimer and accept full responsibility for their decisions and transactions made through the platform.',
//         ),
//       ],
//     );
//   }

//   Widget _buildContactCard(BuildContext context) {
//     return Container(
//       decoration: PremiumDecorations.card().copyWith(
//         border: Border.all(color: Colors.black87, width: 2),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildSectionTitle('Contact Us'),
//             const SizedBox(height: 14),
//             _buildContactRow(
//               context: context,
//               icon: Icons.email_outlined,
//               label: 'Email Support',
//               value: _supportEmail,
//               url: 'mailto:$_supportEmail',
//             ),
//             const SizedBox(height: 14),
//             _buildContactRow(
//               context: context,
//               icon: Icons.language_rounded,
//               label: 'Website',
//               value: _websiteUrl.replaceFirst('https://', ''),
//               url: _websiteUrl,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContactParagraphWithLinks(BuildContext context) {
//     final baseStyle = AppTextStyles.textView(
//       size: 14,
//       color: AppColors.black,
//     ).copyWith(height: 1.5, fontWeight: FontWeight.w500);
//     final linkStyle = baseStyle.copyWith(
//       color: const Color(0xFFF57C00),
//       fontWeight: FontWeight.w600,
//       decoration: TextDecoration.underline,
//       decorationColor: const Color(0xFFF57C00),
//     );
//     return RichText(
//       text: TextSpan(
//         style: baseStyle,
//         children: [
//           const TextSpan(
//             text: 'For any questions about these Terms and Conditions, please contact us at support@ ',
//           ),
//           TextSpan(
//             text: _supportEmail,
//             style: linkStyle,
//             recognizer: TapGestureRecognizer()
//               ..onTap = () => _launchUrl(context, 'mailto:$_supportEmail'),
//           ),
//           const TextSpan(text: ' or visit '),
//           TextSpan(
//             text: _websiteUrl,
//             style: linkStyle,
//             recognizer: TapGestureRecognizer()
//               ..onTap = () => _launchUrl(context, _websiteUrl),
//           ),
//           const TextSpan(text: '.'),
//         ],
//       ),
//     );
//   }

//   Widget _buildTermsContent(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         _buildSectionCard(
//           sectionTitle: 'Terms of Use',
//           children: [
//             _buildParagraph(
//               'These Terms of Use govern the access to and use of the Zarooori website and mobile application ("Platform"). The Platform is owned and operated by ZUVION GLOBAL TRADERS PRIVATE LIMITED, a company incorporated under the Companies Act, 2013, having its registered office at 18-13-6/C/4 1/A, Bandlaguda Cross Road, Chandrayangutta, Hyderabad - 500005, India Chereinafter referred to as "Company", "We", "Us", or "Our").',
//             ),
//             const SizedBox(height: 12),
//             _buildParagraph(
//               'For the purpose of these Terms of Use, the terms “You”, “Your”, “Yourself”, or “Buyer” shall mean any natural or legal person who accesses, browses, registers on, or uses the Platform for purchasing items or availing services offered through the Platform. This document is published in compliance with Rule 3(1) of the Information Technology (Intermediary Guidelines) Rules, 2011, which requires the publication of rules, regulations, privacy policy, and terms of use for access or usage of an online platform.',
//             ),
//           ],
//         ),
//         const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'Acceptance of terms',
//           children: [
//             _buildParagraph(
//               ' These Terms of Use are subject to revision at any time without prior notice. You are requested to read these Terms carefully before using or registering on the Platform. Revised terms will be made available on the Platform, and it is your responsibility to review them periodically.',
//             ),
//             const SizedBox(height: 12),
//             _buildParagraph(
//               'Your continued use of the Platform after any changes shall constitute your acceptance of the revised Terms. Where required, we may seek your explicit consent before allowing further use of the Platform.',
//             ),
//           ],
//         ),
//         const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'Eligibility to Use',
//           children: [
//             _buildBulletItem(
//               ' Use of the Platform is available only to persons who are at least 18 years of age and are legally competent to enter into a contract under the Indian Contract Act, 1872.',
//             ),
//             const SizedBox(height: 12),
//             _buildBulletItem(
//               'Persons who are minors, insolvent, or suspended or removed from the Platform are not eligible to use the Platform.',
//             ),
//             const SizedBox(height: 12),
//             _buildBulletItem(
//               'You represent and warrant that you are legally eligible to use the Platform.',
//             ),
//             const SizedBox(height: 12),
//             _buildBulletItem(
//               'We reserve the right to refuse or terminate access to the Platform at any time without assigning any reason.',
//             ),
//             const SizedBox(height: 12),
//             _buildBulletItem(
//               'You are prohibited from selling, transferring, or assigning your account to any third party.',
//             ),
//           ],
//         ),
//         const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'Account Registration',
//           children: [
//             _buildBulletItem(
//               'You may access the Platform as a registered user or as a guest user. Certain features may be restricted for guest users. ',
//             ),
//             const SizedBox(height: 12),
//             _buildBulletItem(
//               'To create an account, you must provide accurate and complete information and create a login ID and password.',
//             ),
//             const SizedBox(height: 12),
//             _buildBulletItem(
//               'You are solely responsible for maintaining the confidentiality of your login credentials and for all activities conducted through your account.',
//             ),
//             const SizedBox(height: 12),
//             _buildBulletItem(
//               ' You must notify us immediately of any unauthorized use or security breach.',
//             ),
//             const SizedBox(height: 12),
//             _buildBulletItem(
//               'We reserve the right to suspend or terminate accounts or remove content at our discretion without prior notice.',
//             ),         
//           ],
//         ),
//         const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'User Information & Privacy',
//           children: [
//             _buildParagraph(
//               'You may be required to provide personal or business information. The collection, storage, and use of such information shall be governed by our Privacy Policy, which forms an integral part of these Terms of Use.',
//             ),
//           ],
//         ),
//         const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'User Obligations & Conduct',
//           children: [
//             _buildBulletItem(
//               'You are granted a limited, non-exclusive, and revocable right to access and use the Platform in accordance with these Terms.',
//             ),
//             const SizedBox(height: 12),
//              _buildBulletItem(
//               'You agree to use the Platform only for lawful purposes and in compliance with applicable laws.',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               'You shall not engage in activities that disrupt, damage, or interfere with the Platform or its users.',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               ' You shall not attempt unauthorized access, hacking, data mining, reverse engineering, or misuse of the Platform.',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               'Any content uploaded by you must be lawful, non-offensive, and compliant with applicable laws.',
//             ),
//              const SizedBox(height: 12),
//              _buildParagraph(
//               'You grant the Company a worldwide, perpetual, royalty-free, transferable, and sublicensable license to use, reproduce, publish, and distribute any content you upload on the Platform for business and promotional purposes.',
//             ),
//           ],
//         ),
//           const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'Prohibited Activities',
//           children: [
//             _buildParagraph(
//               'You shall not :',
//             ),
//             const SizedBox(height: 12),
//              _buildBulletItem(
//               'Defame, harass, threaten, impersonate, or misrepresent others',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               'Upload harmful, obscene, defamatory, or unlawful content',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               'Upload viruses or malicious software',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               'Violate intellectual property rights',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               'Interfere with Platform security or operations',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               'Use the Platform for unlawful or prohibited purposes',
//             ),
//           ],
//         ),
//           const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'Intellectual Property Rights',
//           children: [
//             _buildParagraph(
//               'All content on the Platform, including text, graphics, logos, designs, software, and layout, is owned by the Company and protected by intellectual property laws. You may not reproduce, distribute, or use such content without prior written permission.',
//             ),
//           ],
//         ),
//           const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'Disclaimer of Warranties & Limitation of Liability',
//           children: [
//             _buildParagraph(
//               'The Platform and services are provided on an “as-is” and “as-available” basis without warranties of any kind.We do not guarantee uninterrupted, error-free, secure, or reliable services and shall not be liable for :',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               'Service disruptions or technical issues',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               'Third-party service quality',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               'Data loss or unauthorized access',
//             ),
//              const SizedBox(height: 12),
//              _buildBulletItem(
//               'Any indirect, incidental, or consequential damages',
//             ),
//               const SizedBox(height: 12),
//              _buildBulletItem(
//               'Use of the Platform is at your own risk.',
//             ),
//           ],
//         ),
//           const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: '',
//           children: [
//             _buildParagraph(
//               '',
//             ),
//           ],
//         ),
//           const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'Indemnification',
//           children: [
//             _buildParagraph(
//               'You agree to indemnify and hold harmless the Company, its affiliates, directors, officers, and employees against any claims, losses, or damages arising from your breach of these Terms or misuse of the Platform.',
//             ),
//           ],
//         ),
//           const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'Platform Services & Third-Party Transactions',
//           children: [
//             _buildParagraph(
//               'The Platform acts only as an intermediary facilitating interactions between users and registered trading partners. Any transaction or agreement entered into is strictly between you and the respective trading partner. The Company does not guarantee pricing, service quality, or fulfillment.',
//             ),
//           ],
//         ),
//           const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'Termination',
//           children: [
//             _buildParagraph(
//               'We may suspend or terminate your access to the Platform at any time for violation of these Terms, legal requirements, or business reasons. Termination does not relieve you of obligations incurred prior to termination.',
//             ),
//           ],
//         ),
//           const SizedBox(height: 18),
//         _buildSectionCard(
//           sectionTitle: 'Governing Law & Jurisdiction',
//           children: [
//             _buildParagraph(
//               'These Terms shall be governed by the laws of India. All disputes shall be subject to the exclusive jurisdiction of courts located in Delhi, India.',
//             ),
//           ],
//         ),
//         // const SizedBox(height: 18),
//         // _buildSectionCard(
//         //   sectionTitle: 'Contact',
//         //   children: [
//         //     _buildContactParagraphWithLinks(context),
//         //   ],
//         // ),
//         const SizedBox(height: 24),
//       ],
//     );
//   }

//   Widget _buildContactRow({
//     required BuildContext context,
//     required IconData icon,
//     required String label,
//     required String value,
//     required String url,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () => _launchUrl(context, url),
//         borderRadius: BorderRadius.circular(16),
//         splashColor: const Color(0xFFFFD600).withValues(alpha: 0.3),
//         highlightColor: const Color(0xFFFFF59D).withValues(alpha: 0.2),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
//           decoration: PremiumDecorations.input(
//             fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
//           ).copyWith(
//             border: Border.all(color: const Color(0xFFFFD600), width: 2),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 icon,
//                 size: 22,
//                 color: AppColors.black.withValues(alpha: 0.7),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       label,
//                       style: AppTextStyles.textView(
//                         size: 11,
//                         color: Colors.black.withValues(alpha: 0.65),
//                       ).copyWith(
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       value,
//                       style: AppTextStyles.textView(
//                         size: 14,
//                         color: AppColors.black,
//                       ).copyWith(
//                         fontWeight: FontWeight.w600,
//                         decoration: TextDecoration.underline,
//                         decorationColor: const Color(0xFFF57C00),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_forward_ios_rounded,
//                 size: 14,
//                 color: AppColors.black.withValues(alpha: 0.5),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final title = _titles[widget.pageNo] ?? 'Page';
//     final isContactUs = widget.pageNo == '2';
//     final isTerms = widget.pageNo == '4';
//     final isNativeContent = isContactUs || isTerms;

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         leading: Container(
//           margin: const EdgeInsets.only(left: 8),
//           child: IconButton(
//             style: IconButton.styleFrom(
//               backgroundColor: const Color(0xFFFFF59D).withValues(alpha: 0.9),
//               padding: const EdgeInsets.all(8),
//             ),
//             icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 20),
//             onPressed: () => Get.back(),
//           ),
//         ),
//         title: Text(
//           title,
//           style: GoogleFonts.faustina(
//             fontSize: 18,
//             color: AppColors.black,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SizedBox.expand(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color(0xFFFFD600),
//                       Color(0xFFFFEA00),
//                       Color(0xFFFFF176),
//                       Color(0xFFFFE082),
//                     ],
//                     stops: [0.0, 0.35, 0.7, 1.0],
//                   ),
//                 ),
//               ),
//             ),
//             const Positioned(
//               top: -40,
//               right: -30,
//               child: ProfileBubble(size: 140, color: Color(0xFFFF9800)),
//             ),
//             const Positioned(
//               top: 140,
//               left: -40,
//               child: ProfileBubble(size: 110, color: Color(0xFFF57C00)),
//             ),
//             const Positioned(
//               bottom: 200,
//               right: -20,
//               child: ProfileBubble(size: 90, color: Color(0xFFFF9800)),
//             ),
//             const Positioned(
//               bottom: -60,
//               left: -40,
//               child: ProfileBubble(size: 180, color: Color(0xFFF57C00)),
//             ),
//             Positioned.fill(
//               child: SafeArea(
//               child: isNativeContent
//                   ? SingleChildScrollView(
//                       padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           const SizedBox(height: 60),
//                           if (isContactUs) ...[
//                             _buildContactIntroCard(),
//                             const SizedBox(height: 18),
//                             _buildContactCard(context),
//                           ] else if (isTerms) ...[
//                             _buildTermsContent(context),
//                           ],
//                           const SizedBox(height: 24),
//                         ],
//                       ),
//                     )
//                   : Column(
//                       children: [
//                         const SizedBox(height: 60),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                             child: Container(
//                               decoration: PremiumDecorations.card().copyWith(
//                                 border: Border.all(color: Colors.black87, width: 2),
//                                 color: Colors.white,
//                               ),
//                               clipBehavior: Clip.antiAlias,
//                               child: Stack(
//                                 children: [
//                                   if (_webController != null)
//                                     WebViewWidget(controller: _webController!),
//                                   if (_isLoading)
//                                     const Center(
//                                       child: CircularProgressIndicator(
//                                         color: AppColors.black,
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:zarooori_user/drawer_menu/contact_us/contact_us_screen.dart';
import 'package:zarooori_user/drawer_menu/privacy_policy/privacy_policy_screen.dart';
import 'package:zarooori_user/drawer_menu/terms_condition/terms_and_condition_screen.dart';


class PageDetailScreen extends StatelessWidget {
  final String pageNo;

  const PageDetailScreen({super.key, required this.pageNo});

  @override
  Widget build(BuildContext context) {
    switch (pageNo) {
      case '2':
        return const ContactUsScreen();
      case '3':
        return const PrivacyPolicyScreen();
      case '4':
        return const TermsAndConditionsScreen();
      default:
        return Scaffold(
          appBar: AppBar(title: const Text('Not Found')),
          body: const Center(child: Text('Invalid page')),
        );
    }
  }
}