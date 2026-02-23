import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
import 'package:zarooori_user/company/company_detail_screen.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/main_home_page/chat_list/chat_list_screen.dart';
import 'package:zarooori_user/main_home_page/insurance/vehicle_insurance_list_screen.dart';
import 'package:zarooori_user/main_home_page/offers/offers_screen.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductList product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  CompanyDetails? _companyDetails;
  bool _loadingCompany = true;

  @override
  void initState() {
    super.initState();
    _loadCompanyDetails();
  }

  Future<void> _loadCompanyDetails() async {
    try {
      final details = await VehicleInsuranceApi.getCompanyDetail(widget.product);
      if (mounted) {
        setState(() {
          _companyDetails = details;
          _loadingCompany = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingCompany = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final raw = widget.product.image1 ?? widget.product.image2 ?? widget.product.image3 ?? '';
    final imageUrl = resolveImageUrl(raw);

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
          'Product details',
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
            const Positioned(top: -40, right: -30, child: ProfileBubble(size: 140, color: Color(0xFFFF9800))),
            const Positioned(top: 160, left: -40, child: ProfileBubble(size: 110, color: Color(0xFFF57C00))),
            const Positioned(bottom: 280, right: -20, child: ProfileBubble(size: 90, color: Color(0xFFFF9800))),
            const Positioned(bottom: -80, left: -40, child: ProfileBubble(size: 180, color: Color(0xFFF57C00))),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: PremiumDecorations.card().copyWith(
                          border: Border.all(color: Colors.black87, width: 2),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (c, url) => Container(
                                      color: const Color(0xFFFFF8E1),
                                      child: const Center(
                                        child: CircularProgressIndicator(color: AppColors.black, strokeWidth: 2),
                                      ),
                                    ),
                                    errorWidget: (c, url, e) => Image.asset(
                                      'assets/images/placeholder.png',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        decoration: PremiumDecorations.card().copyWith(
                          border: Border.all(color: Colors.black87, width: 2),
                          color: const Color(0xFFFFFDE7),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.product_name ?? widget.product.vehicle_model_name ?? 'Product',
                              style: GoogleFonts.openSans(
                                fontSize: 20,
                                color: AppColors.black,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.product.vehicle_company_name != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  widget.product.vehicle_company_name!,
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: AppColors.gray,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            const SizedBox(height: 16),
                            _detailRow('Type', widget.product.vehicle_type_name),
                            _detailRow('Model', widget.product.vehicle_model_name),
                            _detailRow('Year', widget.product.vehicle_year_name),
                            if (widget.product.product_code != null && widget.product.product_code!.isNotEmpty)
                              _detailRow('Product Code', widget.product.product_code),
                            if (widget.product.price != null && widget.product.price!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF59D).withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFFFD600), width: 2),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Price',
                                      style: GoogleFonts.openSans(
                                        fontSize: 12,
                                        color: Colors.black.withValues(alpha: 0.7),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '₹${widget.product.price}',
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
                            if (widget.product.description != null && widget.product.description!.isNotEmpty) ...[
                              const SizedBox(height: 16),
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
                                  widget.product.description!,
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
                    ),
                    const SizedBox(height: 16),
                    if (_loadingCompany)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          decoration: PremiumDecorations.card().copyWith(
                            border: Border.all(color: Colors.black87, width: 2),
                            color: const Color(0xFFFFFDE7),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(color: AppColors.black),
                          ),
                        ),
                      )
                    else
                      _buildCompanyContactCard(),
                    const SizedBox(height: 16),
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

  Widget _buildCompanyContactCard() {
    final contact = _companyDetails?.contactNumber;
    final postedOn = widget.product.created_datetime;
    final hasCompany = _companyDetails != null && widget.product.seller_company_id != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
          color: const Color(0xFFFFFDE7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_companyDetails != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_companyDetails!.image != null && _companyDetails!.image!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        imageUrl: resolveImageUrl(_companyDetails!.image),
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        placeholder: (c, u) => Container(
                          color: const Color(0xFFFFF8E1),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.black),
                          ),
                        ),
                        errorWidget: (c, u, e) => Container(
                          width: 56,
                          height: 56,
                          color: const Color(0xFFFFF59D).withValues(alpha: 0.4),
                          child: const Icon(Icons.business_rounded, size: 28, color: AppColors.black),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF59D).withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFD600), width: 1.5),
                      ),
                      child: const Icon(Icons.business_rounded, size: 28, color: AppColors.black),
                    ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_companyDetails!.company_name != null)
                          Text(
                            _companyDetails!.company_name!,
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: AppColors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (_companyDetails!.fullAddress.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            _companyDetails!.fullAddress,
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: AppColors.gray,
                              height: 1.35,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF59D).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFD600), width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.phone_rounded, size: 18, color: AppColors.black.withValues(alpha: 0.7)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      contact ?? 'Not available',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (postedOn != null && postedOn.isNotEmpty)
                    Text(
                      'Posted: $postedOn',
                      style: GoogleFonts.openSans(
                        fontSize: 10,
                        color: Colors.black.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (contact != null && contact.isNotEmpty)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final uri = Uri.parse('tel:$contact');
                        launchUrl(uri);
                      },
                      icon: const Icon(Icons.phone_rounded, size: 18),
                      label: const Text('Call'),
                      style: PremiumDecorations.primaryButtonStyle,
                    ),
                  ),
                if (contact != null && contact.isNotEmpty && hasCompany) const SizedBox(width: 12),
                if (hasCompany)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (widget.product.seller_company_id != null) {
                          Get.to(() => CompanyDetailScreen(
                                companyId: widget.product.seller_company_id!,
                                mainCatId: widget.product.master_category_id ?? '4',
                              ));
                        }
                      },
                      icon: const Icon(Icons.business_rounded, size: 18),
                      label: const Text('View Profile'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.black,
                        side: BorderSide(color: PremiumDecorations.primaryButtonBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _actionButton(
                  'Latest Offers',
                  () => Get.to(() => CategoryOffersScreen(categoryId: widget.product.master_category_id ?? '4')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionButton('Latest Products', () {
                  if (widget.product.seller_company_id != null) {
                    Get.to(() => VehicleInsuranceListScreen(productRequest: ProductRequest(
                          master_category_id: widget.product.master_category_id,
                          vehicle_category_id: widget.product.vehicle_cat_id,
                          city_id: '0',
                        )));
                  } else {
                    Get.snackbar('Info', 'No seller information');
                  }
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _actionButton('View Company Profile', () {
                  if (widget.product.seller_company_id != null) {
                    Get.to(() => CompanyDetailScreen(
                          companyId: widget.product.seller_company_id!,
                          mainCatId: widget.product.master_category_id ?? '4',
                        ));
                  } else {
                    Get.snackbar('Info', 'No company information');
                  }
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionButton('Online Chat', () => Get.to(() => const ChatListScreen())),
              ),
            ],
          ),
        ],
      ),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.openSans(
                fontSize: 12,
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.openSans(
                fontSize: 13,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}