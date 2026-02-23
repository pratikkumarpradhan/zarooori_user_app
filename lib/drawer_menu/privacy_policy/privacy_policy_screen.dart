import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isLoading = true;
  late final WebViewController _webController;

  @override
  void initState() {
    super.initState();
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse('https://aswack.com/privacy.php'));
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
            const Positioned(top: -40, right: -30, child: ProfileBubble(size: 140, color: Color(0xFFFF9800))),
            const Positioned(top: 140, left: -40, child: ProfileBubble(size: 110, color: Color(0xFFF57C00))),
            const Positioned(bottom: 200, right: -20, child: ProfileBubble(size: 90, color: Color(0xFFFF9800))),
            const Positioned(bottom: -60, left: -40, child: ProfileBubble(size: 180, color: Color(0xFFF57C00))),

            Positioned.fill(
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black87, width: 2),
                            borderRadius: BorderRadius.circular(16), // assuming PremiumDecorations.card() has radius
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            children: [
                              WebViewWidget(controller: _webController),
                              if (_isLoading)
                                const Center(
                                  child: CircularProgressIndicator(color: AppColors.black),
                                ),
                            ],
                          ),
                        ),
                      ),
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
}