// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
// import 'package:zarooori_user/decorative_ui/app_colours.dart';
// import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
// import 'package:zarooori_user/models/buy_vehicle_model.dart';
// import 'package:zarooori_user/models/product_model.dart';
// import 'package:zarooori_user/products/product_detail_screen.dart';
// import 'package:zarooori_user/products/search_product_screen.dart';



// class CarAccessoriesListScreen extends StatefulWidget {
//   final ProductRequest productRequest;

//   const CarAccessoriesListScreen({super.key, required this.productRequest});

//   @override
//   State<CarAccessoriesListScreen> createState() => _CarAccessoriesListScreenState();
// }

// class _CarAccessoriesListScreenState extends State<CarAccessoriesListScreen> {
//   bool _isLoading = true;
//   String? _errorMsg;
//   List<ProductList> _products = [];
//   List<ProductList> _filtered = [];
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//     _loadProducts();
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     final q = _searchController.text.trim().toLowerCase();
//     if (q.isEmpty) {
//       setState(() => _filtered = List.from(_products));
//     } else {
//       setState(() {
//         _filtered = _products.where((p) {
//           final company = (p.vehicle_company_name ?? '').toLowerCase();
//           final model = (p.vehicle_model_name ?? '').toLowerCase();
//           final type = (p.vehicle_type_name ?? '').toLowerCase();
//           final code = (p.product_code ?? '').toLowerCase();
//           final name = (p.product_name ?? '').toLowerCase();
//           final price = (p.price ?? '').toLowerCase();
//           return company.contains(q) ||
//               model.contains(q) ||
//               type.contains(q) ||
//               code.contains(q) ||
//               name.contains(q) ||
//               price.contains(q);
//         }).toList();
//       });
//     }
//   }

//   Future<void> _loadProducts() async {
//     setState(() {
//       _isLoading = true;
//       _errorMsg = null;
//     });
//     try {
//       final list = await VehicleInsuranceApi.getProductList(widget.productRequest);
//       if (!mounted) return;
//       setState(() {
//         _products = list;
//         _filtered = List.from(list);
//         _isLoading = false;
//       });
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorMsg = e.toString().replaceAll('Exception: ', '');
//           _isLoading = false;
//         });
//         Get.snackbar('Error', _errorMsg!);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.purple700,
//       appBar: AppBar(
//         backgroundColor: AppColors.purple700,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.black),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           'Car Accessories',
//           style: AppTextStyles.textView(size: 18, color: AppColors.black),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.tune, color: AppColors.black),
//             onPressed: () async {
//               final req = await Get.to<ProductRequest>(() => SearchProductScreen(
//                     mainCatId: '7',
//                     screenTitle: 'Search Car Accessories',
//                     initialRequest: widget.productRequest,
//                   ));
//               if (req != null && mounted) {
//                 Get.off(() => CarAccessoriesListScreen(productRequest: req));
//               }
//             },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: AppColors.black))
//           : _errorMsg != null && _products.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(_errorMsg!, textAlign: TextAlign.center, style: AppTextStyles.textView(size: 14, color: AppColors.black)),
//                       const SizedBox(height: 16),
//                       ElevatedButton(onPressed: _loadProducts, child: const Text('Retry')),
//                     ],
//                   ),
//                 )
//               : Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8),
//                       child: TextField(
//                         controller: _searchController,
//                         decoration: InputDecoration(
//                           hintText: 'Search by Company, Product name',
//                           prefixIcon: const Icon(Icons.search),
//                           filled: true,
//                           fillColor: AppColors.white,
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           '${_filtered.length} products',
//                           style: AppTextStyles.textView(size: 13, color: AppColors.black),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: _filtered.isEmpty
//                           ? Center(
//                               child: Text(
//                                 'No car accessories found',
//                                 style: AppTextStyles.textView(size: 16, color: AppColors.black),
//                               ),
//                             )
//                           : GridView.builder(
//                               padding: const EdgeInsets.all(8),
//                               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 childAspectRatio: 0.72,
//                                 crossAxisSpacing: 8,
//                                 mainAxisSpacing: 8,
//                               ),
//                               itemCount: _filtered.length,
//                               itemBuilder: (_, i) => _ProductCard(
//                                 product: _filtered[i],
//                                 onTap: () => Get.to(() => ProductDetailScreen(product: _filtered[i])),
//                               ),
//                             ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }

// class _ProductCard extends StatelessWidget {
//   final ProductList product;
//   final VoidCallback onTap;

//   const _ProductCard({required this.product, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final raw = product.image1 ?? product.image2 ?? product.image3 ?? '';
//     final imageUrl = resolveImageUrl(raw);
//     return Card(
//       color: AppColors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
//               child: SizedBox(
//                 height: 100,
//                 width: double.infinity,
//                 child: imageUrl.isEmpty
//                     ? Image.asset('assets/images/placeholder.png', fit: BoxFit.cover)
//                     : CachedNetworkImage(
//                         imageUrl: imageUrl,
//                         fit: BoxFit.cover,
//                         placeholder: (c, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
//                         errorWidget: (c, url, e) => Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
//                       ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (product.product_code != null && product.product_code!.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 4),
//                       child: Text(
//                         'Code: ${product.product_code}',
//                         style: AppTextStyles.textView(size: 10, color: AppColors.gray),
//                       ),
//                     ),
//                   Text(
//                     product.product_name ?? product.vehicle_model_name ?? '-',
//                     style: AppTextStyles.textView(size: 12, color: AppColors.black),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   if (product.vehicle_company_name != null && product.vehicle_company_name!.isNotEmpty)
//                     Text(
//                       product.vehicle_company_name!,
//                       style: AppTextStyles.textView(size: 11, color: AppColors.gray),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   const SizedBox(height: 4),
//                   if (product.price != null && product.price!.isNotEmpty)
//                     Text(
//                       '₹${product.price}',
//                       style: AppTextStyles.semibold14(color: AppColors.orange).copyWith(fontSize: 12),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/models/buy_vehicle_model.dart';
import 'package:zarooori_user/models/product_model.dart';
import 'package:zarooori_user/products/product_detail_screen.dart';
import 'package:zarooori_user/products/search_product_screen.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class CarAccessoriesListScreen extends StatefulWidget {
  final ProductRequest productRequest;

  const CarAccessoriesListScreen({super.key, required this.productRequest});

  @override
  State<CarAccessoriesListScreen> createState() => _CarAccessoriesListScreenState();
}

class _CarAccessoriesListScreenState extends State<CarAccessoriesListScreen> {
  bool _isLoading = true;
  String? _errorMsg;
  List<ProductList> _products = [];
  List<ProductList> _filtered = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filtered = List.from(_products));
    } else {
      setState(() {
        _filtered = _products.where((p) {
          final company = (p.vehicle_company_name ?? '').toLowerCase();
          final model = (p.vehicle_model_name ?? '').toLowerCase();
          final type = (p.vehicle_type_name ?? '').toLowerCase();
          final code = (p.product_code ?? '').toLowerCase();
          final name = (p.product_name ?? '').toLowerCase();
          final price = (p.price ?? '').toLowerCase();
          return company.contains(q) ||
              model.contains(q) ||
              type.contains(q) ||
              code.contains(q) ||
              name.contains(q) ||
              price.contains(q);
        }).toList();
      });
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final list = await VehicleInsuranceApi.getProductList(widget.productRequest);
      if (!mounted) return;
      setState(() {
        _products = list;
        _filtered = List.from(list);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
        Get.snackbar('Error', _errorMsg!);
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
              backgroundColor: const Color(0xFFFFF59D).withOpacity(0.9),
              padding: const EdgeInsets.all(8),
            ),
            icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          'Car Accessories',
          style: GoogleFonts.openSans(
            fontSize: 18,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFFFF59D).withOpacity(0.9),
                padding: const EdgeInsets.all(8),
              ),
              icon: const Icon(Icons.tune_rounded, color: AppColors.black, size: 20),
              onPressed: () async {
                final req = await Get.to<ProductRequest>(() => SearchProductScreen(
                      mainCatId: '7',
                      screenTitle: 'Search Car Accessories',
                      initialRequest: widget.productRequest,
                    ));
                if (req != null && mounted) {
                  Get.off(() => CarAccessoriesListScreen(productRequest: req));
                }
              },
            ),
          ),
        ],
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
            const Positioned(top: -40, right: -30, child: ProfileBubble(size: 140, color: Color(0xFFFF9800))),
            const Positioned(top: 140, left: -40, child: ProfileBubble(size: 110, color: Color(0xFFF57C00))),
            const Positioned(bottom: 200, right: -20, child: ProfileBubble(size: 90, color: Color(0xFFFF9800))),
            const Positioned(bottom: -60, left: -40, child: ProfileBubble(size: 180, color: Color(0xFFF57C00))),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: PremiumDecorations.card().copyWith(
                        border: Border.all(color: Colors.black87, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _searchController,
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                color: AppColors.black,
                                height: 1.4,
                              ),
                              decoration: PremiumDecorations.textField(
                                hintText: 'Search by Company, Product name',
                                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.black, size: 22),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '${_filtered.length} products',
                              style: GoogleFonts.openSans(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.65),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                        : _errorMsg != null && _products.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_errorMsg!, textAlign: TextAlign.center, style: AppTextStyles.textView(size: 14, color: AppColors.black)),
                                    const SizedBox(height: 16),
                                    ElevatedButton(onPressed: _loadProducts, child: const Text('Retry')),
                                  ],
                                ),
                              )
                            : _filtered.isEmpty
                                ? Center(
                                    child: Text(
                                      'No car accessories found',
                                      style: AppTextStyles.textView(size: 16, color: AppColors.black),
                                    ),
                                  )
                                : GridView.builder(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.72,
                                      crossAxisSpacing: 14,
                                      mainAxisSpacing: 14,
                                    ),
                                    itemCount: _filtered.length,
                                    itemBuilder: (_, i) => _ProductCard(
                                      product: _filtered[i],
                                      onTap: () => Get.to(() => ProductDetailScreen(product: _filtered[i])),
                                    ),
                                  ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductList product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final raw = product.image1 ?? product.image2 ?? product.image3 ?? '';
    final imageUrl = resolveImageUrl(raw);
    return Container(
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: const Color(0xFFFFD600).withOpacity(0.3),
          highlightColor: const Color(0xFFFFF59D).withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: imageUrl.isEmpty
                      ? Image.asset('assets/images/placeholder.png', fit: BoxFit.cover)
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (c, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.black)),
                          errorWidget: (c, url, e) => Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.product_code != null && product.product_code!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'Code: ${product.product_code}',
                          style: GoogleFonts.openSans(fontSize: 10, color: AppColors.gray, fontWeight: FontWeight.w500),
                        ),
                      ),
                    Text(
                      product.product_name ?? product.vehicle_model_name ?? '-',
                      style: GoogleFonts.openSans(fontSize: 13, color: AppColors.black, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product.vehicle_company_name != null && product.vehicle_company_name!.isNotEmpty)
                      Text(
                        product.vehicle_company_name!,
                        style: GoogleFonts.openSans(fontSize: 11, color: AppColors.gray, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 6),
                    if (product.price != null && product.price!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF59D).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFFD600), width: 1),
                        ),
                        child: Text(
                          '₹${product.price}',
                          style: GoogleFonts.openSans(fontSize: 14, color: AppColors.black, fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}