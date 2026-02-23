import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zarooori_user/api_services/buy_vehicle_api.dart';
import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
import 'package:zarooori_user/book_appointment/book_appointment_screen.dart';
import 'package:zarooori_user/company/company_detail_screen.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/models/product_model.dart';
import 'package:zarooori_user/products/product_detail_screen.dart';


class HeavyEquipmentScreen extends StatefulWidget {
  final ProductRequest productRequest;

  const HeavyEquipmentScreen({super.key, required this.productRequest});

  @override
  State<HeavyEquipmentScreen> createState() => _HeavyEquipmentScreenState();
}

class _HeavyEquipmentScreenState extends State<HeavyEquipmentScreen> {
  bool _isLoading = true;
  String? _errorMsg;
  List<dynamic> _items = [];
  List<dynamic> _filtered = [];
  final TextEditingController _searchController = TextEditingController();
  int _stateIndex = 0;
  int _cityIndex = 0;
  List<StateItem> _stateList = [StateItem(id: '', name: 'All States')];
  List<CityItem> _cityList = [CityItem(id: '0', name: 'All Cities')];
  bool _isCompanyList = false;

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
    } catch (_) {
      if (mounted) setState(() => _stateList = [StateItem(id: '', name: 'All States')]);
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
          setState(() {
            _cityList = [CityItem(id: '0', name: 'All Cities'), ...cities];
          });
        }
      } catch (_) {
        if (mounted) setState(() => _cityList = [CityItem(id: '0', name: 'All Cities')]);
      }
    }
    _loadItems();
  }

  Future<void> _onCityChanged(int index) async {
    setState(() => _cityIndex = index);
    _loadItems();
  }

  Future<void> _loadItems() async {
    final cityId = _cityList.isEmpty || _cityIndex >= _cityList.length
        ? '0'
        : (_cityList[_cityIndex].id ?? '0');
    final req = ProductRequest(
      master_category_id: widget.productRequest.master_category_id ?? '8',
      vehicle_category_id: widget.productRequest.vehicle_category_id,
      city_id: cityId,
    );

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final products = await VehicleInsuranceApi.getProductList(req);
      if (!mounted) return;
      if (products.isNotEmpty) {
        setState(() {
          _items = products;
          _filtered = List.from(products);
          _isCompanyList = false;
          _isLoading = false;
        });
        return;
      }
      final companies = await VehicleInsuranceApi.getCompanyList(req);
      if (!mounted) return;
      setState(() {
        _items = companies;
        _filtered = List.from(companies);
        _isCompanyList = true;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = e.toString().replaceAll('Exception: ', '');
          _items = [];
          _filtered = [];
          _isLoading = false;
        });
        Get.snackbar('Error', _errorMsg!);
      }
    }
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filtered = List.from(_items));
    } else {
      setState(() {
        if (_isCompanyList) {
          _filtered = _items.where((c) => _matchesCompany(c as CompanyDetails, q)).toList();
        } else {
          _filtered = _items.where((p) => _matchesProduct(p as ProductList, q)).toList();
        }
      });
    }
  }

  bool _matchesCompany(CompanyDetails c, String q) {
    final name = (c.company_name ?? '').toLowerCase();
    final mobile = (c.company_mobile ?? c.company_alt_mobile ?? c.company_phone ?? '').toLowerCase();
    final email = (c.company_email_id ?? '').toLowerCase();
    final owner = (c.owner_name ?? '').toLowerCase();
    return name.contains(q) || mobile.contains(q) || email.contains(q) || owner.contains(q);
  }

  bool _matchesProduct(ProductList p, String q) {
    final company = (p.vehicle_company_name ?? '').toLowerCase();
    final model = (p.vehicle_model_name ?? '').toLowerCase();
    final type = (p.vehicle_type_name ?? '').toLowerCase();
    final code = (p.product_code ?? '').toLowerCase();
    final name = (p.product_name ?? '').toLowerCase();
    final price = (p.price ?? '').toLowerCase();
    return company.contains(q) ||
        model.contains(q) ||
        type.contains(q) ||
        code.contains(q) ||
        name.contains(q) ||
        price.contains(q);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple700,
      appBar: AppBar(
        backgroundColor: AppColors.purple700,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Heavy Equipments',
          style: AppTextStyles.textView(size: 18, color: AppColors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: _isCompanyList ? 'Search by name, mobile, email' : 'Search by name, model, price',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    value: _stateList.isEmpty || _stateIndex >= _stateList.length
                        ? 'All States'
                        : (_stateList[_stateIndex].name ?? 'All States'),
                    onTap: () => _showStatePicker(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    value: _cityList.isEmpty || _cityIndex >= _cityList.length
                        ? 'All Cities'
                        : (_cityList[_cityIndex].name ?? 'All Cities'),
                    onTap: () => _showCityPicker(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filtered.length} ${_isCompanyList ? 'companies' : 'items'}',
                style: AppTextStyles.textView(size: 13, color: AppColors.black),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                : _errorMsg != null && _items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_errorMsg!, textAlign: TextAlign.center, style: AppTextStyles.textView(size: 14, color: AppColors.black)),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: _loadItems, child: const Text('Retry')),
                          ],
                        ),
                      )
                    : _filtered.isEmpty
                        ? Center(
                            child: Text(
                              _isCompanyList ? 'No companies found' : 'No equipment found',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.textView(size: 16, color: AppColors.black),
                            ),
                          )
                        : _isCompanyList
                            ? _buildCompanyList()
                            : _buildProductGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({required String value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(child: Text(value, style: AppTextStyles.textView(size: 12, color: AppColors.black), overflow: TextOverflow.ellipsis)),
            const Icon(Icons.arrow_drop_down, color: AppColors.black),
          ],
        ),
      ),
    );
  }

  void _showStatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SizedBox(
        height: 300,
        child: ListView.builder(
          itemCount: _stateList.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(_stateList[i].name ?? ''),
            selected: i == _stateIndex,
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
    if (_cityList.isEmpty) return;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SizedBox(
        height: 300,
        child: ListView.builder(
          itemCount: _cityList.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(_cityList[i].name ?? ''),
            selected: i == _cityIndex,
            onTap: () {
              _onCityChanged(i);
              Navigator.pop(ctx);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _filtered.length,
      itemBuilder: (_, i) {
        final company = _filtered[i] as CompanyDetails;
        return _CompanyCard(
          company: company,
          onTap: () => Get.to(() => CompanyDetailScreen(
                companyId: company.id ?? '',
                mainCatId: widget.productRequest.master_category_id ?? '8',
              )),
          onBookAppointment: () => Get.to(() => BookAppointmentScreen(
                sellerCompanyId: company.id ?? '',
                sellerId: company.seller_id ?? '',
                companyName: company.company_name ?? '',
              )),
        );
      },
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _filtered.length,
      itemBuilder: (_, i) => _ProductCard(
        product: _filtered[i] as ProductList,
        onTap: () => Get.to(() => ProductDetailScreen(product: _filtered[i] as ProductList)),
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
    final imageUrl = company.image != null && company.image!.isNotEmpty ? resolveImageUrl(company.image!) : null;
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (c, u) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          errorWidget: (c, u, e) => Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                        )
                      : Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.company_name ?? '-',
                      style: AppTextStyles.semibold14(color: AppColors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (company.owner_name != null && company.owner_name!.isNotEmpty)
                      Text(
                        'Owner: ${company.owner_name}',
                        style: AppTextStyles.textView(size: 12, color: AppColors.gray),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (company.contactNumber != null && company.contactNumber!.isNotEmpty)
                      Text(
                        company.contactNumber!,
                        style: AppTextStyles.textView(size: 12, color: AppColors.gray),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: onBookAppointment,
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 6),
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
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductList product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final raw = product.image1 ?? product.image2 ?? product.image3 ?? '';
    final imageUrl = resolveImageUrl(raw);
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: imageUrl.isEmpty
                    ? Image.asset('assets/images/placeholder.png', fit: BoxFit.cover)
                    : CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (c, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (c, url, e) => Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.product_code != null && product.product_code!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Code: ${product.product_code}',
                        style: AppTextStyles.textView(size: 10, color: AppColors.gray),
                      ),
                    ),
                  Text(
                    product.product_name ?? product.vehicle_model_name ?? '-',
                    style: AppTextStyles.textView(size: 12, color: AppColors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.vehicle_company_name != null && product.vehicle_company_name!.isNotEmpty)
                    Text(
                      product.vehicle_company_name!,
                      style: AppTextStyles.textView(size: 11, color: AppColors.gray),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  if (product.price != null && product.price!.isNotEmpty)
                    Text(
                      '₹${product.price}',
                      style: AppTextStyles.semibold14(color: AppColors.orange).copyWith(fontSize: 12),
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