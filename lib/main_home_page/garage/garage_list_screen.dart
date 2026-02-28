import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zarooori_user/api_services/buy_vehicle_api.dart';
import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
import 'package:zarooori_user/book_appointment/book_appointment_screen.dart';
import 'package:zarooori_user/company/company_detail_screen.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/models/product_model.dart';

class GarageListScreen extends StatefulWidget {
  final ProductRequest productRequest;

  const GarageListScreen({super.key, required this.productRequest});

  @override
  State<GarageListScreen> createState() => _GarageListScreenState();
}

class _GarageListScreenState extends State<GarageListScreen> {
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
    } catch (_) {}
  }

  Future<void> _onStateChanged(int index) async {
    setState(() {
      _stateIndex = index;
      _cityIndex = 0;
      _cityList = [CityItem(id: '0', name: 'All Cities')];
    });

    if (index > 0 && _stateList[index].id!.isNotEmpty) {
      try {
        final cities =
            await BuyVehicleApi.getCityList(_stateList[index].id!);
        if (mounted) {
          setState(() {
            _cityList =
                [CityItem(id: '0', name: 'All Cities'), ...cities];
          });
        }
      } catch (_) {}
    }

    _loadCompanies();
  }

  Future<void> _onCityChanged(int index) async {
    setState(() => _cityIndex = index);
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    final cityId = _cityList[_cityIndex].id ?? '0';

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final req = ProductRequest(
        master_category_id:
            widget.productRequest.master_category_id ?? '3',
        master_subcategory_id:
            widget.productRequest.master_subcategory_id,
        city_id: cityId,
      );

      final list =
          await VehicleInsuranceApi.getCompanyList(req);

      if (!mounted) return;

      setState(() {
        _companies = list;
        _filtered = List.from(list);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg =
              e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();

    if (q.isEmpty) {
      setState(() => _filtered = List.from(_companies));
    } else {
      setState(() {
        _filtered = _companies.where((c) {
          final name = (c.company_name ?? '').toLowerCase();
          final owner = (c.owner_name ?? '').toLowerCase();
          final phone = (c.contactNumber ?? '').toLowerCase();
          return name.contains(q) ||
              owner.contains(q) ||
              phone.contains(q);
        }).toList();
      });
    }
  }

  void _onCompanyTap(CompanyDetails company) {
    Get.to(() => CompanyDetailScreen(
          companyId: company.id ?? '',
          mainCatId:
              widget.productRequest.master_category_id ?? '3',
        ));
  }

  void _onBookAppointment(CompanyDetails company) {
    Get.to(() => BookAppointmentScreen(
          sellerCompanyId: company.id ?? '',
          sellerId: company.seller_id ?? '',
          companyName: company.company_name ?? '',
        ));
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
              backgroundColor:
                  const Color(0xFFFFF59D).withOpacity(0.9),
            ),
            icon: const Icon(Icons.arrow_back,
                color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
        title: const Text(
          'Garages',
          style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w600),
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
              child: ProfileBubble(
                  size: 140, color: Color(0xFFFF9800)),
            ),
            const Positioned(
              top: 140,
              left: -40,
              child: ProfileBubble(
                  size: 110, color: Color(0xFFF57C00)),
            ),
            const Positioned(
              bottom: -60,
              left: -40,
              child: ProfileBubble(
                  size: 180, color: Color(0xFFF57C00)),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildSearchSection(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration:
                    PremiumDecorations.textField(
                  hintText:
                      'Search by name, owner, phone',
                  prefixIcon: const Icon(
                      Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      _stateList[_stateIndex].name ??
                          'All States',
                      _showStatePicker,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildDropdown(
                      _cityList[_cityIndex].name ??
                          'All Cities',
                      _showCityPicker,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: PremiumDecorations.input(
          fillColor:
              const Color(0xFFFFF59D).withOpacity(0.5),
        ).copyWith(
          border: Border.all(
              color: const Color(0xFFFFD600), width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(value,
                  overflow: TextOverflow.ellipsis),
            ),
            const Icon(Icons.arrow_drop_down_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(
              color: Colors.black));
    }

    if (_filtered.isEmpty) {
      return const Center(
        child: Text("No garages found",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600)),
      );
    }

    return ListView.builder(
      padding:
          const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: _filtered.length,
      itemBuilder: (_, i) {
        final company = _filtered[i];

        final imageUrl = company.image != null &&
                company.image!.isNotEmpty
            ? resolveImageUrl(company.image!)
            : null;

        return Container(
          margin:
              const EdgeInsets.only(bottom: 12),
          decoration:
              PremiumDecorations.card().copyWith(
            border: Border.all(
                color: Colors.black87, width: 2),
            color: Colors.white,
          ),
          child: InkWell(
            borderRadius:
                BorderRadius.circular(24),
            onTap: () =>
                _onCompanyTap(company),
            child: Padding(
              padding:
                  const EdgeInsets.all(18),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(16),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          company.company_name ??
                              "-",
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          company.owner_name ??
                              "",
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                _onBookAppointment(
                                    company),
                            style: PremiumDecorations
                                .primaryButtonStyle,
                            child: const Text(
                                "Book Appointment"),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showStatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView.builder(
        itemCount: _stateList.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(
              _stateList[i].name ?? ''),
          onTap: () {
            _onStateChanged(i);
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  void _showCityPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView.builder(
        itemCount: _cityList.length,
        itemBuilder: (_, i) => ListTile(
          title:
              Text(_cityList[i].name ?? ''),
          onTap: () {
            _onCityChanged(i);
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }
}