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
        master_category_id: widget.productRequest.master_category_id ?? '3',
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
    final mobile = (c.company_mobile ?? c.company_alt_mobile ?? c.company_phone ?? '').toLowerCase();
    final email = (c.company_email_id ?? '').toLowerCase();
    final owner = (c.owner_name ?? '').toLowerCase();
    final website = (c.company_website ?? '').toLowerCase();
    return name.contains(q) || mobile.contains(q) || email.contains(q) || owner.contains(q) || website.contains(q);
  }

  void _onCompanyTap(CompanyDetails company) {
    Get.to(() => CompanyDetailScreen(
          companyId: company.id ?? '',
          mainCatId: widget.productRequest.master_category_id ?? '3',
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
      backgroundColor: AppColors.purple700,
      appBar: AppBar(
        backgroundColor: AppColors.purple700,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Garages',
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
                hintText: 'Search by name, mobile, email',
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
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                : _errorMsg != null && _companies.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_errorMsg!, textAlign: TextAlign.center, style: AppTextStyles.textView(size: 14, color: AppColors.black)),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: _loadCompanies, child: const Text('Retry')),
                          ],
                        ),
                      )
                    : _filtered.isEmpty
                        ? Center(
                            child: Text(
                              'No garages found',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.textView(size: 14, color: AppColors.black),
                            ),
                          )
                        : _buildList(),
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

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
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