import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zarooori_user/Authentication/login_screen.dart';
import 'package:zarooori_user/authentication/local/local_auth.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/about_us/about_us_screen.dart';
import 'package:zarooori_user/drawer_menu/bookings_list/bookings_list_screen.dart';
import 'package:zarooori_user/drawer_menu/contact_us/rfq/add_rfq_screen.dart';
import 'package:zarooori_user/drawer_menu/orders/orders_list_screen.dart';
import 'package:zarooori_user/drawer_menu/page_detail_screen.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_screen.dart';
import 'package:zarooori_user/drawer_menu/purchased_packages/purchased_packages_screen.dart';
import 'package:zarooori_user/drawer_menu/reminders/reminders_list_screen.dart';
import 'package:zarooori_user/drawer_menu/wish_list/wish_list_screen.dart';
import 'package:zarooori_user/main_home_page/chat_list/chat_list_screen.dart';
import 'package:zarooori_user/main_home_page/offers/offers_screen.dart';
import 'package:zarooori_user/notification_service/notification_list_screen.dart';
import 'package:zarooori_user/others/web_view_screen.dart';
import 'package:zarooori_user/sos/sos_button.dart';
import 'package:zarooori_user/sos/trusted_contacts.dart';
import 'package:zarooori_user/widgets/drawer_menu_widget.dart';
import 'package:zarooori_user/widgets/header_widget.dart';
import 'package:zarooori_user/widgets/service_grid_widget.dart';
import 'package:zarooori_user/widgets/vehicle_selection_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String _userName = 'Hello';
  bool _fabExpanded = false;
  int _selectedNavIndex = 0;
  String? _offersCategoryId;
  final List<String> _sliderImages = [
    'assets/images/slider4.jpeg',
    'assets/images/slider2.png',
    'assets/images/slider3.jpeg',
   
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
    _loadUserData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('newusers')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final name = doc.data()?['name'] ?? '';
        setState(() {
          _userName = name.isNotEmpty
              ? 'Hello, $name'
              : 'Hello, ${user.email?.split('@')[0] ?? ''}';
        });
      } else {
        setState(() {
          _userName = 'Hello, ${user.email?.split('@')[0] ?? ''}';
        });
      }
    } else {
      setState(() => _userName = 'Hello');
    }
  }

  void _callAdmin() async {
    final uri = Uri.parse('tel:+919581659865');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _logout() async {
    await LocalAuthHelper.clearLoginData();
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: HeaderWidget(
            userName: _userName,
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            onNotificationTap: () =>
                Get.to(() => const NotificationListScreen()),
            onLanguageTap: () {},
          ),
        ),
        drawer: DrawerMenuWidget(
          onProfile: () async {
            await Get.to(() => const ProfileScreen());
            if (mounted) _loadUserData();
          },
          onRFQ: () => Get.to(() => const AddRFQScreen()),
          onWishList: () => Get.to(() => const WishListScreen()),
          onBooking: () => Get.to(() => const BookingListScreen()),
          onPackageList: () => Get.to(() => const PurchasedPackagesScreen()),
          onReminders: () => Get.to(() => const ReminderListScreen()),
          onOrders: () => Get.to(() => const OrderListScreen()),
          onAboutUs: () => Get.to(() => const AboutUsScreen()),
          onContactUs: () => Get.to(() => const PageDetailScreen(pageNo: '2')),
          onTerms: () => Get.to(() => const PageDetailScreen(pageNo: '4')),
          onPrivacy: () => Get.to(() => const PageDetailScreen(pageNo: '3')),
          onHelp: () => Get.to(
            () => const WebViewScreen(
              url: 'https://aswack.com/help.php',
              title: 'Help Center',
            ),
          ),
          onFaq: () => Get.to(
            () => const WebViewScreen(
              url: 'https://aswack.com/faq.php',
              title: "FAQ's",
            ),
          ),
          onTrustedContacts: () => Get.to(() => const TrustedContactsScreen()),
          onLogout: _logout,
        ),
        body: IndexedStack(
          index: _selectedNavIndex,
          children: [
            _buildDashboardContent(),
            _buildChatTabContent(),
            _buildOffersTabContent(),
            _buildRemindersTabContent(),
            _buildBookingsTabContent(),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Container(
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
          // Bubble-like decorative elements
          // MEDIUM
          Positioned(
            top: 40,
            left: -30,
            child: _BubbleWidget(
              size: 140,
              color: const Color(0xFFFF9800),
              highlightCenter: const Alignment(-0.35, -0.35),
            ),
          ),

          // SMALL
          Positioned(
            top: 140,
            right: -40,
            child: _BubbleWidget(
              size: 110,
              color: const Color(0xFFF57C00),
              highlightCenter: const Alignment(-0.4, -0.3),
            ),
          ),

          // TINY
          Positioned(
            top: 350,
            left: 60,
            child: _BubbleWidget(
              size: 70,
              color: const Color(0xFFFFB74D),
              highlightCenter: const Alignment(-0.3, -0.4),
            ),
          ),

          // SMALL
          Positioned(
            bottom: 220,
            right: 40,
            child: _BubbleWidget(
              size: 100,
              color: const Color(0xFFFF9800),
              highlightCenter: const Alignment(-0.3, -0.35),
            ),
          ),

          // MEDIUM
          Positioned(
            bottom: 120,
            left: -50,
            child: _BubbleWidget(
              size: 150,
              color: const Color(0xFFF57C00),
              highlightCenter: const Alignment(-0.35, -0.3),
            ),
          ),

          // TINY
          Positioned(
            bottom: 70,
            right: -20,
            child: _BubbleWidget(
              size: 65,
              color: const Color(0xFFFF9800),
              highlightCenter: const Alignment(-0.4, -0.35),
            ),
          ),

          // SMALL (center balance)
          Positioned(
            top: 180,
            left: 130,
            child: _BubbleWidget(
              size: 105,
              color: const Color(0xFFFF9800),
              highlightCenter: const Alignment(-0.35, -0.3),
            ),
          ),
          Positioned(
            bottom: -20,
            left: MediaQuery.of(context).size.width * 0.42,
            child: _BubbleWidget(
              size: 130,
              color: const Color(0xFFFF9800),
              highlightCenter: const Alignment(-0.35, -0.35),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: SizedBox(
                                height: 160,
                                child: CarouselSlider.builder(
                                  itemCount: _sliderImages.length,
                                  itemBuilder: (context, index, realIndex) =>
                                      Container(
                                        width: double.infinity,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: Image.asset(
                                            _sliderImages[index],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                      ),
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    autoPlayInterval: const Duration(
                                      seconds: 3,
                                    ),
                                    enlargeCenterPage: true,
                                    viewportFraction: 0.92,
                                  ),
                                ),
                              ),
                            ),
                            ServiceGridWidget(
                              scrollController: _scrollController,
                              contentTopOffset: 210,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 60,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_fabExpanded) ...[
                        _buildFabLabel('Call to Admin', _callAdmin),
                        const SizedBox(height: 8),
                        _buildEnhancedFab(
                          onPressed: _callAdmin,
                          heroTag: 'call',
                          icon: Icons.call,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                      ],
                      _buildEnhancedFab(
                        onPressed: () {
                          setState(() => _fabExpanded = !_fabExpanded);
                        },
                        heroTag: 'main',
                        icon: _fabExpanded ? Icons.close : Icons.add,
                        size: 56,
                      ),
                    ],
                  ),
                ),
                Positioned(right: -5, bottom: 210, child: SosFloatingButton()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF59D),
        border: Border(
          top: BorderSide(
            color: Colors.black.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
          BoxShadow(
            color: const Color(0xFFE6C34D).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            0,
            Icons.dashboard,
            'Dashboard',
            () => setState(() => _selectedNavIndex = 0),
          ),
          _buildNavItem(
            1,
            Icons.chat,
            'Chat',
            () => setState(() => _selectedNavIndex = 1),
          ),
          _buildNavItem(
            2,
            Icons.local_offer,
            'Offers',
            () => setState(() => _selectedNavIndex = 2),
          ),
          _buildNavItem(
            3,
            Icons.alarm,
            'My Reminders',
            () => setState(() => _selectedNavIndex = 3),
          ),
          _buildNavItem(
            4,
            Icons.book,
            'My Bookings',
            () => setState(() => _selectedNavIndex = 4),
          ),
        ],
      ),
    );
  }

  void _onOffersTap() async {
    final id = await showOffersCategorySheet(
      context,
      title: 'Select category to see offers',
    );
    if (id != null && mounted) {
      setState(() => _offersCategoryId = id);
    }
  }

  Widget _buildChatTabContent() {
    return const ChatListScreen(showBackButton: false);
  }

  Widget _buildOffersTabContent() {
    if (_offersCategoryId != null) {
      return CategoryOffersScreen(
        categoryId: _offersCategoryId!,
        onBack: () => setState(() => _offersCategoryId = null),
      );
    }
    return Container(
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.all(28),
                          decoration: PremiumDecorations.card().copyWith(
                            border: Border.all(color: Colors.black87, width: 2),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
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
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 0,
                                      offset: const Offset(-1, -1),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.local_offer_rounded,
                                    size: 40,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Select category to see offers',
                                style:
                                    GoogleFonts.openSans(
                                      fontSize: 17,
                                      color: AppColors.black,
                                    ).copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Choose a category below to view available offers',
                                style: AppTextStyles.textView(
                                  size: 13,
                                  color: AppColors.gray,
                                ).copyWith(letterSpacing: 0.1),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 28),
                              ElevatedButton.icon(
                                onPressed: _onOffersTap,
                                style: PremiumDecorations.primaryButtonStyle,
                                icon: const Icon(
                                  Icons.grid_view_rounded,
                                  size: 20,
                                ),
                                label: const Text('Select Category'),
                              ),
                            ],
                          ),
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
    );
  }

  Widget _buildRemindersTabContent() {
    return const ReminderListScreen(showBackButton: false);
  }

  Widget _buildBookingsTabContent() {
    return const BookingListScreen(showBackButton: false);
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final isSelected = _selectedNavIndex == index;
    final iconColor = isSelected ? const Color(0xFFF57C00) : Colors.black54;
    final textColor = isSelected ? Colors.black : Colors.black;
    final scale = isSelected ? 1.08 : 1.0;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: isSelected
                  ? BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    )
                  : null,
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 11,
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
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
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.5),
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
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: const Color(0xFFFFB74D).withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1A1A1A),
              size: size * 0.44,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFabLabel(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF59D),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: AppTextStyles.textView(size: 11, color: Colors.black),
        ),
      ),
    );
  }
}

/// Volumetric bubble-like decorative shape - more visible with higher opacity.
class _BubbleWidget extends StatelessWidget {
  final double size;
  final Color color;
  final Alignment highlightCenter;

  const _BubbleWidget({
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
            color: color.withValues(alpha: 0.15),
            blurRadius: size * 0.2,
            spreadRadius: 0,
          ),
        ],
        gradient: RadialGradient(
          center: highlightCenter,
          radius: 0.9,
          colors: [
            Colors.white.withValues(alpha: 0.45),
            yellow.withValues(alpha: 0.5),
            goldenYellow.withValues(alpha: 0.55),
            color.withValues(alpha: 0.5),
            color.withValues(alpha: 0.35),
            color.withValues(alpha: 0.15),
          ],
          stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
        ),
      ),
    );
  }
}