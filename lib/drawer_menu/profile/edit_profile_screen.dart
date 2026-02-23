import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/buy_vehicle_api.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _dobController = TextEditingController();
  final _houseNoController = TextEditingController();
  final _streetController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _pincodeFocusNode = FocusNode();
  final _houseNoFocusNode = FocusNode();
  final _streetFocusNode = FocusNode();

  bool _isLoading = true;
  bool _isSaving = false;
  List<StateItem> _stateList = [];
  List<CityItem> _cityList = [];
  int _stateIndex = 0;
  int _cityIndex = 0;
  String _gender = '0'; // 0=Male, 1=Female
  String _savedStateId = '';
  String _savedCityId = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _addFocusListeners();
  }

  void _addFocusListeners() {
    _nameFocusNode.addListener(() => setState(() {}));
    _mobileFocusNode.addListener(() => setState(() {}));
    _emailFocusNode.addListener(() => setState(() {}));
    _pincodeFocusNode.addListener(() => setState(() {}));
    _houseNoFocusNode.addListener(() => setState(() {}));
    _streetFocusNode.addListener(() => setState(() {}));
  }

  Future<void> _loadData() async {
    await _loadProfile();
    _loadStatesAndCities();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _pincodeController.dispose();
    _dobController.dispose();
    _houseNoController.dispose();
    _streetController.dispose();
    _nameFocusNode.dispose();
    _mobileFocusNode.dispose();
    _emailFocusNode.dispose();
    _pincodeFocusNode.dispose();
    _houseNoFocusNode.dispose();
    _streetFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadStatesAndCities() async {
    try {
      final list = await BuyVehicleApi.getStateList('1');
      if (!mounted) return;
      var stateIndex = 0;
      if (list.isNotEmpty && _savedStateId.isNotEmpty) {
        for (var i = 0; i < list.length; i++) {
          if (list[i].id == _savedStateId) {
            stateIndex = i;
            break;
          }
        }
      }
      setState(() {
        _stateList = list;
        _stateIndex = stateIndex;
      });
      if (_savedStateId.isNotEmpty) {
        _loadCitiesForState(_savedStateId, cityId: _savedCityId);
      }
    } catch (_) {
      if (mounted) setState(() => _stateList = []);
    }
  }

  Future<void> _loadCitiesForState(String stateId, {String? cityId}) async {
    if (stateId.isEmpty) {
      if (mounted) setState(() => _cityList = []);
      return;
    }
    try {
      final cities = await BuyVehicleApi.getCityList(stateId);
      if (!mounted) return;
      var cityIndex = 0;
      if (cityId != null && cityId.isNotEmpty && cities.isNotEmpty) {
        for (var i = 0; i < cities.length; i++) {
          if (cities[i].id == cityId) {
            cityIndex = i;
            break;
          }
        }
      }
      setState(() {
        _cityList = cities;
        _cityIndex = cityIndex;
      });
    } catch (_) {
      if (mounted) setState(() => _cityList = []);
    }
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('newusers')
          .doc(uid)
          .get();

      if (mounted && doc.exists && doc.data() != null) {
        final d = doc.data()!;
        _nameController.text = d['name']?.toString() ?? '';
        _mobileController.text = d['mobile']?.toString() ?? '';
        _emailController.text = d['email']?.toString() ?? '';
        _pincodeController.text = d['pincode']?.toString() ?? '';
        _dobController.text = d['dob']?.toString() ?? '';
        _houseNoController.text = d['houseNo']?.toString() ?? '';
        _streetController.text = d['streetName']?.toString() ?? '';
        _gender = d['gender']?.toString() ?? '0';
        _savedStateId = d['state']?.toString() ?? d['stateId']?.toString() ?? '';
        _savedCityId = d['city']?.toString() ?? d['cityId']?.toString() ?? '';
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _onStateChanged(int index) async {
    setState(() {
      _stateIndex = index;
      _cityIndex = 0;
      _cityList = [];
    });
    if (index > 0 && _stateList[index].id != null && _stateList[index].id!.isNotEmpty) {
      try {
        final cities = await BuyVehicleApi.getCityList(_stateList[index].id!);
        if (mounted) setState(() => _cityList = cities);
      } catch (_) {
        if (mounted) setState(() => _cityList = []);
      }
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (date != null && mounted) {
      _dobController.text = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter full name');
      return;
    }
    if (mobile.isEmpty || mobile.length < 10) {
      Get.snackbar('Error', 'Please enter valid mobile number');
      return;
    }
    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter email');
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'Please sign in to update profile');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final stateId = _stateList.isEmpty || _stateIndex >= _stateList.length ? '' : _stateList[_stateIndex].id ?? '';
      final stateName = _stateList.isEmpty || _stateIndex >= _stateList.length ? '' : _stateList[_stateIndex].name ?? '';
      final cityId = _cityList.isEmpty || _cityIndex >= _cityList.length ? '' : _cityList[_cityIndex].id ?? '';
      final cityName = _cityList.isEmpty || _cityIndex >= _cityList.length ? '' : _cityList[_cityIndex].name ?? '';

      await FirebaseFirestore.instance.collection('newusers').doc(uid).set({
        'name': name,
        'mobile': mobile,
        'email': email,
        'pincode': _pincodeController.text.trim(),
        'dob': _dobController.text.trim(),
        'houseNo': _houseNoController.text.trim(),
        'streetName': _streetController.text.trim(),
        'state': stateId,
        'stateName': stateName,
        'city': cityId,
        'cityName': cityName,
        'gender': _gender,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() => _isSaving = false);
        Get.snackbar('Success', 'Profile updated successfully');
        // Close edit screen and return to ProfileScreen (which will reload data).
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
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
          'Edit profile',
          style: GoogleFonts.openSans(fontSize: 18, color: AppColors.black,
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 60),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: PremiumDecorations.card(
                              backgroundColor: const Color(0xFFFFFDE7),
                              border: Border.all(
                                color: PremiumDecorations.cardBorder.withValues(alpha: 0.9),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  blurRadius: 0,
                                  offset: const Offset(0, -1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFFF8E1),
                                        Color(0xFFFFF59D),
                                        Color(0xFFFFB74D),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.12),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        blurRadius: 0,
                                        offset: const Offset(-1, -1),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.person_rounded, color: AppColors.black, size: 28),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Update your details',
                                        style:  GoogleFonts.openSans(fontSize: 17, color: AppColors.black).copyWith(
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Keep your profile up to date for better service.',
                                        style: AppTextStyles.textView(size: 12, color: Colors.black.withValues(alpha: 0.6)).copyWith(
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            decoration: PremiumDecorations.card().copyWith(
                              border: Border.all(color: Colors.black87, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildSectionTitle('Contact'),
                                  const SizedBox(height: 6),
                                  _buildTextField('Full name', _nameController, _nameFocusNode, hint: 'Enter full name'),
                                  const SizedBox(height: 13),
                                  _buildTextField('Mobile No.', _mobileController, _mobileFocusNode, hint: 'Enter mobile number', keyboardType: TextInputType.number),
                                  const SizedBox(height: 13),
                                  _buildTextField('Email', _emailController, _emailFocusNode, hint: 'Enter email', keyboardType: TextInputType.emailAddress),
                                  const SizedBox(height: 18),
                                  _buildSectionTitle('Personal details'),
                                  const SizedBox(height: 6),
                                  _buildTextField('Pincode', _pincodeController, _pincodeFocusNode, hint: 'Enter pincode', keyboardType: TextInputType.number),
                                  const SizedBox(height: 13),
                                  _buildTextField('Date of Birth', _dobController, null, hint: 'Select date', enabled: false, onTap: _pickDate),
                                  const SizedBox(height: 13),
                                  _buildGenderField(),
                                  const SizedBox(height: 18),
                                  _buildSectionTitle('Address'),
                                  const SizedBox(height: 6),
                                  _buildTextField('House / Building No.', _houseNoController, _houseNoFocusNode, hint: 'Enter house number'),
                                  const SizedBox(height: 13),
                                  _buildTextField('Street / Area', _streetController, _streetFocusNode, hint: 'Enter street / area'),
                                  const SizedBox(height: 18),
                                  _buildSectionTitle('Location'),
                                  const SizedBox(height: 6),
                                  _buildDropdownField('State', _buildDropdown(
                                    value: _stateList.isEmpty || _stateIndex >= _stateList.length
                                        ? 'Select State'
                                        : (_stateList[_stateIndex].name ?? 'Select State'),
                                    onTap: () => _showStatePicker(),
                                  )),
                                  const SizedBox(height: 13),
                                  _buildDropdownField('City', _buildDropdown(
                                    value: _cityList.isEmpty || _cityIndex >= _cityList.length
                                        ? 'Select City'
                                        : (_cityList[_cityIndex].name ?? 'Select City'),
                                    onTap: () => _showCityPicker(),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _save,
                              style: PremiumDecorations.primaryButtonStyle,
                              child: _isSaving
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.black,
                                      ),
                                    )
                                  : const Text('Save changes'),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.textView(
          size: 11,
          color: Colors.black.withValues(alpha: 0.6),
        ).copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, FocusNode? focusNode, {String? hint, TextInputType? keyboardType, bool enabled = true, VoidCallback? onTap}) {
    final isFocused = focusNode?.hasFocus ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            label,
            style: AppTextStyles.textView13Ssp(color: Colors.black.withValues(alpha: 0.65)).copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        GestureDetector(
          onTap: enabled ? null : (onTap ?? () {}),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: PremiumDecorations.input(
              fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
            ).copyWith(
              border: Border.all(
                color: isFocused ? PremiumDecorations.primaryButtonBorder : const Color(0xFFFFD600),
                width: 2,
              ),
            ),
            child: enabled
                ? TextField(
                    controller: controller,
                    focusNode: focusNode,
                    keyboardType: keyboardType,
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
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.text.isEmpty ? (hint ?? '') : controller.text,
                          style: AppTextStyles.editText13Ssp(
                            color: controller.text.isEmpty ? AppColors.gray : AppColors.black,
                          ).copyWith(
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.black),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            'Gender',
            style: AppTextStyles.textView13Ssp(color: Colors.black.withValues(alpha: 0.65)).copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: PremiumDecorations.input(
            fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
          ).copyWith(
            border: Border.all(color: const Color(0xFFFFD600), width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    'Male',
                    style: AppTextStyles.textView(size: 13, color: AppColors.black).copyWith(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  value: '0',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v ?? '0'),
                  activeColor: PremiumDecorations.primaryButton,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    'Female',
                    style: AppTextStyles.textView(size: 13, color: AppColors.black).copyWith(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  value: '1',
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v ?? '1'),
                  activeColor: PremiumDecorations.primaryButton,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, Widget dropdown) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(
            label,
            style: AppTextStyles.textView13Ssp(color: Colors.black.withValues(alpha: 0.65)).copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        dropdown,
      ],
    );
  }

  Widget _buildDropdown({required String value, required VoidCallback onTap}) {
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
                value,
                style: AppTextStyles.editText13Ssp(color: AppColors.black).copyWith(
                  fontSize: 14,
                  height: 1.4,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down_rounded, color: PremiumDecorations.primaryButton, size: 24),
          ],
        ),
      ),
    );
  }

  void _showStatePicker() {
    final list = _stateList.isEmpty ? [StateItem(id: '', name: 'Select State')] : _stateList;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SizedBox(
        height: 300,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(list[i].name ?? ''),
            onTap: () {
              if (_stateList.isNotEmpty) _onStateChanged(i);
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
            onTap: () {
              setState(() => _cityIndex = i);
              Navigator.pop(ctx);
            },
          ),
        ),
      ),
    );
  }
}