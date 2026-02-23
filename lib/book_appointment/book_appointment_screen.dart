import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zarooori_user/api_services/bookings_firestore.dart';
import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
import 'package:zarooori_user/authentication/local/local_auth.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/models/product_model.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String sellerCompanyId;
  final String sellerId;
  final String companyName;

  const BookAppointmentScreen({
    super.key,
    required this.sellerCompanyId,
    required this.sellerId,
    required this.companyName,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _vehicleController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      _dateController.text = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && mounted) {
      _timeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = await LocalAuthHelper.getUserId();
    if (userId == null || userId.isEmpty) {
      Get.snackbar('Login Required', 'Please login to book appointment');
      return;
    }
    setState(() => _loading = true);
    final req = BookAppointmentRequest(
      user_id: userId,
      seller_id: widget.sellerId,
      seller_company_id: widget.sellerCompanyId,
      vehicle_category: '1',
      vehicle_number: _vehicleController.text.trim(),
      appointment_date: _dateController.text.trim(),
      appointment_time: _timeController.text.trim(),
    );
    try {
      final ok = await VehicleInsuranceApi.bookAppointment(req);
      if (!mounted) return;
      if (ok) {
        await BookingsFirestore.saveBooking(
          userId: userId,
          sellerCompanyId: widget.sellerCompanyId,
          sellerId: widget.sellerId,
          companyName: widget.companyName,
          appointmentDate: _dateController.text.trim(),
          appointmentTime: _timeController.text.trim(),
          vehicleNumber: _vehicleController.text.trim(),
        );
      }
      if (!mounted) return;
      setState(() => _loading = false);
      if (ok) {
        Get.snackbar('Success', 'Appointment booked successfully');
        Get.back();
      } else {
        Get.snackbar('Error', 'Failed to book appointment');
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
        title: Text('Book Appointment', style: AppTextStyles.textView(size: 18, color: AppColors.black)),
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
                    Text(widget.companyName, style: AppTextStyles.semibold14(color: AppColors.black)),
                    const SizedBox(height: 24),
                    _buildField(_dateController, 'Date', required: true, readOnly: true, onTap: _pickDate),
                    const SizedBox(height: 12),
                    _buildField(_timeController, 'Time', required: true, readOnly: true, onTap: _pickTime),
                    const SizedBox(height: 12),
                    _buildField(_vehicleController, 'Vehicle Number', required: true),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple700,
                          foregroundColor: AppColors.black,
                        ),
                        child: const Text('Book Appointment'),
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
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.bgEdittext,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      ),
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null : null,
    );
  }
}