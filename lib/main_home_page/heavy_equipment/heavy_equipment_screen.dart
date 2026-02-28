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
import 'package:zarooori_user/products/product_detail_screen.dart';

class HeavyEquipmentScreen extends StatefulWidget {
  final ProductRequest productRequest;

  const HeavyEquipmentScreen({super.key, required this.productRequest});

  @override
  State<HeavyEquipmentScreen> createState() =>
      _HeavyEquipmentScreenState();
}

class _HeavyEquipmentScreenState extends State<HeavyEquipmentScreen> {
  bool _isLoading = true;
  String? _errorMsg;
  List<dynamic> _items = [];
  List<dynamic> _filtered = [];
  bool _isCompanyList = false;

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
    _loadItems();
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
    } catch (_) {}
  }

  Future<void> _loadItems() async {
    final cityId =
        _cityList[_cityIndex].id ?? '0';

    final req = ProductRequest(
      master_category_id:
          widget.productRequest.master_category_id ?? '8',
      vehicle_category_id:
          widget.productRequest.vehicle_category_id,
      city_id: cityId,
    );

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final products =
          await VehicleInsuranceApi.getProductList(req);

      if (products.isNotEmpty) {
        setState(() {
          _items = products;
          _filtered = List.from(products);
          _isCompanyList = false;
          _isLoading = false;
        });
        return;
      }

      final companies =
          await VehicleInsuranceApi.getCompanyList(req);

      setState(() {
        _items = companies;
        _filtered = List.from(companies);
        _isCompanyList = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final q = _searchController.text.toLowerCase();

    if (q.isEmpty) {
      setState(() => _filtered = List.from(_items));
      return;
    }

    setState(() {
      if (_isCompanyList) {
        _filtered = _items.where((c) {
          return (c.company_name ?? '')
              .toLowerCase()
              .contains(q);
        }).toList();
      } else {
        _filtered = _items.where((p) {
          return (p.product_name ?? '')
                  .toLowerCase()
                  .contains(q) ||
              (p.price ?? '')
                  .toLowerCase()
                  .contains(q);
        }).toList();
      }
    });
  }

  void _onTap(dynamic item) {
    if (_isCompanyList) {
      Get.to(() => CompanyDetailScreen(
            companyId: item.id ?? '',
            mainCatId:
                widget.productRequest.master_category_id ?? '8',
          ));
    } else {
      Get.to(() => ProductDetailScreen(product: item));
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
              backgroundColor:
                  const Color(0xFFFFF59D).withValues(alpha: 0.9),
            ),
            icon: const Icon(Icons.arrow_back,
                color: AppColors.black),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          "Heavy Equipments",
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
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
                top: -40,
                right: -30,
                child: ProfileBubble(
                    size: 140,
                    color: Color(0xFFFF9800))),
            const Positioned(
                bottom: -60,
                left: -40,
                child: ProfileBubble(
                    size: 180,
                    color: Color(0xFFF57C00))),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  /// SEARCH SAME STYLE
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration:
                          PremiumDecorations.card().copyWith(
                        border: Border.all(
                            color: Colors.black87, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            20, 16, 20, 20),
                        child: TextField(
                          controller: _searchController,
                          decoration:
                              PremiumDecorations.textField(
                            hintText:
                                'Search heavy equipment',
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(
                                    color:
                                        AppColors.black))
                        : GridView.builder(
                            padding:
                                const EdgeInsets.fromLTRB(
                                    16, 0, 16, 24),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                            itemCount: _filtered.length,
                            itemBuilder: (_, i) =>
                                _HeavyEquipmentCard(
                              item: _filtered[i],
                              isCompany: _isCompanyList,
                              onTap: () =>
                                  _onTap(_filtered[i]),
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
}

class _HeavyEquipmentCard extends StatelessWidget {
  final dynamic item;
  final bool isCompany;
  final VoidCallback onTap;

  const _HeavyEquipmentCard({
    required this.item,
    required this.isCompany,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final raw = isCompany
        ? (item.image ?? '')
        : (item.image1 ?? '');
    final imageUrl = resolveImageUrl(raw);

    final name = isCompany
        ? (item.company_name ?? '-')
        : (item.product_name ?? '-');

    final price =
        isCompany ? null : item.price;

    final code =
        isCompany ? null : item.product_code;

    return Container(
      decoration:
          PremiumDecorations.card().copyWith(
        border: Border.all(
            color: Colors.black87, width: 2),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                        top: Radius.circular(22)),
                child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: imageUrl.isEmpty
                      ? Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    if (code != null &&
                        code.isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(
                                bottom: 4),
                        child: Text(
                          'Code: $code',
                          style: GoogleFonts.openSans(
                            fontSize: 10,
                            color: AppColors.gray,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),
                    Text(
                      name,
                      style: GoogleFonts.openSans(
                        fontSize: 13,
                        color: AppColors.black,
                        fontWeight:
                            FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    if (price != null &&
                        price.isNotEmpty)
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4),
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(0xFFFFF59D)
                                  .withValues(
                                      alpha: 0.5),
                          borderRadius:
                              BorderRadius.circular(
                                  8),
                          border: Border.all(
                              color:
                                  const Color(
                                      0xFFFFD600),
                              width: 1),
                        ),
                        child: Text(
                          '₹$price',
                          style:
                              GoogleFonts.openSans(
                            fontSize: 14,
                            color:
                                AppColors.black,
                            fontWeight:
                                FontWeight.w700,
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