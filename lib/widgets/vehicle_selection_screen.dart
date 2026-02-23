import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zarooori_user/api_services/buy_vehicle_api.dart';
import 'package:zarooori_user/api_services/vehicle_insurance_api.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';

class VehicleCategory {
  final String id;
  final String name;
  final String imagePath;

  VehicleCategory({required this.id, required this.name, required this.imagePath});
}

List<VehicleCategory> _defaultBuyVehicleCategories() => [
  VehicleCategory(id: '1', name: 'Bike/Two Wheeler', imagePath: 'assets/images/bike2.png'),
  VehicleCategory(id: '2', name: 'Commercial Vehicles', imagePath: 'assets/images/commercial.png'),
  VehicleCategory(id: '3', name: 'Heavy Equipments', imagePath: 'assets/images/backhoe.png'),
  VehicleCategory(id: '4', name: 'Ambulance', imagePath: 'assets/images/ambulance.png'),
  VehicleCategory(id: '5', name: 'Trucks', imagePath: 'assets/images/truck.png'),
  VehicleCategory(id: '6', name: 'Excavator', imagePath: 'assets/images/excavator.png'),
];

Future<String?> showVehicleSelectionSheet(
  BuildContext context, {
  required String title,
  List<VehicleCategory>? categories,
}) async {
  List<VehicleCategory> items = categories ?? _defaultBuyVehicleCategories();

  return showDialog<String>(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: false,
    builder: (context) => _SelectionDialog(
      title: title,
      items: items,
      crossAxisCount: 2,
    ),
  );
}

List<VehicleCategory> _mapApiToVehicleCategories(
  List<VehicleCategoryItem> regular,
  List<VehicleCategoryItem> heavy,
) {
  final apiItems = <VehicleCategory>[];
  final iconMap = {
    'bike': 'assets/images/bike2.png',
    'car': 'assets/images/car.png',
    'commercial': 'assets/images/commercial.png',
    'heavy': 'assets/images/backhoe.png',
    'ambulance': 'assets/images/ambulance.png',
    'truck': 'assets/images/truck.png',
    'excavator': 'assets/images/excavator.png',
  };
  for (final v in [...regular, ...heavy]) {
    if (v.id.isEmpty) continue;
    final nameLower = v.name.toLowerCase();
    // Prefer local assets when name matches, so pop screen always shows updated icons
    String path = 'assets/images/placeholder.png';
    if (nameLower.contains('bike') || nameLower.contains('two wheeler')) {
      path = iconMap['bike']!;
    } else if (nameLower.contains('commercial')) {
      path = iconMap['commercial']!;
    } else if (nameLower.contains('heavy') || nameLower.contains('equipment')) {
      path = iconMap['heavy']!;
    } else if (nameLower.contains('ambulance')) {
      path = iconMap['ambulance']!;
    } else if (nameLower.contains('truck')) {
      path = iconMap['truck']!;
    } else if (nameLower.contains('excavator')) {
      path = iconMap['excavator']!;
    } else if (nameLower.contains('car') && !nameLower.contains('commercial')) {
      path = iconMap['car']!;
    } else if (v.imageUrl != null && v.imageUrl!.trim().isNotEmpty) {
      path = v.imageUrl!.trim();
    }
    apiItems.add(VehicleCategory(id: v.id, name: v.name, imagePath: path));
  }
  return apiItems.isNotEmpty ? apiItems.take(6).toList() : _defaultBuyVehicleCategories();
}

/// Returns local asset path for known subcategories so updated images show in pop screen.
/// For breakdown (mainCatId '10') uses breakdown icon as fallback; for emergency (mainCatId '5') uses ambulance/appropriate icons.
/// ALWAYS uses local assets for known services - NEVER uses API images for tyre service.
String _subCategoryImagePath(String? name, String? apiImage, {String? mainCatId, String? subCatId}) {
  final nameLower = (name ?? '').toLowerCase().trim();
  final subCatIdLower = (subCatId ?? '').toLowerCase().trim();
  final apiImageLower = (apiImage ?? '').toLowerCase().trim();
  
  // CRITICAL: Tyre Service - ALWAYS use local asset, NEVER use API image
  // Check by name variations first (most common)
  if (nameLower.contains('tyre') || nameLower.contains('tire') || 
      nameLower.contains('tyres') || nameLower.contains('tires') ||
      nameLower.contains('tyre service') || nameLower.contains('tire service') || 
      nameLower.contains('tyre services') || nameLower.contains('tire services') ||
      nameLower.startsWith('tyre') || nameLower.startsWith('tire')) {
    return 'assets/images/tyre_services.png';
  }
  // Check by ID if name doesn't match (some APIs might use IDs like 'tyre', '9', etc.)
  if (subCatIdLower == 'tyre' || subCatIdLower == '9' || 
      nameLower == 'tyre' || nameLower == 'tire' ||
      nameLower == 'tyre service' || nameLower == 'tire service') {
    return 'assets/images/tyre_services.png';
  }
  // Even if API image URL contains tyre-related keywords, use local asset instead
  if (apiImageLower.contains('tyre') || apiImageLower.contains('tire')) {
    return 'assets/images/tyre_services.png';
  }
  // For Emergency Services (mainCatId '5'), check if it might be tyre service by position or other indicators
  if (mainCatId == '5') {
    // If name is empty or very short, and we're in Emergency Services, it might be tyre service
    // Check emergencyCategoryItems order - tyre is usually first
    if (nameLower.isEmpty || nameLower.length < 3) {
      // Could be tyre service, use local asset to be safe
      if (subCatIdLower == 'tyre' || subCatIdLower.isEmpty) {
        return 'assets/images/tyre_services.png';
      }
    }
  }
  if (nameLower.contains('mechanical')) return 'assets/images/mechanical.png';
  if (nameLower.contains('electrical')) return 'assets/images/electrical.png';
  if (nameLower.contains('painting')) return 'assets/images/painting.png';
  if (nameLower.contains('denting')) return 'assets/images/car_denting.png';
  if (nameLower.contains('bike') || nameLower.contains('two wheeler')) return 'assets/images/bike2.png';
  if ((nameLower.contains('car') && !nameLower.contains('commercial'))) return 'assets/images/car.png';
  if (nameLower.contains('towing') || nameLower.contains('break down') || nameLower.contains('breakdown')) {
    return 'assets/images/breakdown.png';
  }
  if (nameLower.contains('battery')) return 'assets/images/breakdown.png';
  if (nameLower.contains('medical')) return 'assets/images/ambulance.png';
  if (nameLower.contains('ambulance')) return 'assets/images/ambulance.png';
  // Only use API image if no local match found
  if (apiImage != null && apiImage.trim().isNotEmpty) return apiImage.trim();
  // Fallback based on main category
  if (mainCatId == '10') return 'assets/images/breakdown.png';
  if (mainCatId == '5') return 'assets/images/ambulance.png';
  return 'assets/images/garage.png';
}

Future<String?> showVehicleSelectionSheetWithApi(
  BuildContext context, {
  required String title,
}) async {
  // Show dialog immediately - no waiting for API
  return showDialog<String>(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: false,
    builder: (context) => _LoadingSelectionDialog(
      title: title,
      crossAxisCount: 2,
      fallbackItems: _defaultBuyVehicleCategories(),
      future: Future.wait([
        BuyVehicleApi.getVehicleCategories(type: '0'),
        BuyVehicleApi.getVehicleCategories(type: '1'),
      ]).then((results) => _mapApiToVehicleCategories(results[0], results[1])),
    ),
  );
}

final List<VehicleCategory> heavyEquipmentItems = [
  VehicleCategory(id: 'excavator', name: 'Excavators', imagePath: 'assets/images/excavator.png'),
  VehicleCategory(id: 'bulldozer', name: 'Bulldozers', imagePath: 'assets/images/bulldozers.png'),
  VehicleCategory(id: 'backhoe', name: 'Backhoe loaders', imagePath: 'assets/images/backhoe.png'),
  VehicleCategory(id: 'crane', name: 'Cranes', imagePath: 'assets/images/crane.png'),
  VehicleCategory(id: 'roadroller', name: 'Road rollers', imagePath: 'assets/images/roadroller.png'),
  VehicleCategory(id: 'jcb', name: 'JCB', imagePath: 'assets/images/jcb.png'),
];

Future<String?> showHeavyEquipmentSelectionSheet(BuildContext context) async {
  return showDialog<String>(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: false,
    builder: (context) => _SelectionDialog(
      title: 'Hire Heavy Equipments',
      items: heavyEquipmentItems,
      crossAxisCount: 2,
    ),
  );
}

final List<VehicleCategory> subCategoryItems = [
  VehicleCategory(id: 'mechanical', name: 'Mechanical', imagePath: 'assets/images/mechanical.png'),
  VehicleCategory(id: 'electrical', name: 'Electrical', imagePath: 'assets/images/electrical.png'),
  VehicleCategory(id: 'painting', name: 'Painting', imagePath: 'assets/images/painting.png'),
  VehicleCategory(id: 'denting', name: 'Denting', imagePath: 'assets/images/car_denting.png'),
];

/// Vehicle selection for Break Down Services: Bike 1st, then Car, then Commercial, then Emergency.
/// Uses updated local asset images for the breakdown pop screen.
final List<VehicleCategory> breakdownCategoryItems = [
  VehicleCategory(id: 'bike', name: 'Bike', imagePath: 'assets/images/bike2.png'),
  VehicleCategory(id: 'car', name: 'Car', imagePath: 'assets/images/car.png'),
  VehicleCategory(id: 'commercial', name: 'Commercial Vehicle', imagePath: 'assets/images/commercial.png'),
  VehicleCategory(id: 'emergency', name: 'Emergency Vehicle', imagePath: 'assets/images/ambulance.png'),
];

Future<Map<String, String>?> showBreakdownSelectionSheet(
  BuildContext context, {
  String title = 'What are you looking?',
}) async {
  final id = await showDialog<String>(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: false,
    builder: (context) => _SelectionDialog(
      title: title,
      items: breakdownCategoryItems,
      crossAxisCount: 2,
    ),
  );
  return id != null ? {'mainCatId': '10', 'subCatId': id} : null;
}

/// Fixed service categories for Emergency Services pop screen.
/// Update image paths here to change emergency services pop screen images.
final List<VehicleCategory> emergencyCategoryItems = [
  VehicleCategory(id: 'tyre', name: 'Tyre Service', imagePath: 'assets/images/tyre_services.png'),
  VehicleCategory(id: 'mechanical', name: 'Mechanical', imagePath: 'assets/images/mechanical.png'),
  VehicleCategory(id: 'electrical', name: 'Electrical', imagePath: 'assets/images/electrical.png'),
  VehicleCategory(id: 'painting', name: 'Painting', imagePath: 'assets/images/painting.png'),
  VehicleCategory(id: 'breakdown', name: 'Breakdown', imagePath: 'assets/images/breakdown.png'),
  VehicleCategory(id: 'denting', name: 'Denting', imagePath: 'assets/images/car_denting.png'),
  VehicleCategory(id: 'medical', name: 'Medical', imagePath: 'assets/images/ambulance.png'),
  VehicleCategory(id: 'ambulance', name: 'Ambulance', imagePath: 'assets/images/ambulance.png'),
];

Future<Map<String, String>?> showEmergencySelectionSheet(
  BuildContext context, {
  String title = 'What are you looking?',
}) async {
  final id = await showDialog<String>(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: false,
    builder: (context) => _SelectionDialog(
      title: title,
      items: emergencyCategoryItems,
      crossAxisCount: 2,
    ),
  );
  return id != null ? {'mainCatId': '5', 'subCatId': id} : null;
}

Future<Map<String, String>?> showSubCategorySelectionSheet(
  BuildContext context, {
  required String title,
  required String mainCatId,
}) async {
  final id = await showDialog<String>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => _SelectionDialog(
      title: title,
      items: subCategoryItems,
      crossAxisCount: 2,
    ),
  );
  return id != null ? {'mainCatId': mainCatId, 'subCatId': id} : null;
}

/// Fetch subcategories from API and show selection. Returns mainCatId and subCatId.
/// Always uses API data to ensure correct IDs for search, but maps images to local assets for known services.
Future<Map<String, String>?> showSubCategorySheetWithApi(
  BuildContext context, {
  required String title,
  required String mainCatId,
}) async {
  // Show dialog immediately - load data in background
  final id = await showDialog<String>(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: false,
    builder: (ctx) => _LoadingSelectionDialog(
      title: title,
      crossAxisCount: 2,
      future: VehicleInsuranceApi.getSubCategories(mainCatId).then((subCats) {
        // Map API subcategories to VehicleCategory with updated images
        // Keep original API IDs for proper search functionality
        final mapped = subCats
            .map((s) {
              final name = s.sub_cat_name ?? '';
              final apiImage = s.sub_cat_image;
              final subCatId = s.id ?? '';
              
              // Always use local asset path function to ensure updated images
              // This ensures tyre service and other services show correct images
              final imagePath = _subCategoryImagePath(
                name, 
                apiImage, 
                mainCatId: mainCatId, 
                subCatId: subCatId,
              );
              
              return VehicleCategory(
                id: subCatId, // Keep original API ID for search to work
                name: name,
                imagePath: imagePath, // Use local asset for correct image
              );
            })
            .where((v) => v.id.isNotEmpty)
            .toList();
        
        return mapped;
      }),
    ),
  );
  return id != null && id.isNotEmpty ? {'mainCatId': mainCatId, 'subCatId': id} : null;
}

Future<String?> showOffersCategorySheet(
  BuildContext context, {
  required String title,
  List<VehicleCategory>? categories,
}) async {
  final items = categories ?? [
    VehicleCategory(id: '1', name: 'Sell Vehicle', imagePath: 'assets/images/sell_vehicle.png'),
    VehicleCategory(id: '2', name: 'Buy Vehicle', imagePath: 'assets/images/buy_vehicle.png'),
    VehicleCategory(id: '3', name: 'Garage', imagePath: 'assets/images/garage.png'),
    VehicleCategory(id: '4', name: 'Vehicle Insurance', imagePath: 'assets/images/vehicle_insurance.png'),
    VehicleCategory(id: '5', name: 'Emergency', imagePath: 'assets/images/ambulance.png'),
    VehicleCategory(id: '6', name: 'Spare Parts', imagePath: 'assets/images/spare_parts.png'),
    VehicleCategory(id: '7', name: 'Car Accessories', imagePath: 'assets/images/car_accessories.png'),
    VehicleCategory(id: '8', name: 'Heavy Equipment', imagePath: 'assets/images/heavy_equipments.png'),
    VehicleCategory(id: '9', name: 'Tyre Services', imagePath: 'assets/images/tyre_services.png'),
    VehicleCategory(id: '10', name: 'Break Down', imagePath: 'assets/images/breakdown.png'),
    VehicleCategory(id: '11', name: 'Rent Car', imagePath: 'assets/images/car_rent.png'),
    VehicleCategory(id: '12', name: 'Courier', imagePath: 'assets/images/courier_service.png'),
  ];

  return showDialog<String>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFFFFD54F).withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF8E1),
                  Color(0xFFFFF59D),
                  Color(0xFFFFF176),
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFEA00),
                        Color(0xFFFFD600),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF57C00).withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(ctx),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.close_rounded, color: Colors.black87, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.95,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _SelectionCard(
                          category: item,
                          onTap: () => Navigator.of(ctx).pop(item.id),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _LoadingSelectionDialog extends StatefulWidget {
  final String title;
  final Future<List<VehicleCategory>> future;
  final int crossAxisCount;
  final List<VehicleCategory>? fallbackItems;

  const _LoadingSelectionDialog({
    required this.title,
    required this.future,
    this.crossAxisCount = 2,
    this.fallbackItems,
  });

  @override
  State<_LoadingSelectionDialog> createState() => _LoadingSelectionDialogState();
}

class _LoadingSelectionDialogState extends State<_LoadingSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFFFFD54F).withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF8E1),
                  Color(0xFFFFF59D),
                  Color(0xFFFFF176),
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFEA00),
                        Color(0xFFFFD600),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF57C00).withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.close_rounded, color: Colors.black87, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: FutureBuilder<List<VehicleCategory>>(
                    future: widget.future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.all(36),
                          child: Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: const Color(0xFFF57C00),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                          ),
                        );
                      }
                      List<VehicleCategory> items = snapshot.data ?? [];
                      if (items.isEmpty && widget.fallbackItems != null) {
                        items = widget.fallbackItems!;
                      }
                      if (items.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.inbox_outlined, size: 40, color: Colors.black.withValues(alpha: 0.4)),
                                const SizedBox(height: 12),
                                Text(
                                  snapshot.hasError ? 'Failed to load' : 'No options available',
                                  style: AppTextStyles.textView(size: 14, color: Colors.black87),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Close', style: AppTextStyles.textView(size: 13, color: const Color(0xFFF57C00)).copyWith(fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: widget.crossAxisCount,
                            childAspectRatio: 1.15,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _SelectionCard(
                              category: item,
                              onTap: () => Navigator.of(context).pop(item.id),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionDialog extends StatefulWidget {
  final String title;
  final List<VehicleCategory> items;
  final int crossAxisCount;

  const _SelectionDialog({
    required this.title,
    required this.items,
    this.crossAxisCount = 2,
  });

  @override
  State<_SelectionDialog> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<_SelectionDialog> {
  static const _borderRadius = 20.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final item in widget.items) {
      if (!item.imagePath.startsWith('http')) {
        try {
          precacheImage(AssetImage(item.imagePath), context);
        } catch (_) {}
      }
    }
    try {
      precacheImage(const AssetImage('assets/images/placeholder.png'), context);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: const BoxConstraints(maxHeight:600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFFFFD54F).withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF8E1),
                  Color(0xFFFFF59D),
                  Color(0xFFFFF176),
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFEA00),
                        Color(0xFFFFD600),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF57C00).withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.close_rounded, color: Colors.black87, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.crossAxisCount,
                        childAspectRatio: 1.15,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return _SelectionCard(
                          category: item,
                          onTap: () => Navigator.of(context).pop(item.id),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final VehicleCategory category;
  final VoidCallback onTap;

  const _SelectionCard({required this.category, required this.onTap});

  Widget _buildCardImage(String path) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');
    const placeholderPath = 'assets/images/placeholder.png';
    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.contain,
        placeholder: (c, url) => Image.asset(placeholderPath, fit: BoxFit.contain),
        errorWidget: (c, url, e) => Image.asset(placeholderPath, fit: BoxFit.contain),
      );
    }
    return Image(
      image: AssetImage(path),
      fit: BoxFit.contain,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return Image.asset(placeholderPath, fit: BoxFit.contain);
      },
      errorBuilder: (c, e, st) => Image.asset(placeholderPath, fit: BoxFit.contain),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: const Color(0xFFFFD600).withValues(alpha: 0.25),
        highlightColor: const Color(0xFFFFE082).withValues(alpha: 0.35),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFFE082).withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: const Color(0xFFFFD54F).withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFFFFDE7),
                        const Color(0xFFFFF8C4).withValues(alpha: 0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildCardImage(category.imagePath),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: 0.15,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}