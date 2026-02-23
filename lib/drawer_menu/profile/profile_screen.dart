import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/edit_profile_screen.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() {
        _isLoading = false;
        _profile = null;
      });
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('newusers')
          .doc(uid)
          .get();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _profile = doc.exists && doc.data() != null
              ? Map<String, dynamic>.from(doc.data()!)
              : null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _profile = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = _profile?['name']?.toString() ?? '';
    final String initials = fullName.isNotEmpty
        ? fullName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : 'U';

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
          'My Profile',
          style: GoogleFonts.openSans(fontSize: 18, color: AppColors.black,
            fontWeight: FontWeight.w600,
          )
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFFFF59D).withValues(alpha: 0.9),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () async {
                await Get.to(() => const UpdateProfileScreen());
                if (mounted) _loadProfile();
              },
              icon: const Icon(Icons.edit_square, color: AppColors.black, size: 18),
              label: Text(
                'Edit',
                style: GoogleFonts.openSans(fontSize: 12, color: AppColors.black,
                fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 60),
                          _buildProfileHeader(initials, fullName),
                          const SizedBox(height: 18),
                          Container(
                            decoration: PremiumDecorations.card().copyWith(
                              border: Border.all(color: Colors.black87, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildSectionTitle('Contact'),
                                  const SizedBox(height: 6),
                                  _buildField('Full name', _profile?['name'] ?? ''),
                                  const SizedBox(height: 13),
                                  _buildField('Mobile No.', _profile?['mobile'] ?? ''),
                                  const SizedBox(height: 13),
                                  _buildField('Email', _profile?['email'] ?? ''),
                                  const SizedBox(height: 18),
                                  _buildSectionTitle('Personal details'),
                                  const SizedBox(height: 6),
                                  _buildField('Pincode', _profile?['pincode'] ?? ''),
                                  const SizedBox(height: 13),
                                  _buildField('Date of Birth', _profile?['dob'] ?? ''),
                                  const SizedBox(height: 13),
                                  _buildField(
                                    'Gender',
                                    _profile?['gender'] == '1'
                                        ? 'Female'
                                        : (_profile?['gender'] == '0'
                                            ? 'Male'
                                            : ''),
                                  ),
                                  const SizedBox(height: 18),
                                  _buildSectionTitle('Address'),
                                  const SizedBox(height: 6),
                                  _buildField('House / Building No.', _profile?['houseNo'] ?? ''),
                                  const SizedBox(height: 13),
                                  _buildField('Street / Area', _profile?['streetName'] ?? ''),
                                  const SizedBox(height: 13),
                                  _buildField('State', _profile?['stateName'] ?? _profile?['state'] ?? ''),
                                  const SizedBox(height: 13),
                                  _buildField('City', _profile?['cityName'] ?? _profile?['city'] ?? ''),
                                ],
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

  Widget _buildProfileHeader(String initials, String fullName) {
    final String email = _profile?['email']?.toString() ?? '';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: PremiumDecorations.card(
        backgroundColor: const Color(0xFFFFFDE7),
        border: Border.all(
          color: PremiumDecorations.cardBorder.withValues(alpha: 0.9),
          width: 1.5,
        ),
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
              child: Text(
                initials,
                style: AppTextStyles.headingBold18(color: AppColors.black).copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
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
                  fullName.isEmpty ? 'Your Name' : fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(fontSize: 17, color: AppColors.black,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email.isEmpty ? 'No email linked' : email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textView(size: 12, color: AppColors.gray).copyWith(
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.textView(
          size: 11,
          color: Colors.black.withValues(alpha: 0.6),
        ).copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            label,
            style: AppTextStyles.textView13Ssp(color: Colors.black.withValues(alpha: 0.65)).copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: PremiumDecorations.input(
            fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
          ).copyWith(
            border: Border.all(color: const Color(0xFFFFD600), width: 2),
          ),
          child: Text(
            value.isEmpty ? '-' : value,
            style: AppTextStyles.editText13Ssp(color: value.isEmpty ? AppColors.gray : AppColors.black).copyWith(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}