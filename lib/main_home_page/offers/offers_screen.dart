import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/offers_api.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/models/offers_model.dart';

const String _currencySymbol = '₹';

class CategoryOffersScreen extends StatefulWidget {
  final String categoryId;
  final VoidCallback? onBack;

  const CategoryOffersScreen({super.key, required this.categoryId, this.onBack});

  @override
  State<CategoryOffersScreen> createState() => _CategoryOffersScreenState();
}

class _CategoryOffersScreenState extends State<CategoryOffersScreen>
    with WidgetsBindingObserver {
  List<OfferItem> _offers = [];
  List<OfferItem> _filteredList = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(_onSearchChanged);
    _loadOffers();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadOffers();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredList = List.from(_offers);
      } else {
        _filteredList = _offers.where((item) {
          final code = item.code?.toLowerCase() ?? '';
          final productName = item.product_name?.toLowerCase() ?? '';
          final name = item.displayName.toLowerCase();
          final offerPrice = item.offer_price?.toLowerCase() ?? '';
          final originalPrice = item.original_price?.toLowerCase() ?? '';
          return code.contains(query) ||
              productName.contains(query) ||
              name.contains(query) ||
              offerPrice.contains(query) ||
              originalPrice.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadOffers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final list = await OffersApi.getOfferList(widget.categoryId);
      if (mounted) {
        setState(() {
          _offers = list;
          _filteredList = List.from(list);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString().replaceAll('Exception: ', '');
          _offers = [];
          _filteredList = [];
        });
      }
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    try {
      final parts = date.split('-');
      if (parts.length >= 3) {
        final y = parts[0], m = parts[1], d = parts[2];
        return '$d/$m/$y';
      }
      return date;
    } catch (_) {
      return date;
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
            onPressed: () => widget.onBack != null ? widget.onBack!() : Get.back(),
          ),
        ),
        title: Text(
          'Offers',
          style: GoogleFonts.openSans(fontSize: 18, color: AppColors.black,
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    if (!_isLoading && _error == null && _offers.isNotEmpty) ...[
                      _buildSearchField(),
                      const SizedBox(height: 16),
                    ],
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(color: AppColors.black),
                            )
                          : _error != null
                              ? _buildErrorState()
                              : _filteredList.isEmpty
                                  ? _buildEmptyState()
                                  : _buildOffersList(),
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

  Widget _buildSearchField() {
    return Container(
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: TextField(
        controller: _searchController,
        decoration: PremiumDecorations.textField(
          hintText: 'Search by name, code, product...',
          prefixIcon: const Icon(Icons.search, color: AppColors.black),
        ),
        style: AppTextStyles.textView(size: 14, color: AppColors.black),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error ?? 'An error occurred',
              style: AppTextStyles.textView(size: 14, color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOffers,
              style: PremiumDecorations.primaryButtonStyle,
              child: const Text('Retry'),
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
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_offer_outlined, size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text(
              'No offers in this category',
              style: AppTextStyles.textView(size: 16, color: AppColors.black).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new offers.',
              style: AppTextStyles.textView(size: 14, color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersList() {
    return RefreshIndicator(
      onRefresh: _loadOffers,
      color: AppColors.black,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: _filteredList.length,
        itemBuilder: (context, index) {
          final offer = _filteredList[index];
          return _OfferCard(
            offer: offer,
            formatDate: _formatDate,
            onTap: () => _showOfferDetailSheet(context, offer),
          );
        },
      ),
    );
  }

  void _showOfferDetailSheet(BuildContext context, OfferItem offer) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _OfferDetailSheet(
        offer: offer,
        formatDate: _formatDate,
        onClose: () => Navigator.pop(ctx),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final OfferItem offer;
  final String Function(String?) formatDate;
  final VoidCallback onTap;

  const _OfferCard({
    required this.offer,
    required this.formatDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = offer.image_1 != null && offer.image_1!.isNotEmpty
        ? resolveImageUrl(offer.image_1)
        : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: Icon(Icons.local_offer, color: AppColors.gray, size: 28),
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.local_offer, color: AppColors.gray, size: 28),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.local_offer, color: AppColors.gray, size: 28),
                          ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        offer.displayName,
                        style: AppTextStyles.textView(size: 17, color: AppColors.black).copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (offer.product_name != null && offer.product_name!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          offer.product_name!,
                          style: AppTextStyles.textView(size: 12, color: AppColors.gray).copyWith(
                            letterSpacing: 0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: PremiumDecorations.input(
                          fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
                        ).copyWith(
                          border: Border.all(color: const Color(0xFFFFD600), width: 2),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '$_currencySymbol${offer.offer_price ?? '-'}',
                              style: AppTextStyles.textView(size: 16, color: AppColors.black).copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (offer.original_price != null && offer.original_price!.isNotEmpty) ...[
                              const SizedBox(width: 10),
                              Text(
                                '$_currencySymbol${offer.original_price}',
                                style: AppTextStyles.textView(size: 13, color: AppColors.gray).copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Offer till ${formatDate(offer.end_date)}',
                        style: AppTextStyles.textView(size: 11, color: Colors.black.withValues(alpha: 0.6)).copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.black, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OfferDetailSheet extends StatelessWidget {
  final OfferItem offer;
  final String Function(String?) formatDate;
  final VoidCallback onClose;

  const _OfferDetailSheet({
    required this.offer,
    required this.formatDate,
    required this.onClose,
  });

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

  @override
  Widget build(BuildContext context) {
    final imageUrls = offer.imageUrls;
    final firstImage = imageUrls.isNotEmpty ? resolveImageUrl(imageUrls.first) : null;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -20,
            right: -20,
            child: ProfileBubble(size: 100, color: Color(0xFFFF9800)),
          ),
          const Positioned(
            bottom: -40,
            left: -30,
            child: ProfileBubble(size: 120, color: Color(0xFFF57C00)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 14),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Offer details',
                        style: AppTextStyles.textView(size: 18, color: AppColors.black).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onClose,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF59D).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.close_rounded, color: AppColors.black, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: PremiumDecorations.card(
                          backgroundColor: const Color(0xFFFFFDE7),
                          border: Border.all(
                            color: PremiumDecorations.cardBorder.withValues(alpha: 0.9),
                            width: 1.5,
                          ),
                        ).copyWith(
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
                                borderRadius: BorderRadius.circular(16),
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: firstImage != null && firstImage.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: firstImage,
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Center(
                                          child: Icon(Icons.local_offer, color: AppColors.gray, size: 28),
                                        ),
                                        errorWidget: (context, url, error) => const Center(
                                          child: Icon(Icons.local_offer, color: AppColors.gray, size: 28),
                                        ),
                                      )
                                    : const Center(
                                        child: Icon(Icons.local_offer, color: AppColors.gray, size: 28),
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
                                    offer.displayName,
                                    style: AppTextStyles.textView(size: 17, color: AppColors.black).copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    offer.product_name ?? 'Offer',
                                    style: AppTextStyles.textView(size: 12, color: AppColors.gray).copyWith(
                                      letterSpacing: 0.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              _buildSectionTitle('Offer details'),
                              const SizedBox(height: 6),
                              _buildField('Product', offer.product_name ?? ''),
                              const SizedBox(height: 13),
                              _buildField('Offer code', offer.code ?? offer.offer_code ?? ''),
                              const SizedBox(height: 13),
                              _buildField('Offer price', '$_currencySymbol${offer.offer_price ?? '-'}'),
                              if (offer.original_price != null && offer.original_price!.isNotEmpty) ...[
                                const SizedBox(height: 13),
                                _buildField('Original price', '$_currencySymbol${offer.original_price}'),
                              ],
                              const SizedBox(height: 13),
                              _buildField('Start date', formatDate(offer.start_date)),
                              const SizedBox(height: 13),
                              _buildField('End date', formatDate(offer.end_date)),
                              if (offer.seller_company_name != null && offer.seller_company_name!.isNotEmpty) ...[
                                const SizedBox(height: 13),
                                _buildField('Company', offer.seller_company_name!),
                              ],
                              if (offer.description != null && offer.description!.isNotEmpty) ...[
                                const SizedBox(height: 18),
                                _buildSectionTitle('Description'),
                                const SizedBox(height: 6),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                  decoration: PremiumDecorations.input(
                                    fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
                                  ).copyWith(
                                    border: Border.all(color: const Color(0xFFFFD600), width: 2),
                                  ),
                                  child: Text(
                                    offer.description!,
                                    style: AppTextStyles.editText13Ssp(color: AppColors.black).copyWith(
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }
}