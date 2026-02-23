import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:zarooori_user/others/web_view_screen.dart';
import 'package:zarooori_user/sos/trusted_contacts.dart';
import 'package:zarooori_user/widgets/drawer_menu_widget.dart';
import 'sell_vehicle_activity_screen.dart';

class SellVehicleListScreen extends StatefulWidget {
  final String vehicleCatId;

  const SellVehicleListScreen({super.key, required this.vehicleCatId});

  @override
  State<SellVehicleListScreen> createState() => _SellVehicleListScreenState();
}

class _SellVehicleListScreenState extends State<SellVehicleListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  int _productCount = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logout() async {
    await LocalAuthHelper.clearLoginData();
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          'Your product List',
          style: GoogleFonts.openSans(fontSize: 18, color: AppColors.black).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFFFF59D).withValues(alpha: 0.9),
              padding: const EdgeInsets.all(8),
            ),
            icon: const Icon(Icons.menu_rounded, color: AppColors.black, size: 20),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFFFF59D).withValues(alpha: 0.9),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () => Get.to(() => SellVehicleActivityScreen(vehicleCatId: widget.vehicleCatId)),
              icon: const Icon(Icons.add,
              fontWeight: FontWeight.w700,
               color: AppColors.black, size: 18),
              label: Text(
                'Add',
                style: GoogleFonts.openSans(fontSize: 12, 
                fontWeight: FontWeight.w800,
                color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerMenuWidget(
        onProfile: () => Get.to(() => const ProfileScreen()),
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
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: PremiumDecorations.card().copyWith(
                        border: Border.all(color: Colors.black87, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              style: AppTextStyles.editText13Ssp(color: AppColors.black).copyWith(fontSize: 14, height: 1.4),
                              decoration: PremiumDecorations.textField(
                                hintText: 'Search by name, serial number...',
                                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.black, size: 22),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '$_productCount products',
                              style: AppTextStyles.textView(size: 13, color: AppColors.black).copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _productCount == 0
                        ? _buildEmptyState()
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: PremiumDecorations.card().copyWith(
                              border: Border.all(color: Colors.black87, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: _productCount,
                                itemBuilder: (context, index) => const SizedBox.shrink(),
                              ),
                            ),
                          ),
                  ),
                ],
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
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: PremiumDecorations.inputFill.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car_outlined,
                size: 56,
                color: Colors.black.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No vehicles listed',
              style: GoogleFonts.openSans(fontSize: 17, color: AppColors.black,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Add your first vehicle to start selling',
              style: AppTextStyles.textView(size: 14, color: AppColors.black.withValues(alpha: 0.6)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => Get.to(() => SellVehicleActivityScreen(vehicleCatId: widget.vehicleCatId)),
              style: PremiumDecorations.primaryButtonStyle,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Add New Products'),
            ),
          ],
        ),
      ),
    );
  }
}