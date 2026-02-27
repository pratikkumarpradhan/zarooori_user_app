import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/buy_vehicle_api.dart';
import 'package:zarooori_user/authentication/local/local_auth.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';

class SellVehicleActivityScreen extends StatefulWidget {
  final String vehicleCatId;

  const SellVehicleActivityScreen({super.key, required this.vehicleCatId});

  @override
  State<SellVehicleActivityScreen> createState() => _SellVehicleActivityScreenState();
}

class _SellVehicleActivityScreenState extends State<SellVehicleActivityScreen> {
  bool _isLoading = true;
  String? _errorMsg;

  List<BrandsTypesModels> _brandsList = [];
  List<YearItem> _yearsList = [];
  List<FuelItem> _fuelList = [];
  List<StateItem> _stateList = [];
  List<CityItem> _cityList = [];

  int _brandIndex = 0;
  int _typeIndex = 0;
  int _modelIndex = 0;
  int _yearIndex = 0;
  int _fuelIndex = 0;
  int _stateIndex = 0;
  int _cityIndex = 0;

  int? _transmission; // 0=automatic, 1=manual, null=2(none)

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final results = await Future.wait([
        BuyVehicleApi.getBrandsTypesModels(widget.vehicleCatId),
        BuyVehicleApi.getYearList(),
        BuyVehicleApi.getFuelList(),
      ]);
      if (!mounted) return;
      setState(() {
        _brandsList = results[0] as List<BrandsTypesModels>;
        _yearsList = results[1] as List<YearItem>;
        _fuelList = results[2] as List<FuelItem>;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onSubmit() async {
    final title = _titleController.text.trim();
    final price = _priceController.text.trim();
    final desc = _descController.text.trim();
    final contact = _contactController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Error', 'Please enter a title');
      return;
    }
    if (price.isEmpty) {
      Get.snackbar('Error', 'Please enter a price');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final loginData = await LocalAuthHelper.getLoginData();
      final userId = loginData?['userId'] ?? loginData?['id'] ?? '';

      String? brandId;
      String? typeId;
      String? modelId;
      String? yearId;
      String? fuelId;
      String? cityId;

      if (_brandsList.isNotEmpty && _brandIndex < _brandsList.length) {
        final brand = _brandsList[_brandIndex];
        brandId = brand.vehicle_brand_id;
        final types = brand.type_list;
        if (types.isNotEmpty && _typeIndex < types.length) {
          final t = types[_typeIndex];
          typeId = t.vehicle_type_id;
          final models = t.model_list;
          if (models.isNotEmpty && _modelIndex < models.length) {
            modelId = models[_modelIndex].vehicle_model_id;
          }
        }
      }
      if (_yearsList.isNotEmpty && _yearIndex < _yearsList.length) {
        yearId = _yearsList[_yearIndex].id;
      }
      if (_fuelList.isNotEmpty && _fuelIndex < _fuelList.length) {
        fuelId = _fuelList[_fuelIndex].id;
      }
      if (_cityList.isNotEmpty && _cityIndex < _cityList.length && _cityList[_cityIndex].id != '0') {
        cityId = _cityList[_cityIndex].id;
      }

      final payload = {
        'category': widget.vehicleCatId,
        'user_id': userId,
        'user_type': '0',
        'vehicle_brand': brandId,
        'vehicle_type': typeId,
        'vehicle_model': modelId,
        'vehicle_year': yearId,
        'vehicle_fuel': fuelId,
        'transmission': _transmission == null ? '2' : _transmission.toString(),
        'title': title,
        'price': price,
        'description': desc,
        'contact_number': contact,
        'city_id': cityId ?? '0',
      };

      final res = await BuyVehicleApi.insertSellVehicle(payload);
      if (!mounted) return;
      if (res == true) {
        Get.back();
        Get.snackbar('Success', 'Vehicle listing submitted successfully', backgroundColor: Colors.green);
      } else {
        Get.snackbar('Error', res?.toString() ?? 'Failed to submit');
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          'Sell Vehicle',
          style: GoogleFonts.openSans(fontSize: 18, color: AppColors.black).copyWith(
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
              child: _isLoading && _brandsList.isEmpty && _yearsList.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                      child: Container(
                        decoration: PremiumDecorations.card().copyWith(
                          border: Border.all(color: Colors.black87, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  'Include some details',
                                  style: AppTextStyles.semibold14(color: AppColors.black).copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              if (_errorMsg != null) ...[
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: AppColors.orange.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.orange.withValues(alpha: 0.5),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _errorMsg!,
                                          style: AppTextStyles.textView(size: 13, color: AppColors.black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: _loadData,
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 6),
                              _buildLabel('Title *'),
                              _buildTextField(_titleController, hint: 'e.g. Honda City 2020'),
                              const SizedBox(height: 13),
                              _buildLabel('Price *'),
                              _buildTextField(_priceController, hint: 'Enter price', keyboardType: TextInputType.number),
                              const SizedBox(height: 13),
                              _buildLabel('Select Brand'),
                              _buildBrandDropdown(),
                              const SizedBox(height: 13),
                              _buildLabel('Select Type'),
                              _buildTypeDropdown(),
                              const SizedBox(height: 13),
                              _buildLabel('Select Model'),
                              _buildModelDropdown(),
                              const SizedBox(height: 13),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        _buildLabel('Select Year'),
                                        _buildYearDropdown(),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        _buildLabel('Select Fuel'),
                                        _buildFuelDropdown(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 13),
                              _buildLabel('Transmission'),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: PremiumDecorations.input(
                                  fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
                                ).copyWith(
                                  border: Border.all(color: const Color(0xFFFFD600), width: 2),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildRadio('None', null),
                                    _buildRadio('Automatic', 0),
                                    _buildRadio('Manual', 1),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 13),
                              _buildLabel('State'),
                              _buildStateDropdown(),
                              const SizedBox(height: 13),
                              _buildLabel('City'),
                              _buildCityDropdown(),
                              const SizedBox(height: 13),
                              _buildLabel('Description'),
                              _buildTextField(_descController, hint: 'Describe your vehicle...', maxLines: 3),
                              const SizedBox(height: 13),
                              _buildLabel('Contact Number'),
                              _buildTextField(_contactController, hint: 'Your contact number', keyboardType: TextInputType.phone),
                              const SizedBox(height: 28),
                              SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _onSubmit,
                                  style: PremiumDecorations.primaryButtonStyle,
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.black,
                                          ),
                                        )
                                      : const Text('Submit'),
                                ),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 6),
      child: Text(
        text,
        style: AppTextStyles.textView13Ssp(color: Colors.black.withValues(alpha: 0.65)).copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {String? hint, TextInputType? keyboardType, int maxLines = 1}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: PremiumDecorations.input(
        fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
      ).copyWith(
        border: Border.all(color: const Color(0xFFFFD600), width: 2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: AppTextStyles.editText13Ssp(color: AppColors.black).copyWith(
          fontSize: 14,
          height: 1.4,
        ),
        decoration: InputDecoration(
          hintText: hint ?? '',
          hintStyle: AppTextStyles.editText13Ssp(color: AppColors.gray).copyWith(
            fontSize: 14,
            height: 1.4,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
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
                value.isEmpty ? hint : value,
                style: AppTextStyles.editText13Ssp(
                  color: value.isEmpty ? AppColors.gray : AppColors.black,
                ).copyWith(
                  fontSize: 14,
                  height: 1.4,
                ),
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

  Widget _buildBrandDropdown() {
    final val = _brandsList.isEmpty || _brandIndex >= _brandsList.length ? '' : (_brandsList[_brandIndex].vehicle_brand_name ?? '');
    return _buildDropdown(
      value: val,
      hint: 'Select Brand',
      onTap: () => _showPicker(
        items: _brandsList.map((e) => e.vehicle_brand_name ?? '').toList(),
        selected: _brandIndex,
        onSelect: (i) => setState(() {
          _brandIndex = i;
          _typeIndex = 0;
          _modelIndex = 0;
        }),
      ),
    );
  }

  Widget _buildTypeDropdown() {
    if (_brandsList.isEmpty || _brandIndex >= _brandsList.length) {
      return _buildDropdown(value: '', hint: 'Select Type', onTap: () {});
    }
    final types = _brandsList[_brandIndex].type_list;
    final val = types.isEmpty ? '' : (types[_typeIndex].vehicle_type_name ?? '');
    return _buildDropdown(
      value: val,
      hint: 'Select Type',
      onTap: () => _showPicker(
        items: types.map((e) => e.vehicle_type_name ?? '').toList(),
        selected: _typeIndex,
        onSelect: (i) => setState(() {
          _typeIndex = i;
          _modelIndex = 0;
        }),
      ),
    );
  }

  Widget _buildModelDropdown() {
    if (_brandsList.isEmpty ||
        _brandIndex >= _brandsList.length ||
        _brandsList[_brandIndex].type_list.isEmpty ||
        _typeIndex >= _brandsList[_brandIndex].type_list.length) {
      return _buildDropdown(value: '', hint: 'Select Model', onTap: () {});
    }
    final models = _brandsList[_brandIndex].type_list[_typeIndex].model_list;
    final val = models.isEmpty ? '' : (models[_modelIndex].vehicle_model_name ?? '');
    return _buildDropdown(
      value: val,
      hint: 'Select Model',
      onTap: () => _showPicker(
        items: models.map((e) => e.vehicle_model_name ?? '').toList(),
        selected: _modelIndex,
        onSelect: (i) => setState(() => _modelIndex = i),
      ),
    );
  }

  Widget _buildYearDropdown() {
    final val = _yearsList.isEmpty || _yearIndex >= _yearsList.length ? '' : (_yearsList[_yearIndex].year ?? '');
    return _buildDropdown(
      value: val,
      hint: 'Select Year',
      onTap: () => _showPicker(
        items: _yearsList.map((e) => e.year ?? '').toList(),
        selected: _yearIndex,
        onSelect: (i) => setState(() => _yearIndex = i),
      ),
    );
  }

  Widget _buildFuelDropdown() {
    final val = _fuelList.isEmpty || _fuelIndex >= _fuelList.length ? '' : (_fuelList[_fuelIndex].fuel ?? '');
    return _buildDropdown(
      value: val,
      hint: 'Select Fuel',
      onTap: () => _showPicker(
        items: _fuelList.map((e) => e.fuel ?? '').toList(),
        selected: _fuelIndex,
        onSelect: (i) => setState(() => _fuelIndex = i),
      ),
    );
  }

  Widget _buildStateDropdown() {
    final val = _stateList.isEmpty || _stateIndex >= _stateList.length ? 'All States' : (_stateList[_stateIndex].name ?? '');
    return _buildDropdown(
      value: val,
      hint: 'All States',
      onTap: () => _loadStatesAndShowPicker(),
    );
  }

  Future<void> _loadStatesAndShowPicker() async {
    if (_stateList.isEmpty) {
      try {
        final list = await BuyVehicleApi.getStateList('1');
        if (!mounted) return;
        setState(() => _stateList = [StateItem(id: '', name: 'All States'), ...list]);
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

  Widget _buildCityDropdown() {
    final val = _cityList.isEmpty || _cityIndex >= _cityList.length ? 'All Cities' : (_cityList[_cityIndex].name ?? '');
    return _buildDropdown(
      value: val,
      hint: 'All Cities',
      onTap: () {
        if (_cityList.isEmpty) return;
        _showPicker(
          items: _cityList.map((e) => e.name ?? '').toList(),
          selected: _cityIndex,
          onSelect: (i) => setState(() => _cityIndex = i),
        );
      },
    );
  }

  Widget _buildRadio(String label, int? value) {
    final isSelected = _transmission == value;
    return Flexible(
      child: InkWell(
        onTap: () => setState(() => _transmission = value),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.purple700.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<int?>(
                value: value,
                groupValue: _transmission,
                onChanged: (v) => setState(() => _transmission = v),
                activeColor: const Color(0xFFFFB300),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.openSans(fontSize:  12,
                    color: isSelected ? const Color(0xFFFFB300) : AppColors.black,
                  ).copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
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
          border: Border.all(color: PremiumDecorations.cardBorder.withValues(alpha: 0.8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
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
                color: Colors.black.withValues(alpha: 0.15),
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
                      color: i == selected
                          ? const Color(0xFFFFB300).withValues(alpha: 0.2)
                          : Colors.transparent,
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
}