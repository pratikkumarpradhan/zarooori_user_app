import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarooori_user/company/company_detail_screen.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/main_home_page/chat_list/chat_list_screen.dart';
import 'package:zarooori_user/main_home_page/offers/offers_screen.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';


class VehicleDetailScreen extends StatelessWidget {
  final SellVehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final images = [
      resolveImageUrl(vehicle.image1),
      resolveImageUrl(vehicle.image2),
      resolveImageUrl(vehicle.image3),
    ].where((s) => s.isNotEmpty).toList();
    final mainImage = images.isNotEmpty ? images.first : null;

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
          'Vehicle Details',
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
                    const SizedBox(height: 60),
                    if (vehicle.advertisement_code != null && vehicle.advertisement_code!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF59D).withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFFD600), width: 1.5),
                          ),
                          child: Text(
                            'Ad no.: ${vehicle.advertisement_code}',
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    Container(
                      decoration: PremiumDecorations.card().copyWith(
                        border: Border.all(color: Colors.black87, width: 2),
                        color: Colors.white,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (mainImage != null)
                            CachedNetworkImage(
                              imageUrl: mainImage,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (c, url) => Container(
                                height: 220,
                                color: const Color(0xFFFFF8E1),
                                child: const Center(child: CircularProgressIndicator(color: AppColors.black)),
                              ),
                              errorWidget: (c, url, e) => Image.asset(
                                'assets/images/placeholder.png',
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            Image.asset(
                              'assets/images/placeholder.png',
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vehicle.title ?? vehicle.vehicle_model_name ?? 'Vehicle',
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 16),
                                _detailRow('Brand', vehicle.vehicle_brand_name),
                                _detailRow('Type', vehicle.vehicle_type_name),
                                _detailRow('Model', vehicle.vehicle_model_name),
                                _detailRow('Year', vehicle.vehicle_year_name),
                                _detailRow('Fuel', vehicle.vehicle_fuel_name),
                                _detailRow('Transmission', vehicle.transmission),
                                if (vehicle.price != null && vehicle.price!.isNotEmpty) ...[
                                  const SizedBox(height: 14),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF59D).withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFFFD600), width: 2),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Price',
                                          style: GoogleFonts.openSans(
                                            fontSize: 12,
                                            color: Colors.black.withValues(alpha: 0.7),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '₹${vehicle.price}',
                                          style: GoogleFonts.openSans(
                                            fontSize: 18,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                if (vehicle.description != null && vehicle.description!.isNotEmpty) ...[
                                  const SizedBox(height: 18),
                                  Text(
                                    'DESCRIPTION',
                                    style: GoogleFonts.openSans(
                                      fontSize: 11,
                                      color: Colors.black.withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF59D).withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFFFE082).withValues(alpha: 0.8), width: 1.5),
                                    ),
                                    child: Text(
                                      vehicle.description!,
                                      style: GoogleFonts.openSans(
                                        fontSize: 13,
                                        color: AppColors.black,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildContactPostedCard(
                      contactNumber: vehicle.contact_number,
                      postedOn: vehicle.created_datetime,
                      onCall: vehicle.contact_number != null && vehicle.contact_number!.isNotEmpty
                          ? () {
                              final uri = Uri.parse('tel:${vehicle.contact_number}');
                              launchUrl(uri);
                            }
                          : null,
                      onViewProfile: vehicle.seller_company_id != null
                          ? () => Get.to(() => CompanyDetailScreen(
                                companyId: vehicle.seller_company_id!,
                                mainCatId: vehicle.category ?? '1',
                              ))
                          : null,
                    ),
                    const SizedBox(height: 18),
                    _buildActionButtons(
                      onLatestOffers: () => Get.to(() => CategoryOffersScreen(categoryId: vehicle.category ?? '1')),
                      onLatestProducts: () => Get.snackbar('Info', 'Products list - coming soon'),
                      onViewCompanyProfile: vehicle.seller_company_id != null
                          ? () => Get.to(() => CompanyDetailScreen(
                                companyId: vehicle.seller_company_id!,
                                mainCatId: vehicle.category ?? '1',
                              ))
                          : null,
                      onOnlineChat: () => Get.to(() => const ChatListScreen()),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactPostedCard({
    required String? contactNumber,
    required String? postedOn,
    VoidCallback? onCall,
    VoidCallback? onViewProfile,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
        color: const Color(0xFFFFFDE7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTACT NO.',
                      style: GoogleFonts.openSans(
                        fontSize: 10,
                        color: Colors.black.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      contactNumber ?? 'Not available',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (postedOn != null && postedOn.isNotEmpty)
                Text(
                  'Posted: $postedOn',
                  style: GoogleFonts.openSans(
                    fontSize: 10,
                    color: AppColors.gray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (onCall != null)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onCall,
                    icon: const Icon(Icons.phone_rounded, size: 18),
                    label: const Text('Call'),
                    style: PremiumDecorations.primaryButtonStyle,
                  ),
                ),
              if (onCall != null && onViewProfile != null) const SizedBox(width: 12),
              if (onViewProfile != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewProfile,
                    icon: const Icon(Icons.business_rounded, size: 18),
                    label: const Text('View Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.black,
                      side: BorderSide(color: PremiumDecorations.primaryButtonBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons({
    required VoidCallback onLatestOffers,
    required VoidCallback onLatestProducts,
    VoidCallback? onViewCompanyProfile,
    required VoidCallback onOnlineChat,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _actionButton('Latest Offers', onLatestOffers),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _actionButton('Latest Products', onLatestProducts),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (onViewCompanyProfile != null) ...[
              Expanded(
                child: _actionButton('View Company Profile', onViewCompanyProfile),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: _actionButton('Online Chat', onOnlineChat),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionButton(String label, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: const Color(0xFFFFD600).withValues(alpha: 0.3),
        highlightColor: const Color(0xFFFFF59D).withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF59D).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black87, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 12,
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 12,
                color: AppColors.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.openSans(
                fontSize: 13,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}