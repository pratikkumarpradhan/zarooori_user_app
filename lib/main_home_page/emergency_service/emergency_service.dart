import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/buy_vehicle_api.dart';
import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
import 'package:zarooori_user/book_appointment/book_appointment_screen.dart';
import 'package:zarooori_user/company/company_detail_screen.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/models/product_model.dart';


class EmergencyServicesScreen extends StatefulWidget {
  final ProductRequest productRequest;

  const EmergencyServicesScreen({super.key, required this.productRequest});

  @override
  State<EmergencyServicesScreen> createState() =>
      _EmergencyServicesScreenState();
}

class _EmergencyServicesScreenState extends State<EmergencyServicesScreen> {
  bool _isLoading = true;
  String? _errorMsg;
  List<CompanyDetails> _companies = [];
  List<CompanyDetails> _filtered = [];
  final TextEditingController _searchController = TextEditingController();
  int _stateIndex = 0;
  int _cityIndex = 0;
  List<StateItem> _stateList = [StateItem(id: '', name: 'All States')];
  List<CityItem> _cityList = [CityItem(id: '0', name: 'All Cities')];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadStates();
    _loadCompanies();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStates() async {
    try {
      final list = await BuyVehicleApi.getStateList('1');
      if (mounted) {
        setState(() {
          _stateList = [StateItem(id: '', name: 'All States'), ...list];
        });
      }
    } catch (_) {
      if (mounted)
        setState(() => _stateList = [StateItem(id: '', name: 'All States')]);
    }
  }

  Future<void> _onStateChanged(int index) async {
    setState(() {
      _stateIndex = index;
      _cityIndex = 0;
      _cityList = [CityItem(id: '0', name: 'All Cities')];
    });
    if (index > 0 &&
        _stateList[index].id != null &&
        _stateList[index].id!.isNotEmpty) {
      try {
        final cities = await BuyVehicleApi.getCityList(_stateList[index].id!);
        if (mounted) {
          setState(() {
            _cityList = [CityItem(id: '0', name: 'All Cities'), ...cities];
          });
        }
      } catch (_) {
        if (mounted)
          setState(() => _cityList = [CityItem(id: '0', name: 'All Cities')]);
      }
    }
    _loadCompanies();
  }

  Future<void> _onCityChanged(int index) async {
    setState(() => _cityIndex = index);
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    final cityId = _cityList.isEmpty || _cityIndex >= _cityList.length
        ? '0'
        : (_cityList[_cityIndex].id ?? '0');
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final req = ProductRequest(
        master_category_id: widget.productRequest.master_category_id ?? '5',
        master_subcategory_id: widget.productRequest.master_subcategory_id,
        city_id: cityId,
      );
      final list = await VehicleInsuranceApi.getCompanyList(req);
      if (!mounted) return;
      setState(() {
        _companies = list;
        _filtered = List.from(list);
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

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filtered = List.from(_companies));
    } else {
      setState(() {
        _filtered = _companies.where((c) => _matchesSearch(c, q)).toList();
      });
    }
  }

  bool _matchesSearch(CompanyDetails c, String q) {
    final name = (c.company_name ?? '').toLowerCase();
    final mobile =
        (c.company_mobile ?? c.company_alt_mobile ?? c.company_phone ?? '')
            .toLowerCase();
    final email = (c.company_email_id ?? '').toLowerCase();
    final owner = (c.owner_name ?? '').toLowerCase();
    final website = (c.company_website ?? '').toLowerCase();
    return name.contains(q) ||
        mobile.contains(q) ||
        email.contains(q) ||
        owner.contains(q) ||
        website.contains(q);
  }

  void _onCompanyTap(CompanyDetails company) {
    Get.to(
      () => CompanyDetailScreen(
        companyId: company.id ?? '',
        mainCatId: widget.productRequest.master_category_id ?? '5',
      ),
    );
  }

  void _onBookAppointment(CompanyDetails company) {
    Get.to(
      () => BookAppointmentScreen(
        sellerCompanyId: company.id ?? '',
        sellerId: company.seller_id ?? '',
        companyName: company.company_name ?? '',
      ),
    );
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
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          'Emergency Services',
          style: GoogleFonts.openSans(
            fontSize: 18,
            color: AppColors.black,
          ).copyWith(fontWeight: FontWeight.w600),
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
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                color: AppColors.black,
                                height: 1.4,
                              ),
                              decoration: PremiumDecorations.textField(
                                hintText: 'Search by name, mobile, email',
                                prefixIcon: const Icon(
                                  Icons.search_rounded,
                                  color: AppColors.black,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdown(
                                    value:
                                        _stateList.isEmpty ||
                                            _stateIndex >= _stateList.length
                                        ? 'All States'
                                        : (_stateList[_stateIndex].name ??
                                              'All States'),
                                    onTap: () => _showStatePicker(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildDropdown(
                                    value:
                                        _cityList.isEmpty ||
                                            _cityIndex >= _cityList.length
                                        ? 'All Cities'
                                        : (_cityList[_cityIndex].name ??
                                              'All Cities'),
                                    onTap: () => _showCityPicker(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.black,
                            ),
                          )
                        : _errorMsg != null && _companies.isEmpty
                        ? _buildErrorCard()
                        : _filtered.isEmpty
                        ? _buildEmptyCard()
                        : _buildList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1.5),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _errorMsg!,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 14,
                color: AppColors.black,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadCompanies,
              style: PremiumDecorations.primaryButtonStyle,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF59D).withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFD600), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.medical_services_outlined,
                size: 56,
                color: AppColors.black.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No emergency service providers found',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: AppColors.black,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({required String value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: PremiumDecorations.input(
          fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
        ).copyWith(
          border: Border.all(color: const Color(0xFFFFD600), width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.openSans(
                  fontSize: 13,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: PremiumDecorations.primaryButton,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _showStatePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFDE7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _stateList.length,
          itemBuilder: (_, i) {
            final isSelected = i == _stateIndex;
            return Material(
              color: isSelected
                  ? const Color(0xFFFFF59D).withValues(alpha: 0.6)
                  : Colors.transparent,
              child: InkWell(
                onTap: () {
                  _onStateChanged(i);
                  Navigator.pop(ctx);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _stateList[i].name ?? '',
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded, color: Color(0xFFF57C00), size: 22),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCityPicker() {
    if (_cityList.isEmpty) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Color(0xFFFFFDE7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _cityList.length,
          itemBuilder: (_, i) {
            final isSelected = i == _cityIndex;
            return Material(
              color: isSelected
                  ? const Color(0xFFFFF59D).withValues(alpha: 0.6)
                  : Colors.transparent,
              child: InkWell(
                onTap: () {
                  _onCityChanged(i);
                  Navigator.pop(ctx);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _cityList[i].name ?? '',
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded, color: Color(0xFFF57C00), size: 22),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: _filtered.length,
      itemBuilder: (_, i) => _CompanyCard(
        company: _filtered[i],
        onTap: () => _onCompanyTap(_filtered[i]),
        onBookAppointment: () => _onBookAppointment(_filtered[i]),
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final CompanyDetails company;
  final VoidCallback onTap;
  final VoidCallback onBookAppointment;

  const _CompanyCard({
    required this.company,
    required this.onTap,
    required this.onBookAppointment,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = company.image != null && company.image!.isNotEmpty
        ? resolveImageUrl(company.image!)
        : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.5),
            blurRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: const Color(0xFFFFD600).withValues(alpha: 0.3),
          highlightColor: const Color(0xFFFFF59D).withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (c, u) => Container(
                                color: const Color(0xFFFFF8E1),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              errorWidget: (c, u, e) => Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        company.company_name ?? '-',
                        style: GoogleFonts.openSans(
                          fontSize: 17,
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (company.owner_name != null &&
                          company.owner_name!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Owner: ${company.owner_name}',
                          style: GoogleFonts.openSans(
                            fontSize: 12,
                            color: AppColors.gray,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (company.contactNumber != null &&
                          company.contactNumber!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF59D).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFFFD600),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone_rounded,
                                size: 16,
                                color: AppColors.black.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  company.contactNumber!,
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onBookAppointment,
                          style: PremiumDecorations.primaryButtonStyle.copyWith(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            ),
                          ),
                          child: const Text('Book Appointment'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}