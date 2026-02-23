import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/orders_firestore.dart';
import 'package:zarooori_user/authentication/local/local_auth.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/models/product_model.dart';


class OrderListScreen extends StatefulWidget {
  final bool showBackButton;

  const OrderListScreen({super.key, this.showBackButton = true});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> with WidgetsBindingObserver {
  final _searchController = TextEditingController();
  List<OrderItem> _orders = [];
  List<OrderItem> _filteredList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(_onSearchChanged);
    _loadOrders();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadOrders();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredList = List.from(_orders);
      } else {
        _filteredList = _orders.where((item) {
          final orderCode = item.order_code?.toLowerCase() ?? '';
          final companyName = item.seller_company_name?.toLowerCase() ?? '';
          final invoiceCode = item.invoice_code?.toLowerCase() ?? '';
          return orderCode.contains(query) ||
              companyName.contains(query) ||
              invoiceCode.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadOrders() async {
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
            _error = 'Please login to view orders';
            _orders = [];
            _filteredList = [];
          });
        }
        return;
      }

      final list = await OrdersFirestore.getMyOrders(userId);
      if (mounted) {
        setState(() {
          _orders = list;
          _filteredList = List.from(list);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString().replaceAll('Exception: ', '');
          _orders = [];
          _filteredList = [];
        });
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

  Color _getStatusColor(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s.contains('completed') || s.contains('delivered')) {
      return AppColors.green;
    } else if (s.contains('pending') || s.contains('processing')) {
      return Colors.orange;
    } else if (s.contains('cancelled') || s.contains('failed')) {
      return AppColors.red;
    }
    return AppColors.gray;
  }

  Color _getPaymentStatusColor(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s.contains('paid') || s.contains('success')) {
      return AppColors.green;
    } else if (s.contains('pending')) {
      return Colors.orange;
    } else if (s.contains('failed') || s.contains('cancelled')) {
      return AppColors.red;
    }
    return AppColors.gray;
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
          'My Orders',
          style:GoogleFonts.openSans(fontSize: 18, color: AppColors.black,
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
                    _buildSearchField(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _error != null
                              ? _buildErrorState()
                              : _filteredList.isEmpty
                                  ? _buildEmptyState()
                                  : _buildOrdersList(),
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

  Widget _buildSearchField() {
    return Container(
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: TextField(
        controller: _searchController,
        decoration: PremiumDecorations.textField(
          hintText: 'Search orders...',
          prefixIcon: const Icon(Icons.search, color: AppColors.black),
        ),
        style: AppTextStyles.textView(size: 14, color: AppColors.black),
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
              onPressed: _loadOrders,
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
            const Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text(
              'No orders yet',
              style:  GoogleFonts.openSans(fontSize: 16, color: AppColors.black).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your orders will appear here once you place them',
              style: AppTextStyles.textView(size: 14, color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: AppColors.black,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: _filteredList.length,
        itemBuilder: (context, index) => _OrderCard(
          item: _filteredList[index],
          formatDate: _formatDate,
          getStatusColor: _getStatusColor,
          getPaymentStatusColor: _getPaymentStatusColor,
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderItem item;
  final String Function(String?) formatDate;
  final Color Function(String?) getStatusColor;
  final Color Function(String?) getPaymentStatusColor;

  const _OrderCard({
    required this.item,
    required this.formatDate,
    required this.getStatusColor,
    required this.getPaymentStatusColor,
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
                  child: const Icon(Icons.shopping_bag, color: AppColors.black, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.seller_company_name ?? 'Company',
                        style: AppTextStyles.textView(size: 16, color: AppColors.black).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (item.order_code != null && item.order_code!.isNotEmpty)
                        Text(
                          'Order: ${item.order_code}',
                          style: AppTextStyles.textView(size: 12, color: AppColors.gray),
                        ),
                      if (item.invoice_code != null && item.invoice_code!.isNotEmpty)
                        Text(
                          'Invoice: ${item.invoice_code}',
                          style: AppTextStyles.textView(size: 12, color: AppColors.gray),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${formatDate(item.txn_date)}',
                        style: AppTextStyles.textView(size: 13, color: AppColors.black),
                      ),
                      if (item.paid_amount != null && item.paid_amount!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Amount: ₹${item.paid_amount}',
                            style: AppTextStyles.textView(size: 14, color: AppColors.black).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor(item.status).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (item.status ?? 'pending').toUpperCase(),
                        style: AppTextStyles.textView(
                          size: 10,
                          color: getStatusColor(item.status),
                        ).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (item.payment_status != null && item.payment_status!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getPaymentStatusColor(item.payment_status).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          (item.payment_status ?? 'pending').toUpperCase(),
                          style: AppTextStyles.textView(
                            size: 10,
                            color: getPaymentStatusColor(item.payment_status),
                          ).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (item.remark != null && item.remark!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF59D).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Note: ${item.remark!}',
                  style: AppTextStyles.textView(size: 12, color: AppColors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}