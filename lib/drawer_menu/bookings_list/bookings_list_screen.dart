import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/bookings_firestore.dart';
import 'package:zarooori_user/authentication/local/local_auth.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/models/product_model.dart';

class BookingListScreen extends StatefulWidget {
  final bool showBackButton;

  const BookingListScreen({super.key, this.showBackButton = true});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> with WidgetsBindingObserver {
  List<BookingItem> _bookings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBookings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadBookings();
    }
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = await LocalAuthHelper.getUserId();
      if (userId == null || userId.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = 'Please login to view your bookings';
            _bookings = [];
          });
        }
        return;
      }

      final list = await BookingsFirestore.getMyBookings(userId);
      if (mounted) {
        setState(() {
          _bookings = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString().replaceAll('Exception: ', '');
          _bookings = [];
        });
      }
    }
  }

  Future<void> _cancelBooking(BookingItem item) async {
    final userId = await LocalAuthHelper.getUserId();
    if (userId == null || item.id == null) return;
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Cancel booking?'),
        content: Text(
          'Cancel appointment with ${item.company_name ?? 'this company'} on ${item.appointment_date ?? ''} at ${item.appointment_time ?? ''}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Yes, cancel'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    try {
      await BookingsFirestore.cancelBooking(userId, item.id!);
      if (mounted) {
        Get.snackbar(
          'Cancelled',
          'Booking cancelled',
          backgroundColor: AppColors.white,
          colorText: AppColors.black,
          snackPosition: SnackPosition.BOTTOM,
        );
        _loadBookings();
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    final parts = date.split('-');
    if (parts.length >= 3) {
      final y = parts[0], m = parts[1], d = parts[2];
      return '$d/$m/$y';
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: widget.showBackButton
            ? Container(
                margin: const EdgeInsets.only(left: 8),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF59D).withValues(alpha: 0.9),
                    padding: const EdgeInsets.all(8),
                  ),
                  icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 20),
                  onPressed: () => Get.back(),
                ),
              )
            : null,
        title: Text(
          'My Bookings',
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _error != null
                              ? _buildErrorState()
                              : _bookings.isEmpty
                                  ? _buildEmptyState()
                                  : _buildBookingsList(),
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

  Widget _buildErrorState() {
    return Center(
      child: Container(
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error ?? 'An error occurred',
              style: AppTextStyles.textView(size: 14, color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBookings,
              style: PremiumDecorations.primaryButtonStyle,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.event_busy, size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text(
              'No bookings yet',
              style:  GoogleFonts.openSans(fontSize: 16, color: AppColors.black).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Book an appointment from Emergency Services, Garage, Breakdown or other services to see them here.',
              style: AppTextStyles.textView(size: 14, color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    return RefreshIndicator(
      onRefresh: _loadBookings,
      color: AppColors.black,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: _bookings.length,
        itemBuilder: (context, index) => _BookingCard(
          item: _bookings[index],
          formatDate: _formatDate,
          onCancel: () => _cancelBooking(_bookings[index]),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingItem item;
  final String Function(String?) formatDate;
  final VoidCallback onCancel;

  const _BookingCard({
    required this.item,
    required this.formatDate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF59D).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.calendar_today, color: AppColors.black, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.company_name ?? 'Appointment',
                        style: AppTextStyles.textView(size: 16, color: AppColors.black).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatDate(item.appointment_date)} at ${item.appointment_time ?? '-'}',
                        style: AppTextStyles.textView(size: 13, color: AppColors.gray),
                      ),
                      if (item.vehicle_number != null && item.vehicle_number!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'Vehicle: ${item.vehicle_number}',
                            style: AppTextStyles.textView(size: 12, color: AppColors.gray),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (item.status ?? 'confirmed').toUpperCase(),
                    style: AppTextStyles.textView(size: 11, color: AppColors.green).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel_outlined, size: 18, color: AppColors.red),
                  label: Text(
                    'Cancel',
                    style: AppTextStyles.textView(size: 13, color: AppColors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}