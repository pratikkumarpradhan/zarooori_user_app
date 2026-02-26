import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zarooori_user/api_services/buy_vehicle_api.dart';
import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/models/product_model.dart';

class SearchInsuranceScreen extends StatefulWidget {
  final ProductRequest? initialRequest;

  const SearchInsuranceScreen({super.key, this.initialRequest});

  @override
  State<SearchInsuranceScreen> createState() => _SearchInsuranceScreenState();
}

class _SearchInsuranceScreenState extends State<SearchInsuranceScreen> {
  bool _isLoading = true;

  List<BrandsTypesModels> _brandsList = [];
  List<YearItem> _yearsList = [];
  List<SubCategory> _insuranceTypes = [];
  List<StateItem> _stateList = [];
  List<CityItem> _cityList = [];

  int _brandIndex = 0;
  int _typeIndex = 0;
  int _modelIndex = 0;
  int _yearIndex = 0;
  int _insuranceIndex = 0;
  int _stateIndex = 0;
  int _cityIndex = 0;

  String _vehicleCatId = '1';

  @override
  void initState() {
    super.initState();
    if (widget.initialRequest != null) {
      _vehicleCatId = widget.initialRequest!.vehicle_category_id ?? '1';
    }
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        BuyVehicleApi.getBrandsTypesModels(_vehicleCatId),
        BuyVehicleApi.getYearList(),
        VehicleInsuranceApi.getInsuranceSubCategories(),
      ]);
      if (!mounted) return;
      setState(() {
        _brandsList = results[0] as List<BrandsTypesModels>;
        _yearsList = results[1] as List<YearItem>;
        _insuranceTypes = results[2] as List<SubCategory>;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  void _onSearch() {
    final req = ProductRequest(
      master_category_id: '4',
      vehicle_category_id: _vehicleCatId,
      vehicle_company: _brandsList.isNotEmpty && _brandIndex < _brandsList.length
          ? _brandsList[_brandIndex].vehicle_brand_id
          : null,
      vehicle_type: _brandsList.isNotEmpty &&
              _brandIndex < _brandsList.length &&
              _brandsList[_brandIndex].type_list.isNotEmpty &&
              _typeIndex < _brandsList[_brandIndex].type_list.length
          ? _brandsList[_brandIndex].type_list[_typeIndex].vehicle_type_id
          : null,
      vehicle_model: _brandsList.isNotEmpty &&
              _brandIndex < _brandsList.length &&
              _brandsList[_brandIndex].type_list.isNotEmpty &&
              _typeIndex < _brandsList[_brandIndex].type_list.length
          ? (_brandsList[_brandIndex].type_list[_typeIndex].model_list.isNotEmpty &&
                  _modelIndex < _brandsList[_brandIndex].type_list[_typeIndex].model_list.length
              ? _brandsList[_brandIndex].type_list[_typeIndex].model_list[_modelIndex].vehicle_model_id
              : null)
          : null,
      vehicle_year: _yearsList.isNotEmpty && _yearIndex < _yearsList.length
          ? _yearsList[_yearIndex].id
          : null,
      master_subcategory_id: _insuranceTypes.isNotEmpty && _insuranceIndex < _insuranceTypes.length
          ? _insuranceTypes[_insuranceIndex].id
          : null,
      city_id: _cityList.isNotEmpty && _cityIndex < _cityList.length && _cityList[_cityIndex].id != '0'
          ? _cityList[_cityIndex].id ?? '0'
          : '0',
    );
    Navigator.pop(context, req);
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(
        text,
        style: AppTextStyles.textView13Ssp(color: Colors.black.withOpacity(0.65)).copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required String hint,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: PremiumDecorations.input(fillColor: const Color(0xFFFFF59D).withOpacity(0.5))
            .copyWith(border: Border.all(color: const Color(0xFFFFD600), width: 2)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value.isEmpty ? hint : value,
                style: AppTextStyles.editText13Ssp(
                  color: value.isEmpty ? AppColors.gray : AppColors.black,
                ).copyWith(fontSize: 14, height: 1.4),
              ),
            ),
            Icon(Icons.arrow_drop_down_rounded, color: PremiumDecorations.primaryButton, size: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _loadStatesAndShowPicker() async {
    if (_stateList.isEmpty) {
      try {
        final list = await BuyVehicleApi.getStateList('1');
        if (!mounted) return;
        setState(() {
          _stateList = [StateItem(id: '', name: 'All States'), ...list];
        });
      } catch (_) {
        if (mounted) setState(() => _stateList = [StateItem(id: '', name: 'All States')]);
      }
    }
    if (!mounted) return;
    _showPicker(
      items: _stateList.map((e) => e.name ?? '').toList(),
      selected: _stateIndex,
      onSelect: (i) async {
        setState(() => _stateIndex = i);
        if (i > 0 && _stateList[i].id != null && _stateList[i].id!.isNotEmpty) {
          try {
            final cities = await BuyVehicleApi.getCityList(_stateList[i].id!);
            if (mounted) {
              setState(() {
                _cityList = [CityItem(id: '0', name: 'All Cities'), ...cities];
                _cityIndex = 0;
              });
            }
          } catch (_) {
            if (mounted) setState(() => _cityList = [CityItem(id: '0', name: 'All Cities')]);
          }
        } else {
          setState(() => _cityList = [CityItem(id: '0', name: 'All Cities')]);
        }
      },
    );
  }

  void _showPicker({
    required List<String> items,
    required int selected,
    required ValueChanged<int> onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 350,
        decoration: BoxDecoration(
          color: PremiumDecorations.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: PremiumDecorations.cardBorder.withOpacity(0.8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 14),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                itemBuilder: (_, i) => InkWell(
                  onTap: () {
                    onSelect(i);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: i == selected ? const Color(0xFFFFB300).withOpacity(0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            items[i],
                            style: AppTextStyles.textView(
                              size: 14,
                              color: i == selected ? const Color(0xFFFFB300) : AppColors.black,
                            ).copyWith(
                              fontWeight: i == selected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (i == selected)
                          Icon(
                            Icons.check_circle,
                            color: const Color(0xFFFFB300),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          'Search Insurance',
          style: AppTextStyles.textView(size: 18, color: AppColors.black).copyWith(fontWeight: FontWeight.w600),
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
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.black))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: PremiumDecorations.card().copyWith(
                          border: Border.all(color: Colors.black87, width: 2),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Include some details',
                              style: AppTextStyles.textView(size: 15, color: AppColors.black).copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildLabel('Select Vehicle Company'),
                            _buildDropdown(
                              value: _brandsList.isEmpty || _brandIndex >= _brandsList.length
                                  ? ''
                                  : (_brandsList[_brandIndex].vehicle_brand_name ?? ''),
                              hint: 'Select Brand',
                              onTap: () => _showPicker(
                                items: _brandsList.map((e) => e.vehicle_brand_name ?? '').toList(),
                                selected: _brandIndex,
                                onSelect: (i) {
                                  setState(() {
                                    _brandIndex = i;
                                    _typeIndex = 0;
                                    _modelIndex = 0;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildLabel('Select Type'),
                            _buildDropdown(
                              value: _brandsList.isEmpty ||
                                      _brandIndex >= _brandsList.length ||
                                      _brandsList[_brandIndex].type_list.isEmpty ||
                                      _typeIndex >= _brandsList[_brandIndex].type_list.length
                                  ? ''
                                  : (_brandsList[_brandIndex].type_list[_typeIndex].vehicle_type_name ?? ''),
                              hint: 'Select Type',
                              onTap: () {
                                if (_brandsList.isEmpty || _brandIndex >= _brandsList.length) return;
                                final types = _brandsList[_brandIndex].type_list;
                                if (types.isEmpty) return;
                                _showPicker(
                                  items: types.map((e) => e.vehicle_type_name ?? '').toList(),
                                  selected: _typeIndex,
                                  onSelect: (i) {
                                    setState(() {
                                      _typeIndex = i;
                                      _modelIndex = 0;
                                    });
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildLabel('Select Model'),
                            _buildDropdown(
                              value: _brandsList.isEmpty ||
                                      _brandIndex >= _brandsList.length ||
                                      _brandsList[_brandIndex].type_list.isEmpty ||
                                      _typeIndex >= _brandsList[_brandIndex].type_list.length
                                  ? ''
                                  : () {
                                      final models = _brandsList[_brandIndex].type_list[_typeIndex].model_list;
                                      return models.isEmpty || _modelIndex >= models.length
                                          ? ''
                                          : (models[_modelIndex].vehicle_model_name ?? '');
                                    }(),
                              hint: 'Select Model',
                              onTap: () {
                                if (_brandsList.isEmpty ||
                                    _brandIndex >= _brandsList.length ||
                                    _brandsList[_brandIndex].type_list.isEmpty ||
                                    _typeIndex >= _brandsList[_brandIndex].type_list.length) return;

                                final models = _brandsList[_brandIndex].type_list[_typeIndex].model_list;
                                if (models.isEmpty) return;

                                _showPicker(
                                  items: models.map((e) => e.vehicle_model_name ?? '').toList(),
                                  selected: _modelIndex,
                                  onSelect: (i) => setState(() => _modelIndex = i),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      _buildLabel('Select Year'),
                                      _buildDropdown(
                                        value: _yearsList.isEmpty || _yearIndex >= _yearsList.length
                                            ? ''
                                            : (_yearsList[_yearIndex].year ?? ''),
                                        hint: 'Select Year',
                                        onTap: () => _showPicker(
                                          items: _yearsList.map((e) => e.year ?? '').toList(),
                                          selected: _yearIndex,
                                          onSelect: (i) => setState(() => _yearIndex = i),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      _buildLabel('Type of Insurance'),
                                      _buildDropdown(
                                        value: _insuranceTypes.isEmpty || _insuranceIndex >= _insuranceTypes.length
                                            ? ''
                                            : (_insuranceTypes[_insuranceIndex].sub_cat_name ?? ''),
                                        hint: 'Select Insurance Type',
                                        onTap: () => _showPicker(
                                          items: _insuranceTypes.map((e) => e.sub_cat_name ?? '').toList(),
                                          selected: _insuranceIndex,
                                          onSelect: (i) => setState(() => _insuranceIndex = i),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildLabel('State'),
                            _buildDropdown(
                              value: _stateList.isEmpty || _stateIndex >= _stateList.length
                                  ? 'All States'
                                  : (_stateList[_stateIndex].name ?? ''),
                              hint: 'All States',
                              onTap: _loadStatesAndShowPicker,
                            ),
                            const SizedBox(height: 12),
                            _buildLabel('City'),
                            _buildDropdown(
                              value: _cityList.isEmpty || _cityIndex >= _cityList.length
                                  ? 'All Cities'
                                  : (_cityList[_cityIndex].name ?? ''),
                              hint: 'All Cities',
                              onTap: () {
                                if (_cityList.isEmpty) return;
                                _showPicker(
                                  items: _cityList.map((e) => e.name ?? '').toList(),
                                  selected: _cityIndex,
                                  onSelect: (i) => setState(() => _cityIndex = i),
                                );
                              },
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _onSearch,
                                style: PremiumDecorations.primaryButtonStyle,
                                child: Text(
                                  'Search',
                                  style: AppTextStyles.textView(size: 16, color: AppColors.black)
                                      .copyWith(fontWeight: FontWeight.w600),
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
      ),
    );
  }
}