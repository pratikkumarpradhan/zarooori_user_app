import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/packages_api.dart';
import 'package:zarooori_user/authentication/local/local_auth.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/models/packages_model.dart';


class PurchasedPackagesScreen extends StatefulWidget {
  const PurchasedPackagesScreen({super.key});

  @override
  State<PurchasedPackagesScreen> createState() => _PurchasedPackagesScreenState();
}

class _PurchasedPackagesScreenState extends State<PurchasedPackagesScreen>
    with WidgetsBindingObserver {
  List<PackageData> _packages = [];
  bool _isLoading = true;
  String? _error;

  static List<PackageData>? _cachedPackages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_cachedPackages != null && _cachedPackages!.isNotEmpty) {
      setState(() {
        _packages = List.from(_cachedPackages!);
        _isLoading = false;
        _error = null;
      });
      _loadPackages(silentRefresh: true);
    } else {
      _loadPackages(silentRefresh: false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadPackages(silentRefresh: _packages.isNotEmpty);
    }
  }

  Future<void> _loadPackages({bool silentRefresh = false}) async {
    if (!silentRefresh) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final results = await Future.wait([
        LocalAuthHelper.getLoginData(),
        LocalAuthHelper.getUserId(),
      ]);
      final loginData = results[0] as Map<String, dynamic>?;
      final firebaseUid = results[1] as String?;
      final userId = loginData?['id']?.toString() ?? firebaseUid;
      if (userId == null || userId.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = 'Please login to view your packages';
            _packages = [];
            _cachedPackages = null;
          });
        }
        return;
      }

      final list = await PackagesApi.getPackageList(userId);
      if (mounted) {
        _cachedPackages = list;
        setState(() {
          _packages = list;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        if (!silentRefresh) {
          setState(() {
            _isLoading = false;
            _error = e.toString().replaceAll('Exception: ', '');
            _packages = [];
          });
        }
        // On silent refresh failure, keep showing cached list
      }
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    try {
      final parts = date.split('-');
      if (parts.length >= 3) {
        final y = parts[0], m = parts[1], d = parts[2];
        return '$d/$m/$y';
      }
      return date;
    } catch (_) {
      return date;
    }
  }

  static const String _currencySymbol = '₹';

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
          'My Packages',
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
                          ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                          : _error != null
                              ? _buildErrorState()
                              : _packages.isEmpty
                                  ? _buildEmptyState()
                                  : _buildPackagesList(),
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
        margin: const EdgeInsets.symmetric(horizontal: 24),
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
              onPressed: () => _loadPackages(silentRefresh: false),
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
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text(
              'No purchased packages yet',
              style: AppTextStyles.textView(size: 16, color: AppColors.black).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Purchase a package from the app to see it here.',
              style: AppTextStyles.textView(size: 14, color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackagesList() {
    return RefreshIndicator(
      onRefresh: () => _loadPackages(silentRefresh: true),
      color: AppColors.black,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: _packages.length,
        itemBuilder: (context, index) => _PackageCard(
          item: _packages[index],
          formatDate: _formatDate,
          currencySymbol: _currencySymbol,
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final PackageData item;
  final String Function(String?) formatDate;
  final String currencySymbol;

  const _PackageCard({
    required this.item,
    required this.formatDate,
    required this.currencySymbol,
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
                  child: const Icon(Icons.inventory_2_rounded, color: AppColors.black, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.displayTitle,
                        style: AppTextStyles.textView(size: 16, color: AppColors.black).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.description != null && item.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.description!,
                          style: AppTextStyles.textView(size: 12, color: AppColors.gray),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildRow('Paid amount', '$currencySymbol${item.paid_amount ?? item.price ?? '-'}'),
            const SizedBox(height: 8),
            _buildRow('Privilege', '${item.post ?? '-'} Post'),
            const SizedBox(height: 8),
            _buildRow('Duration', item.duration ?? '-'),
            const SizedBox(height: 8),
            _buildRow('Purchased date', formatDate(item.start_date)),
            const SizedBox(height: 8),
            _buildRow('Due date', formatDate(item.end_date)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: AppTextStyles.textView(size: 12, color: AppColors.gray).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.isRunning
                        ? AppColors.green.withValues(alpha: 0.2)
                        : AppColors.gray.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.isRunning ? 'Running' : 'Inactive',
                    style: AppTextStyles.textView(
                      size: 11,
                      color: item.isRunning ? AppColors.green : AppColors.gray,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            if (item.description != null && item.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Text(
                'Description',
                style: AppTextStyles.textView(size: 11, color: AppColors.gray).copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.description!,
                style: AppTextStyles.textView(size: 13, color: AppColors.black).copyWith(
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.textView(size: 12, color: AppColors.gray).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.textView(size: 13, color: AppColors.black),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}