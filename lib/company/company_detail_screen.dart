import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarooori_user/api_services/courier_api.dart';
import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
import 'package:zarooori_user/book_appointment/book_appointment_screen.dart';
import 'package:zarooori_user/main_home_page/chat_list/chat_list_screen.dart';
import 'package:zarooori_user/main_home_page/courier_service/add_courier_details.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/main_home_page/insurance/vehicle_insurance_list_screen.dart';
import 'package:zarooori_user/main_home_page/offers/offers_screen.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/models/product_model.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/vehicle/search_vehicle_screen.dart';

class CompanyDetailScreen extends StatefulWidget {
  final String companyId;
  final String mainCatId;
  final CourierDetails? courierDetails;

  const CompanyDetailScreen({
    super.key,
    required this.companyId,
    this.mainCatId = '1',
    this.courierDetails,
  });

  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  CompanyDetails? _company;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCompany();
  }

  Future<void> _loadCompany() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final details = await VehicleInsuranceApi.getCompanyDetailByCompanyId(widget.companyId);
      if (mounted) {
        setState(() {
          _company = details;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _loading = false;
        });
      }
    }
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
          _company?.company_name ?? 'Company Details',
          style: GoogleFonts.openSans(
            fontSize: 18,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                  : _error != null
                      ? _buildErrorState()
                      : _company == null
                          ? _buildNotFoundState()
                          : SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                 // const SizedBox(height: 60),
                                  _buildCompanyPhotoCard(),
                                  const SizedBox(height: 18),
                                  _buildCompanyHeader(),
                                  const SizedBox(height: 18),
                                  _buildContactSection(),
                                  const SizedBox(height: 18),
                                  _buildActionButtons(),
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

  Widget _buildCompanyPhotoCard() {
  final imageUrl = _company?.image != null && _company!.image!.isNotEmpty
      ? resolveImageUrl(_company!.image)
      : null;

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: PremiumDecorations.card().copyWith(
      border: Border.all(color: Colors.black87, width: 2),
      color: Colors.white,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9, // normal horizontal image
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (c, u) => Container(
            color: const Color(0xFFFFF8E1),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.black),
            ),
          ),
          errorWidget: (c, u, e) => Image.asset(
            'assets/images/placeholder.jpg', // default image
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error ?? 'An error occurred',
              style: GoogleFonts.openSans(fontSize: 14, color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCompany,
              style: PremiumDecorations.primaryButtonStyle,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.business_center_outlined, size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text(
              'Company not found',
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader() {
    final imageUrl = _company!.image != null && _company!.image!.isNotEmpty
        ? resolveImageUrl(_company!.image)
        : null;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null) ...[
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                // child: ClipRRect(
                //   borderRadius: BorderRadius.circular(20),
                //   child: CachedNetworkImage(
                //     imageUrl: imageUrl,
                //     width: 120,
                //     height: 120,
                //     fit: BoxFit.cover,
                //     placeholder: (c, u) => Container(
                //       width: 120,
                //       height: 120,
                //       color: const Color(0xFFFFF8E1),
                //       child: const Center(child: CircularProgressIndicator(color: AppColors.black)),
                //     ),
                //     errorWidget: (c, u, e) => Image.asset(
                //       'assets/images/placeholder.png',
                //       width: 120,
                //       height: 120,
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (_company!.company_name != null)
            Text(
              _company!.company_name!,
              style: GoogleFonts.openSans(
                fontSize: 20,
                color: AppColors.black,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (_company!.owner_name != null && _company!.owner_name!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Owner: ${_company!.owner_name}',
              style: GoogleFonts.openSans(fontSize: 13, color: AppColors.gray, fontWeight: FontWeight.w500),
            ),
          ],
          if (_company!.specialize_in != null && _company!.specialize_in!.isNotEmpty) ...[
            const SizedBox(height: 14),
            _sectionTitle('Specialization'),
            const SizedBox(height: 6),
            _sectionContent(_company!.specialize_in!),
          ],
          if (_company!.desciption != null && _company!.desciption!.isNotEmpty) ...[
            const SizedBox(height: 14),
            _sectionTitle('Description'),
            const SizedBox(height: 6),
            _sectionContent(_company!.desciption!),
          ],
          if (_company!.fullAddress.isNotEmpty) ...[
            const SizedBox(height: 14),
            _sectionTitle('Address'),
            const SizedBox(height: 6),
            _sectionContent(_company!.fullAddress),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.openSans(
        fontSize: 11,
        color: Colors.black.withValues(alpha: 0.6),
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      ),
    );
  }

  Widget _sectionContent(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF59D).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082).withValues(alpha: 0.8), width: 1.5),
      ),
      child: Text(
        text,
        style: GoogleFonts.openSans(fontSize: 13, color: AppColors.black, height: 1.5),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
        color: const Color(0xFFFFFDE7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle('Contact'),
          const SizedBox(height: 14),
          if (_company!.company_mobile != null && _company!.company_mobile!.isNotEmpty)
            _contactRow(Icons.phone_rounded, _company!.company_mobile!, isPhone: true),
          if (_company!.company_alt_mobile != null && _company!.company_alt_mobile!.isNotEmpty)
            _contactRow(Icons.phone_android_rounded, _company!.company_alt_mobile!, isPhone: true),
          if (_company!.company_phone != null && _company!.company_phone!.isNotEmpty)
            _contactRow(Icons.phone_in_talk_rounded, _company!.company_phone!, isPhone: true),
          if (_company!.company_email_id != null && _company!.company_email_id!.isNotEmpty)
            _contactRow(Icons.email_rounded, _company!.company_email_id!, isPhone: false, isEmail: true),
          if (_company!.company_website != null && _company!.company_website!.isNotEmpty)
            _contactRow(Icons.language_rounded, _company!.company_website!, isPhone: false, isUrl: true),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String value, {required bool isPhone, bool isUrl = false, bool isEmail = false}) {
    final isTappable = isPhone || isUrl || isEmail;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (isPhone) {
              launchUrl(Uri.parse('tel:$value'));
            } else if (isUrl) {
              launchUrl(Uri.parse(value.startsWith('http') ? value : 'https://$value'));
            } else if (isEmail) {
              launchUrl(Uri.parse('mailto:${Uri.encodeComponent(value)}'));
            }
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: const Color(0xFFFFD600).withValues(alpha: 0.3),
          highlightColor: const Color(0xFFFFF59D).withValues(alpha: 0.2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF59D).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFD600), width: 1.5),
            ),
            child: Row(
              children: [
                Icon(icon, size: 22, color: AppColors.black),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.openSans(
                      fontSize: 13,
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      decoration: isTappable ? TextDecoration.underline : null,
                      decorationColor: const Color(0xFFF57C00),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isTappable)
                  Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.black.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final isCourier = widget.mainCatId == CourierApi.masterCategoryId;
    final isGarage = widget.mainCatId == '3';
    final courierDetails = widget.courierDetails ??
        (widget.companyId.isNotEmpty && _company != null
            ? CourierDetails(
                seller_id: _company!.seller_id,
                seller_name: _company!.owner_name,
                seller_company_id: _company!.id,
                seller_company_name: _company!.company_name,
              )
            : null);

    return Column(
      children: [
        if (isCourier && courierDetails != null) ...[
          _actionBtn('Send Delivery Request', () => Get.to(() => AddCourierDetailsScreen(courierDetails: courierDetails)), fullWidth: true),
          const SizedBox(height: 12),
        ],
        if (isGarage && _company != null) ...[
          _actionBtn('Book Appointment', () => Get.to(() => BookAppointmentScreen(
                sellerCompanyId: _company!.id ?? '',
                sellerId: _company!.seller_id ?? '',
                companyName: _company!.company_name ?? '',
              )), fullWidth: true),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(child: _actionBtn('Latest Offers', () => Get.to(() => CategoryOffersScreen(categoryId: widget.mainCatId)))),
            const SizedBox(width: 12),
            Expanded(
              child: _actionBtn('Latest Products', () {
                if (widget.mainCatId == '1') {
                  Get.to(() => SearchVehicleListScreen(
                        vehicleCatId: '1',
                        buyVehicleFilter: BuyVehicle(category: '1', user_id: null),
                      ));
                } else {
                  Get.to(() => VehicleInsuranceListScreen(
                        productRequest: ProductRequest(
                          master_category_id: widget.mainCatId,
                          vehicle_category_id: '1',
                          city_id: '0',
                        ),
                      ));
                }
              }),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _actionBtn('Online Chat', () => Get.to(() => const ChatListScreen()), fullWidth: true),
      ],
    );
  }

  Widget _actionBtn(String label, VoidCallback onTap, {bool fullWidth = false}) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: Material(
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
              style: GoogleFonts.openSans(fontSize: 13, color: AppColors.black, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}