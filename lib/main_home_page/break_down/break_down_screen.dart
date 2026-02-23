import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/buy_vehicle_api.dart';
import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
import 'package:zarooori_user/company/company_detail_screen.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/models/product_model.dart';

class BreakDownScreen extends StatefulWidget {
  final ProductRequest productRequest;

  const BreakDownScreen({super.key, required this.productRequest});

  @override
  State<BreakDownScreen> createState() => _BreakDownScreenState();
}

class _BreakDownScreenState extends State<BreakDownScreen> {
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
      // silent fail → keep default "All States"
    }
  }

  Future<void> _onStateChanged(int index) async {
    setState(() {
      _stateIndex = index;
      _cityIndex = 0;
      _cityList = [CityItem(id: '0', name: 'All Cities')];
    });

    if (index > 0 && _stateList[index].id != null && _stateList[index].id!.isNotEmpty) {
      try {
        final cities = await BuyVehicleApi.getCityList(_stateList[index].id!);
        if (mounted) {
          setState(() => _cityList = [CityItem(id: '0', name: 'All Cities'), ...cities]);
        }
      } catch (_) {}
    }
    _loadCompanies();
  }

  Future<void> _onCityChanged(int index) async {
    setState(() => _cityIndex = index);
    _loadCompanies();
  }

  /// Resolves vehicle selection slug (bike, car, commercial, emergency) to API subcategory ID.
  Future<String?> _resolveBreakdownSubCategoryId(String? slug) async {
    if (slug == null || slug.isEmpty) return slug;
    const slugs = ['bike', 'car', 'commercial', 'emergency'];
    if (!slugs.contains(slug)) return slug; // already an API id
    try {
      final subCats = await VehicleInsuranceApi.getSubCategories('10');
      final nameLower = slug.toLowerCase();
      for (final s in subCats) {
        final n = (s.sub_cat_name ?? '').toLowerCase();
        if (nameLower == 'bike' && (n.contains('bike') || n.contains('two wheeler') || n.contains('2 wheeler'))) return s.id;
        if (nameLower == 'car' && n.contains('car') && !n.contains('commercial')) return s.id;
        if (nameLower == 'commercial' && (n.contains('commercial') || n.contains('vehicle'))) return s.id;
        if (nameLower == 'emergency' && (n.contains('emergency') || n.contains('ambulance'))) return s.id;
      }
      // Fallback: first match by partial name
      for (final s in subCats) {
        final n = (s.sub_cat_name ?? '').toLowerCase();
        if (n.contains(nameLower)) return s.id;
      }
    } catch (_) {}
    return slug;
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
      final subCatId = await _resolveBreakdownSubCategoryId(widget.productRequest.master_subcategory_id);
      final req = ProductRequest(
        master_category_id: widget.productRequest.master_category_id ?? '10',
        master_subcategory_id: subCatId,
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
        Get.snackbar('Error', _errorMsg ?? 'Something went wrong');
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
    return [
      c.company_name,
      c.company_mobile,
      c.company_alt_mobile,
      c.company_phone,
      c.company_email_id,
      c.owner_name,
      c.company_website,
    ].any((field) => (field ?? '').toLowerCase().contains(q));
  }

  void _onCompanyTap(CompanyDetails company) {
    Get.to(() => CompanyDetailScreen(
          companyId: company.id ?? '',
          mainCatId: widget.productRequest.master_category_id ?? '10',
        ));
  }

  // Note: Book Appointment is now expected to be inside CompanyDetailScreen

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
              backgroundColor: const Color(0xFFFFF59D).withOpacity(0.9),
              padding: const EdgeInsets.all(8),
            ),
            icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          'Breakdown Services',
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
            const Positioned(top: 140, left: -40, child: ProfileBubble(size: 110, color: Color(0xFFF57C00))),
            const Positioned(bottom: 200, right: -20, child: ProfileBubble(size: 90, color: Color(0xFFFF9800))),
            const Positioned(bottom: -60, left: -40, child: ProfileBubble(size: 180, color: Color(0xFFF57C00))),
            SafeArea(child: _BodyContent()),
          ],
        ),
      ),
    );
  }

  Widget _BodyContent() {
    return Column(
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
                      hintText: 'Search by name, mobile, email, owner...',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.black,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${_filtered.length} providers',
                    style: GoogleFonts.openSans(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          value: _stateList.isEmpty || _stateIndex >= _stateList.length
                              ? 'All States'
                              : _stateList[_stateIndex].name ?? 'All States',
                          onTap: _showStatePicker,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          value: _cityList.isEmpty || _cityIndex >= _cityList.length
                              ? 'All Cities'
                              : _cityList[_cityIndex].name ?? 'All Cities',
                          onTap: _showCityPicker,
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
              ? const Center(child: CircularProgressIndicator(color: AppColors.black))
              : _errorMsg != null && _companies.isEmpty
                  ? _buildErrorCard()
                  : _filtered.isEmpty
                      ? _buildEmptyCard()
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.74,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: _filtered.length,
                          itemBuilder: (_, i) => _CompanyCard(
                            company: _filtered[i],
                            onTap: () => _onCompanyTap(_filtered[i]),
                          ),
                        ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black54, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.openSans(
                  fontSize: 13,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.black, size: 20),
          ],
        ),
      ),
    );
  }

  void _showStatePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          itemCount: _stateList.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(
              _stateList[i].name ?? '',
              style: GoogleFonts.openSans(fontSize: 15),
            ),
            selected: i == _stateIndex,
            selectedTileColor: const Color(0xFFFFF59D).withOpacity(0.4),
            onTap: () {
              _onStateChanged(i);
              Navigator.pop(ctx);
            },
          ),
        ),
      ),
    );
  }

  void _showCityPicker() {
    if (_cityList.length <= 1) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          itemCount: _cityList.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(
              _cityList[i].name ?? '',
              style: GoogleFonts.openSans(fontSize: 15),
            ),
            selected: i == _cityIndex,
            selectedTileColor: const Color(0xFFFFF59D).withOpacity(0.4),
            onTap: () {
              _onCityChanged(i);
              Navigator.pop(ctx);
            },
          ),
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
                color: Colors.red.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red.withOpacity(0.3), width: 1.5),
              ),
              child: const Icon(Icons.error_outline_rounded, size: 40, color: Colors.red),
            ),
            const SizedBox(height: 20),
            Text(
              _errorMsg ?? 'Failed to load breakdown services',
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
                color: const Color(0xFFFFF59D).withOpacity(0.5),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFD600), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.build_circle_outlined, // more appropriate for breakdown services
                size: 56,
                color: AppColors.black.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No breakdown service providers found',
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
}

class _CompanyCard extends StatelessWidget {
  final CompanyDetails company;
  final VoidCallback onTap;

  const _CompanyCard({
    required this.company,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = company.image != null && company.image!.isNotEmpty
        ? resolveImageUrl(company.image!)
        : '';

    return Container(
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
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
          splashColor: const Color(0xFFFFD600).withOpacity(0.3),
          highlightColor: const Color(0xFFFFF59D).withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: imageUrl.isEmpty
                      ? Image.asset('assets/images/placeholder.png', fit: BoxFit.cover)
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFFFFF8E1),
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/placeholder.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small ID line (similar to product code)
                    if (company.id != null && company.id!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'ID: ${company.id}',
                          style: GoogleFonts.openSans(
                            fontSize: 10,
                            color: AppColors.gray,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    Text(
                      company.company_name ?? 'Unknown Provider',
                      style: GoogleFonts.openSans(
                        fontSize: 13,
                        color: AppColors.black,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (company.owner_name?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          company.owner_name!,
                          style: GoogleFonts.openSans(
                            fontSize: 11,
                            color: AppColors.gray,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    if ((company.contactNumber?.isNotEmpty ?? false) ||
                        (company.company_mobile?.isNotEmpty ?? false))
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          company.contactNumber ?? company.company_mobile ?? '',
                          style: GoogleFonts.openSans(
                            fontSize: 11.5,
                            color: AppColors.black.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    const SizedBox(height: 8),

                    // Small tag similar to price tag in insurance screen
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF59D).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFD600), width: 1),
                      ),
                      child: Text(
                        '24×7 • Towing',
                        style: GoogleFonts.openSans(
                          fontSize: 11.5,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
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
}