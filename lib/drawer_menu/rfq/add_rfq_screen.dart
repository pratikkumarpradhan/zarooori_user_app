import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class AddRFQScreen extends StatefulWidget {
  const AddRFQScreen({super.key});

  @override
  State<AddRFQScreen> createState() => _AddRFQScreenState();
}

class _AddRFQScreenState extends State<AddRFQScreen> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();

  bool _isLoadingProfile = true;
  bool _isSending = false;

  String _name = '';
  String _mobile = '';
  String _email = '';

  String _serviceType = 'General service';
  String _preferredTime = 'Anytime';
  DateTime? _preferredDate;

  final List<String> _serviceTypes = const [
    'General service',
    'Repair / Breakdown',
    'Spare parts',
    'Tyre services',
    'Insurance / Renewal',
    'Accessories',
    'Other',
  ];

  final List<String> _timeSlots = const [
    'Anytime',
    'Morning (8 AM - 12 PM)',
    'Afternoon (12 PM - 4 PM)',
    'Evening (4 PM - 8 PM)',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _isLoadingProfile = false);
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance.collection('newusers').doc(uid).get();
      if (mounted && doc.exists && doc.data() != null) {
        final data = doc.data()!;
        _name = data['name']?.toString() ?? '';
        _mobile = data['mobile']?.toString() ?? '';
        _email = data['email']?.toString() ?? '';
      }
    } catch (_) {
      // ignore; keep defaults
    }
    if (mounted) {
      setState(() => _isLoadingProfile = false);
    }
  }

  Future<void> _pickPreferredDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _preferredDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      setState(() => _preferredDate = date);
    }
  }

  Future<void> _submitRFQ() async {
    final subject = _subjectController.text.trim();
    final description = _descriptionController.text.trim();
    final budget = _budgetController.text.trim();

    if (subject.isEmpty) {
      Get.snackbar('Missing details', 'Please enter a short subject for your request.');
      return;
    }
    if (description.isEmpty) {
      Get.snackbar('Missing details', 'Please describe what you need.');
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'Please sign in to send RFQ');
      return;
    }

    setState(() => _isSending = true);

    try {
      await FirebaseFirestore.instance.collection('rfqs').add({
        'userId': uid,
        'name': _name,
        'mobile': _mobile,
        'email': _email,
        'subject': subject,
        'description': description,
        'budget': budget,
        'serviceType': _serviceType,
        'preferredTime': _preferredTime,
        'preferredDate': _preferredDate?.millisecondsSinceEpoch,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'status': 'pending',
      });

      if (!mounted) return;

      setState(() => _isSending = false);
      Get.snackbar('Submitted', 'Your RFQ has been sent successfully.');
      Get.back(result: true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
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
          'Send RFQ',
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
              child: _isLoadingProfile
                  ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                         // const SizedBox(height: 60),
                          _buildHeaderCard(),
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
                                  _buildSectionTitle('Contact details'),
                                  const SizedBox(height: 6),
                                  _buildReadonlyField('Full name', _name),
                                  const SizedBox(height: 13),
                                  _buildReadonlyField('Mobile No.', _mobile),
                                  const SizedBox(height: 13),
                                  _buildReadonlyField('Email', _email),
                                  const SizedBox(height: 18),
                                  _buildSectionTitle('Request details'),
                                  const SizedBox(height: 6),
                                  _buildTextField('Subject', _subjectController, hint: 'Short title of your requirement'),
                                  const SizedBox(height: 13),
                                  _buildMultilineField(
                                    'Describe your requirement',
                                    _descriptionController,
                                    hint: 'Add vehicle details, issue, location, preferred brand, etc.',
                                  ),
                                  const SizedBox(height: 13),
                                  _buildTextField(
                                    'Estimated budget (optional)',
                                    _budgetController,
                                    hint: 'e.g. ₹5,000',
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 18),
                                  _buildSectionTitle('Service type'),
                                  const SizedBox(height: 6),
                                  _buildDropdown<String>(
                                    value: _serviceType,
                                    items: _serviceTypes,
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() => _serviceType = v);
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  _buildSectionTitle('Preferred date & time'),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: _pickPreferredDate,
                                          child: _buildBoxField(
                                            'Preferred date',
                                            _preferredDate == null
                                                ? 'Select date'
                                                : '${_preferredDate!.day.toString().padLeft(2, '0')}-'
                                                    '${_preferredDate!.month.toString().padLeft(2, '0')}-'
                                                    '${_preferredDate!.year}',
                                            icon: Icons.calendar_today,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _buildDropdown<String>(
                                          value: _preferredTime,
                                          items: _timeSlots,
                                          onChanged: (v) {
                                            if (v == null) return;
                                            setState(() => _preferredTime = v);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isSending ? null : _submitRFQ,
                              style: PremiumDecorations.primaryButtonStyle,
                              child: _isSending
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.black,
                                      ),
                                    )
                                  : const Text('Send request'),
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

  Widget _buildHeaderCard() {
    return Container(
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
            width: 72,
            height: 72,
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
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.4),
                  blurRadius: 0,
                  offset: const Offset(-1, -1),
                ),
              ],
            ),
            child: const Icon(Icons.description, color: AppColors.black, size: 32),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Share your requirement',
                  style:  GoogleFonts.openSans(fontSize: 16, color: AppColors.black,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Describe what you need and we will connect you with the best options.',
                  style: AppTextStyles.textView(size: 12, color: AppColors.gray).copyWith(
                    letterSpacing: 0.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadonlyField(String label, String value) {
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: PremiumDecorations.input(
            fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
          ).copyWith(
            border: Border.all(color: const Color(0xFFFFD600), width: 2),
          ),
          child: Text(
            value.isEmpty ? '-' : value,
            style: AppTextStyles.editText13Ssp(color: value.isEmpty ? AppColors.gray : AppColors.black).copyWith(
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType? keyboardType,
  }) {
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
        Container(
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
        ),
      ],
    );
  }

  Widget _buildMultilineField(
    String label,
    TextEditingController controller, {
    String? hint,
  }) {
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: PremiumDecorations.input(
            fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
          ).copyWith(
            border: Border.all(color: const Color(0xFFFFD600), width: 2),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            minLines: 3,
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
        ),
      ],
    );
  }

  Widget _buildBoxField(String label, String value, {IconData? icon}) {
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
        Container(
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
                  style: AppTextStyles.editText13Ssp(color: value == 'Select date' ? AppColors.gray : AppColors.black).copyWith(
                    fontSize: 14,
                    height: 1.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null)
                const Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.black),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: PremiumDecorations.input(
        fillColor: const Color(0xFFFFF59D).withValues(alpha: 0.5),
      ).copyWith(
        border: Border.all(color: const Color(0xFFFFD600), width: 2),
      ),
      child: DropdownButton<T>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(16),
        icon: Icon(Icons.arrow_drop_down_rounded, color: PremiumDecorations.primaryButton, size: 24),
        style: AppTextStyles.editText13Ssp(color: AppColors.black).copyWith(
          fontSize: 14,
          height: 1.4,
        ),
        onChanged: _isSending ? null : onChanged,
        items: items
            .map(
              (e) => DropdownMenuItem<T>(
                value: e,
                child: Text(e.toString()),
              ),
            )
            .toList(),
      ),
    );
  }
}