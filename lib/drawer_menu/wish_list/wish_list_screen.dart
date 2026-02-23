import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
import 'package:zarooori_user/authentication/local/local_auth.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/models/product_model.dart';
import 'package:zarooori_user/products/product_detail_screen.dart';


class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> with WidgetsBindingObserver {
  final _searchController = TextEditingController();
  List<WishListItem> _wishList = [];
  List<WishListItem> _filteredList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(_onSearchChanged);
    _loadWishList();
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
      _loadWishList();
    }
  }


  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredList = List.from(_wishList);
      } else {
        _filteredList = _wishList.where((item) {
          final name = item.product_name?.toLowerCase() ?? '';
          final category = item.master_category_name?.toLowerCase() ?? '';
          return name.contains(query) || category.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadWishList() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = await LocalAuthHelper.getUserId();
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _error = 'Please login to view wishlist';
        });
        return;
      }

      final list = await VehicleInsuranceApi.getWishList(userId, '0');
      if (mounted) {
        setState(() {
          _wishList = list;
          _filteredList = List.from(list);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString().replaceAll('Exception: ', '');
          _wishList = [];
          _filteredList = [];
        });
      }
    }
  }

  Future<void> _removeFromWishList(WishListItem item) async {
    try {
      final success = await VehicleInsuranceApi.removeFromWishList(item);
      if (success) {
        Get.snackbar('Success', 'Product removed from wishlist',
            backgroundColor: AppColors.white,
            colorText: AppColors.black,
            snackPosition: SnackPosition.BOTTOM);
        _loadWishList();
      } else {
        Get.snackbar('Error', 'Failed to remove product',
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _navigateToProductDetail(WishListItem item) {
    final product = ProductList(
      id: item.product_id,
      product_name: item.product_name,
      price: item.product_price,
      description: item.product_description,
      image1: item.product_image,
      master_category_id: item.master_category_id,
      vehicle_cat_id: item.vehicle_category,
    );
    Get.to(() => ProductDetailScreen(product: product));
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
          'My Favourite List',
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
            // Decorative bubbles
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
                                  : _buildWishList(),
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
          hintText: 'Search products...',
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
              onPressed: _loadWishList,
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
            const Icon(Icons.favorite_border, size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text(
              'No items in wishlist',
              style: AppTextStyles.textView(size: 16, color: AppColors.black).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add products to your wishlist to see them here',
              style: AppTextStyles.textView(size: 14, color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishList() {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredList.length,
      itemBuilder: (context, index) => _WishListItemCard(
        item: _filteredList[index],
        onTap: () => _navigateToProductDetail(_filteredList[index]),
        onRemove: () => _removeFromWishList(_filteredList[index]),
      ),
    );
  }
}

class _WishListItemCard extends StatelessWidget {
  final WishListItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _WishListItemCard({
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = resolveImageUrl(item.product_image);

    return Container(
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    color: AppColors.gray.withValues(alpha: 0.1),
                    child: imageUrl.isEmpty
                        ? Image.asset(
                            'assets/images/placeholder.png',
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (c, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (c, url, e) => Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product_name ?? '-',
                          style: AppTextStyles.textView(size: 13, color: AppColors.black).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.master_category_name != null && item.master_category_name!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '(${item.master_category_name})',
                              style: AppTextStyles.textView(size: 11, color: AppColors.gray),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    if (item.product_price != null && item.product_price!.isNotEmpty)
                      Text(
                        '₹${item.product_price}',
                        style: AppTextStyles.semibold14(color: AppColors.orange).copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
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
}