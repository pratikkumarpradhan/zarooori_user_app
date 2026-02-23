import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zarooori_user/api_services/buy_vehicle_api.dart';
import 'package:zarooori_user/api_services/courier_api.dart';
import 'package:zarooori_user/authentication/local/local_auth.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/main_home_page/chat_list/chat_list_screen.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/models/product_model.dart';



class AddCourierDetailsScreen extends StatefulWidget {
  final CourierDetails courierDetails;

  const AddCourierDetailsScreen({super.key, required this.courierDetails});

  @override
  State<AddCourierDetailsScreen> createState() => _AddCourierDetailsScreenState();
}

class _AddCourierDetailsScreenState extends State<AddCourierDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _dimensionsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _fromNameController = TextEditingController();
  final _fromMobileController = TextEditingController();
  final _fromHouseController = TextEditingController();
  final _fromStreetController = TextEditingController();
  final _fromPincodeController = TextEditingController();
  final _toNameController = TextEditingController();
  final _toMobileController = TextEditingController();
  final _toHouseController = TextEditingController();
  final _toStreetController = TextEditingController();
  final _toPincodeController = TextEditingController();

  List<StateItem> _fromStates = [];
  List<CityItem> _fromCities = [];
  List<StateItem> _toStates = [];
  List<CityItem> _toCities = [];
  int _fromStateIndex = 0;
  int _fromCityIndex = 0;
  int _toStateIndex = 0;
  int _toCityIndex = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _weightController.dispose();
    _dimensionsController.dispose();
    _descriptionController.dispose();
    _fromNameController.dispose();
    _fromMobileController.dispose();
    _fromHouseController.dispose();
    _fromStreetController.dispose();
    _fromPincodeController.dispose();
    _toNameController.dispose();
    _toMobileController.dispose();
    _toHouseController.dispose();
    _toStreetController.dispose();
    _toPincodeController.dispose();
    super.dispose();
  }

  Future<void> _loadStates() async {
    try {
      final states = await BuyVehicleApi.getStateList('1');
      if (mounted) {
        setState(() {
          _fromStates = [StateItem(id: '', name: 'Select State'), ...states];
          _toStates = [StateItem(id: '', name: 'Select State'), ...states];
          _fromCities = [CityItem(id: '', name: 'Select City')];
          _toCities = [CityItem(id: '', name: 'Select City')];
        });
      }
    } catch (_) {}
  }

  Future<void> _loadFromCities(String stateId) async {
    if (stateId.isEmpty) {
      setState(() {
        _fromCities = [CityItem(id: '', name: 'Select City')];
        _fromCityIndex = 0;
      });
      return;
    }
    try {
      final cities = await BuyVehicleApi.getCityList(stateId);
      if (mounted) {
        setState(() {
          _fromCities = [CityItem(id: '', name: 'Select City'), ...cities];
          _fromCityIndex = 0;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _fromCities = [CityItem(id: '', name: 'Select City')]);
    }
  }

  Future<void> _loadToCities(String stateId) async {
    if (stateId.isEmpty) {
      setState(() {
        _toCities = [CityItem(id: '', name: 'Select City')];
        _toCityIndex = 0;
      });
      return;
    }
    try {
      final cities = await BuyVehicleApi.getCityList(stateId);
      if (mounted) {
        setState(() {
          _toCities = [CityItem(id: '', name: 'Select City'), ...cities];
          _toCityIndex = 0;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _toCities = [CityItem(id: '', name: 'Select City')]);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = await LocalAuthHelper.getUserId();
    if (userId == null || userId.isEmpty) {
      Get.snackbar('Login Required', 'Please login to send delivery request');
      return;
    }

    setState(() => _loading = true);
    final details = CourierDetails(
      user_id: userId,
      seller_id: widget.courierDetails.seller_id,
      seller_name: widget.courierDetails.seller_name,
      seller_company_id: widget.courierDetails.seller_company_id,
      seller_company_name: widget.courierDetails.seller_company_name,
      item_name: _itemNameController.text.trim(),
      weight: _weightController.text.trim(),
      dimensions: _dimensionsController.text.trim(),
      description: _descriptionController.text.trim(),
      from_person_name: _fromNameController.text.trim(),
      from_mobile: _fromMobileController.text.trim(),
      from_state_id: _fromStateIndex > 0 && _fromStateIndex < _fromStates.length ? _fromStates[_fromStateIndex].id : '',
      from_city_id: _fromCityIndex > 0 && _fromCityIndex < _fromCities.length ? _fromCities[_fromCityIndex].id : '',
      from_house_no: _fromHouseController.text.trim(),
      from_street_name: _fromStreetController.text.trim(),
      from_pincode: _fromPincodeController.text.trim(),
      to_person_name: _toNameController.text.trim(),
      to_mobile: _toMobileController.text.trim(),
      to_state_id: _toStateIndex > 0 && _toStateIndex < _toStates.length ? _toStates[_toStateIndex].id : '',
      to_city_id: _toCityIndex > 0 && _toCityIndex < _toCities.length ? _toCities[_toCityIndex].id : '',
      to_house_no: _toHouseController.text.trim(),
      to_street_name: _toStreetController.text.trim(),
      to_pincode: _toPincodeController.text.trim(),
    );

    try {
      final result = await CourierApi.addCourierDetails(details);
      if (!mounted) return;
      setState(() => _loading = false);
      if (result != null) {
        Get.snackbar('Success', 'Delivery request sent successfully');
        Get.offAll(() => const ChatListScreen());
      } else {
        Get.snackbar('Error', 'Failed to send request');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        title: Text('Add Delivery Details', style: AppTextStyles.textView(size: 18, color: AppColors.black)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.purple700))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Item Details', style: AppTextStyles.semibold14(color: AppColors.purple700)),
                    const SizedBox(height: 8),
                    _buildField(_itemNameController, 'Item name', required: true),
                    const SizedBox(height: 12),
                    _buildField(_weightController, 'Weight (kg)', required: true),
                    const SizedBox(height: 12),
                    _buildField(_dimensionsController, 'Dimensions (L x W x H)'),
                    const SizedBox(height: 12),
                    _buildField(_descriptionController, 'Description', required: true, maxLines: 3),
                    const SizedBox(height: 24),
                    Text('From Address', style: AppTextStyles.semibold14(color: AppColors.purple700)),
                    const SizedBox(height: 8),
                    _buildField(_fromNameController, 'Person name', required: true),
                    const SizedBox(height: 12),
                    _buildField(_fromMobileController, 'Mobile', required: true, keyboardType: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildDropdown('State', _fromStates, _fromStateIndex, (i) async {
                      setState(() => _fromStateIndex = i);
                      if (i > 0 && _fromStates[i].id != null) await _loadFromCities(_fromStates[i].id!);
                    }),
                    const SizedBox(height: 12),
                    _buildDropdown('City', _fromCities, _fromCityIndex, (i) => setState(() => _fromCityIndex = i)),
                    const SizedBox(height: 12),
                    _buildField(_fromHouseController, 'House/ Building no', required: true),
                    const SizedBox(height: 12),
                    _buildField(_fromStreetController, 'Street name', required: true),
                    const SizedBox(height: 12),
                    _buildField(_fromPincodeController, 'Pincode', required: true, keyboardType: TextInputType.number),
                    const SizedBox(height: 24),
                    Text('To Address', style: AppTextStyles.semibold14(color: AppColors.purple700)),
                    const SizedBox(height: 8),
                    _buildField(_toNameController, 'Person name', required: true),
                    const SizedBox(height: 12),
                    _buildField(_toMobileController, 'Mobile', required: true, keyboardType: TextInputType.phone),
                    const SizedBox(height: 12),
                    _buildDropdown('State', _toStates, _toStateIndex, (i) async {
                      setState(() => _toStateIndex = i);
                      if (i > 0 && _toStates[i].id != null) await _loadToCities(_toStates[i].id!);
                    }),
                    const SizedBox(height: 12),
                    _buildDropdown('City', _toCities, _toCityIndex, (i) => setState(() => _toCityIndex = i)),
                    const SizedBox(height: 12),
                    _buildField(_toHouseController, 'House/ Building no', required: true),
                    const SizedBox(height: 12),
                    _buildField(_toStreetController, 'Street name', required: true),
                    const SizedBox(height: 12),
                    _buildField(_toPincodeController, 'Pincode', required: true, keyboardType: TextInputType.number),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple700,
                          foregroundColor: AppColors.black,
                        ),
                        child: const Text('Submit Request'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String hint, {
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.bgEdittext,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
          : null,
    );
  }

  Widget _buildDropdown(
    String label,
    List<dynamic> items,
    int selected,
    ValueChanged<int> onSelect,
  ) {
    final names = List<String>.from(items.map((e) => (e as dynamic).name?.toString() ?? ''));
    return GestureDetector(
      onTap: () => _showPicker(names, selected, onSelect),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgEdittext,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selected < names.length ? names[selected] : label,
                style: AppTextStyles.textView(
                  size: 14,
                  color: (selected < names.length && names[selected].isNotEmpty) ? AppColors.black : AppColors.gray,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.black),
          ],
        ),
      ),
    );
  }

  void _showPicker(List<String> items, int selected, ValueChanged<int> onSelect) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SizedBox(
        height: 300,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(items[i]),
            selected: i == selected,
            onTap: () {
              onSelect(i);
              Navigator.pop(ctx);
            },
          ),
        ),
      ),
    );
  }
}