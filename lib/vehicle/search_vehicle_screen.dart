import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/buy_vehicle_api.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/vehicle/vehicle_details_screen.dart';

class SearchVehicleListScreen extends StatefulWidget {
  final String vehicleCatId;
  final BuyVehicle? buyVehicleFilter;

  const SearchVehicleListScreen({super.key, required this.vehicleCatId, this.buyVehicleFilter});

  @override
  State<SearchVehicleListScreen> createState() => _SearchVehicleListScreenState();
}

class _SearchVehicleListScreenState extends State<SearchVehicleListScreen> {
  bool _isLoading = true;
  String? _errorMsg;
  List<SellVehicle> _vehicles = [];
  List<SellVehicle> _filteredVehicles = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadVehicles();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filteredVehicles = List.from(_vehicles));
    } else {
      setState(() {
        _filteredVehicles = _vehicles.where((v) {
          final brand = (v.vehicle_brand_name ?? '').toLowerCase();
          final title = (v.title ?? '').toLowerCase();
          final model = (v.vehicle_model_name ?? '').toLowerCase();
          final type = (v.vehicle_type_name ?? '').toLowerCase();
          final price = (v.price ?? '').toLowerCase();
          final fuel = (v.vehicle_fuel_name ?? '').toLowerCase();
          final year = (v.vehicle_year_name ?? '').toLowerCase();
          return brand.contains(q) ||
              title.contains(q) ||
              model.contains(q) ||
              type.contains(q) ||
              price.contains(q) ||
              fuel.contains(q) ||
              year.contains(q);
        }).toList();
      });
    }
  }

  Future<void> _loadVehicles() async {
    if (widget.buyVehicleFilter == null) {
      setState(() {
        _isLoading = false;
        _vehicles = [];
        _filteredVehicles = [];
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final list = await BuyVehicleApi.searchBuyVehicles(widget.buyVehicleFilter!);
      if (!mounted) return;
      setState(() {
        _vehicles = list;
        _filteredVehicles = List.from(list);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
        Get.snackbar('Error', _errorMsg!);
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
          'Search results of vehicles',
          style: GoogleFonts.openSans(
            fontSize: 18,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFFFF59D).withValues(alpha: 0.9),
                padding: const EdgeInsets.all(8),
              ),
              icon: const Icon(Icons.filter_list, color: AppColors.black, size: 20),
              onPressed: () => Get.back(),
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    if (!_isLoading && _errorMsg == null) ...[
                      _buildSearchField(),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${_filteredVehicles.length} vehicles found',
                            style: GoogleFonts.openSans(
                              fontSize: 13,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                          : _errorMsg != null && _vehicles.isEmpty
                              ? _buildErrorState()
                              : _filteredVehicles.isEmpty
                                  ? _buildEmptyState()
                                  : ListView.builder(
                                      padding: const EdgeInsets.only(bottom: 24),
                                      itemCount: _filteredVehicles.length,
                                      itemBuilder: (_, i) => _VehicleCard(
                                        vehicle: _filteredVehicles[i],
                                        onTap: () => Get.to(() => VehicleDetailScreen(vehicle: _filteredVehicles[i])),
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

  Widget _buildSearchField() {
    return Container(
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: TextField(
        controller: _searchController,
        decoration: PremiumDecorations.textField(
          hintText: 'Search by brand, model, year, price...',
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
              _errorMsg ?? 'An error occurred',
              style: AppTextStyles.textView(size: 14, color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadVehicles,
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
            const Icon(Icons.directions_car_outlined, size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text(
              'No vehicles found',
              style: GoogleFonts.faustina(
                fontSize: 16,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria.',
              style: AppTextStyles.textView(size: 14, color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final SellVehicle vehicle;
  final VoidCallback onTap;

  const _VehicleCard({required this.vehicle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final raw = vehicle.image1 ?? vehicle.image2 ?? vehicle.image3 ?? '';
    final imageUrl = resolveImageUrl(raw);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: const Color(0xFFFFD600).withValues(alpha: 0.3),
          highlightColor: const Color(0xFFFFF59D).withValues(alpha: 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: imageUrl.isEmpty
                      ? Image.asset('assets/images/placeholder.png', fit: BoxFit.cover)
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (c, url) => Container(
                            color: const Color(0xFFFFF8E1),
                            child: const Center(child: CircularProgressIndicator(color: AppColors.black)),
                          ),
                          errorWidget: (c, url, e) => Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (vehicle.advertisement_code != null && vehicle.advertisement_code!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Ad no.: ${vehicle.advertisement_code}',
                          style: GoogleFonts.openSans(
                            fontSize: 10,
                            color: AppColors.gray,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    _buildRow('Name', vehicle.vehicle_model_name ?? vehicle.title ?? '-'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildRow('Year', vehicle.vehicle_year_name ?? '-')),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildRow('Fuel', vehicle.vehicle_fuel_name ?? '-'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            vehicle.vehicle_brand_name ?? '-',
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (vehicle.vehicle_type_name != null && vehicle.vehicle_type_name!.isNotEmpty)
                          Text(
                            '(${vehicle.vehicle_type_name})',
                            style: GoogleFonts.openSans(
                              fontSize: 11,
                              color: AppColors.gray,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF59D).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFD600), width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Price',
                            style: GoogleFonts.openSans(
                              fontSize: 11,
                              color: Colors.black.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '₹${vehicle.price ?? '-'}',
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              color: AppColors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (vehicle.created_datetime != null && vehicle.created_datetime!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Posted: ${vehicle.created_datetime}',
                          style: GoogleFonts.openSans(
                            fontSize: 10,
                            color: AppColors.gray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 44,
          child: Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 10,
              color: Colors.black.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 12,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}