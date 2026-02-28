import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'raise_ticket_screen.dart';

class HelpCenterScreen extends StatefulWidget {
  final bool showBackButton;

  const HelpCenterScreen({super.key, this.showBackButton = true});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String? _uid;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser?.uid;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_uid == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: widget.showBackButton
            ? Container(
                margin: const EdgeInsets.only(left: 8),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFFF59D).withOpacity(0.9),
                    padding: const EdgeInsets.all(8),
                  ),
                  icon: const Icon(Icons.arrow_back,
                      color: AppColors.black, size: 20),
                  onPressed: () => Get.back(),
                ),
              )
            : null,
        title: Text(
          'Help Center',
          style: GoogleFonts.openSans(
            fontSize: 18,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      /// 🔥 PREMIUM HERO FAB
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildEnhancedFab(
        heroTag: "raise_ticket_fab",
        onPressed: () => Get.to(() => const RaiseTicketScreen()),
        icon: Icons.add,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          ),
        ),
        child: Stack(
          children: [
            /// Decorative bubbles
            const Positioned(
              top: -40,
              right: -30,
              child: ProfileBubble(
                  size: 140, color: Color(0xFFFF9800)),
            ),
            const Positioned(
              top: 140,
              left: -40,
              child: ProfileBubble(
                  size: 110, color: Color(0xFFF57C00)),
            ),
            const Positioned(
              bottom: 200,
              right: -20,
              child: ProfileBubble(
                  size: 90, color: Color(0xFFFF9800)),
            ),
            const Positioned(
              bottom: -60,
              left: -40,
              child: ProfileBubble(
                  size: 180, color: Color(0xFFF57C00)),
            ),

            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 70, 16, 16),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('help_tickets')
                      .where('uid', isEqualTo: _uid)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState();
                    }

                    final tickets = snapshot.data!.docs;

                    return RefreshIndicator(
                      color: AppColors.black,
                      onRefresh: () async {},
                      child: ListView.builder(
                        padding:
                            const EdgeInsets.only(bottom: 80),
                        itemCount: tickets.length,
                        itemBuilder: (context, index) {
                          final data =
                              tickets[index].data()
                                  as Map<String, dynamic>;

                          final category =
                              data['category'] ?? '';
                          final message =
                              data['message'] ?? '';
                          final status =
                              data['status'] ?? 'open';
                          final timestamp =
                              data['createdAt'] as Timestamp?;

                          return Container(
                            margin:
                                const EdgeInsets.only(
                                    bottom: 14),
                            decoration:
                                PremiumDecorations.card()
                                    .copyWith(
                              border: Border.all(
                                  color: Colors.black87,
                                  width: 2),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(
                                      16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets
                                                .all(10),
                                        decoration:
                                            BoxDecoration(
                                          color: const Color(
                                                  0xFFFFF59D)
                                              .withOpacity(
                                                  0.8),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      12),
                                        ),
                                        child: const Icon(
                                          Icons
                                              .support_agent,
                                          color: AppColors
                                              .black,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(
                                          width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              category,
                                              style: AppTextStyles
                                                      .textView(
                                                size: 16,
                                                color:
                                                    AppColors
                                                        .black,
                                              ).copyWith(
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                              ),
                                            ),
                                            const SizedBox(
                                                height:
                                                    4),
                                            Text(
                                              timestamp !=
                                                      null
                                                  ? DateTime.fromMillisecondsSinceEpoch(
                                                          timestamp
                                                              .millisecondsSinceEpoch)
                                                      .toString()
                                                      .substring(
                                                          0,
                                                          16)
                                                  : '',
                                              style:
                                                  AppTextStyles
                                                      .textView(
                                                size: 13,
                                                color:
                                                    AppColors
                                                        .gray,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                      height: 12),

                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: _getStatusColor(
                                              status)
                                          .withOpacity(
                                              0.2),
                                      borderRadius:
                                          BorderRadius
                                              .circular(8),
                                    ),
                                    child: Text(
                                      status
                                          .toUpperCase(),
                                      style: AppTextStyles
                                              .textView(
                                        size: 11,
                                        color:
                                            _getStatusColor(
                                                status),
                                      ).copyWith(
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 12),

                                  Text(
                                    message,
                                    style:
                                        AppTextStyles
                                            .textView(
                                      size: 14,
                                      color:
                                          AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        decoration:
            PremiumDecorations.card().copyWith(
          border: Border.all(
              color: Colors.black87, width: 2),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.support_agent,
                size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text(
              'No tickets yet',
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + button to raise your first support ticket.',
              style: AppTextStyles.textView(
                size: 14,
                color: AppColors.gray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedFab({
    required VoidCallback onPressed,
    required String heroTag,
    required IconData icon,
    double size = 56,
  }) {
    return Material(
      color: Colors.transparent,
      child: Hero(
        tag: heroTag,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          borderRadius:
              BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.black, width: 1.5),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFF8E1),
                  Color(0xFFFFF59D),
                  Color(0xFFFFEB3B),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.15),
                  blurRadius: 12,
                  offset:
                      const Offset(0, 4),
                ),
                BoxShadow(
                  color: const Color(
                          0xFFFFB74D)
                      .withOpacity(0.25),
                  blurRadius: 8,
                  offset:
                      const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color:
                  const Color(0xFF1A1A1A),
              size: size * 0.44,
            ),
          ),
        ),
      ),
    );
  }
}