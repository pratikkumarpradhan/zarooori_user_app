import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';

class DrawerMenuWidget extends StatelessWidget {
  final VoidCallback onProfile;
  final VoidCallback onRFQ;
  final VoidCallback onWishList;
  final VoidCallback onBooking;
  final VoidCallback onPackageList;
  final VoidCallback onReminders;
  final VoidCallback onOrders;
  final VoidCallback onAboutUs;
  final VoidCallback onContactUs;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;
  final VoidCallback onHelp;
  final VoidCallback onFaq;
  final VoidCallback onTrustedContacts;
  final VoidCallback onLogout;
  final VoidCallback onDealer;


  const DrawerMenuWidget({
    super.key,
    required this.onProfile,
    required this.onRFQ,
    required this.onWishList,
    required this.onBooking,
    required this.onPackageList,
    required this.onReminders,
    required this.onOrders,
    required this.onAboutUs,
    required this.onContactUs,
    required this.onTerms,
    required this.onPrivacy,
    required this.onHelp,
    required this.onFaq,
    required this.onTrustedContacts,
    required this.onLogout,
    required this.onDealer,

  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Colors.transparent,
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
        child: Stack(
          children: [
            // Bubble-like decorative elements to match home screen
            const Positioned(
              top: -20,
              left: -40,
              child: _DrawerBubble(
                size: 140,
                color: Color(0xFFFF9800),
                highlightCenter: Alignment(-0.35, -0.35),
              ),
            ),
            const Positioned(
              top: 140,
              right: -40,
              child: _DrawerBubble(
                size: 100,
                color: Color(0xFFF57C00),
                highlightCenter: Alignment(-0.4, -0.3),
              ),
            ),
            const Positioned(
              bottom: 120,
              left: -50,
              child: _DrawerBubble(
                size: 150,
                color: Color(0xFFF57C00),
                highlightCenter: Alignment(-0.35, -0.3),
              ),
            ),
            const Positioned(
              bottom: 40,
              right: -30,
              child: _DrawerBubble(
                size: 90,
                color: Color(0xFFFF9800),
                highlightCenter: Alignment(-0.4, -0.35),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(context),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.78),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            children: [
                              _buildSectionTitle('My Account'),
                              _buildMenuItem(context, Icons.person, 'Profile', onProfile),
                              _buildMenuItem(context, Icons.request_quote, 'RFQ', onRFQ),
                              _buildMenuItem(context, Icons.favorite, 'My Favorite List', onWishList),
                              _buildMenuItem(context, Icons.book, 'My Bookings', onBooking),
                              _buildMenuItem(context, Icons.inventory_2, 'My Packages', onPackageList),
                              _buildMenuItem(context, Icons.alarm, 'My Reminders', onReminders),
                              _buildMenuItem(context, Icons.shopping_cart, 'My Orders', onOrders),
                              const SizedBox(height: 8),
                              _buildSectionTitle('Information'),
                              _buildMenuItem(context, Icons.info, 'About Us', onAboutUs),
                              _buildMenuItem(context, Icons.contact_mail, 'Contact Us', onContactUs),
                              _buildMenuItem(context, Icons.description, 'Terms and Condition', onTerms),
                              _buildMenuItem(context, Icons.privacy_tip, 'Privacy Policy', onPrivacy),
                              _buildMenuItem(context, Icons.app_registration, 'Upgrade to Dealer', onDealer),

                              const SizedBox(height: 8),
                              _buildSectionTitle('Support'),
                              _buildMenuItem(context, Icons.help, 'Help Center', onHelp),
                              _buildMenuItem(context, Icons.help_outline, "FAQ's", onFaq),
                              _buildMenuItem(context, Icons.people, 'Trusted Contacts', onTrustedContacts),
                              const Divider(height: 24, thickness: 0.6, color: Colors.black26),
                              _buildMenuItem(
                                context,
                                Icons.logout,
                                'Logout',
                                onLogout,
                                isDestructive: true,
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

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFFFC107).withValues(alpha: 0.7),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
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
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ZAROOORI',
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  'Smart services, on time.',
                  style: GoogleFonts.openSans(fontSize:  11,
                    color: Colors.black.withValues(alpha: 0.7),
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
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 2),
      child: Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: 11,
          color: Colors.black.withValues(alpha: 0.7),
        
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final Color iconBorder = isDestructive ? const Color(0xFFD84315) : const Color(0xFFFFB300);
    final Color iconColor = isDestructive ? Colors.white : AppColors.black;
    final Color textColor = isDestructive ? const Color(0xFFD84315) : AppColors.black;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDestructive
                      ? const [Color(0xFFFF8A65), Color(0xFFFF5722)]
                      : const [Color(0xFFFFFDE7), Color(0xFFFFF59D)],
                ),
                border: Border.all(color: iconBorder, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.openSans(
                  fontSize: 12,
                  color: textColor,
                 fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Smaller bubble decoration used inside the drawer background
class _DrawerBubble extends StatelessWidget {
  final double size;
  final Color color;
  final Alignment highlightCenter;

  const _DrawerBubble({
    required this.size,
    required this.color,
    this.highlightCenter = const Alignment(-0.35, -0.35),
  });

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFFFD54F);
    const goldenYellow = Color(0xFFFFB74D);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: size * 0.22,
            spreadRadius: 0,
          ),
        ],
        gradient: RadialGradient(
          center: highlightCenter,
          radius: 0.9,
          colors: [
            Colors.white.withValues(alpha: 0.5),
            yellow.withValues(alpha: 0.55),
            goldenYellow.withValues(alpha: 0.6),
            color.withValues(alpha: 0.55),
            color.withValues(alpha: 0.35),
            color.withValues(alpha: 0.18),
          ],
          stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
        ),
      ),
    );
  }
}