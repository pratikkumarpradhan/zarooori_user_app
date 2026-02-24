import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/cab_service/role_selection.dart';
import 'package:zarooori_user/main_home_page/break_down/break_down_screen.dart';
import 'package:zarooori_user/main_home_page/buy_vehicle/buy_vehicle_screen.dart';
import 'package:zarooori_user/main_home_page/car_accessories/car_accessories_list_screen.dart';
import 'package:zarooori_user/main_home_page/courier_service/courier_service.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/main_home_page/emergency_service/emergency_service.dart';
import 'package:zarooori_user/main_home_page/garage/garage_list_screen.dart';
import 'package:zarooori_user/main_home_page/heavy_equipment/heavy_equipment_screen.dart';
import 'package:zarooori_user/main_home_page/insurance/vehicle_insurance_list_screen.dart';
import 'package:zarooori_user/main_home_page/rent_car/rent_car_screen.dart';
import 'package:zarooori_user/main_home_page/sell_vehicle/sell_vehicle_list_screen.dart';
import 'package:zarooori_user/main_home_page/spare_parts/spare_parts_list_screen.dart';
import 'package:zarooori_user/main_home_page/tyre_service/tyre_service_list_screen.dart';
import 'package:zarooori_user/models/product_model.dart';
import 'package:zarooori_user/widgets/vehicle_selection_screen.dart';

/// Snappy navigation - instant feedback, no delay.
void _nav(Widget Function() page) => Get.to(
  page,
  transition: Transition.cupertino,
  duration: const Duration(milliseconds: 200),
);

class ServiceGridWidget extends StatelessWidget {
  const ServiceGridWidget({
    super.key,
    ScrollController? scrollController,
    double contentTopOffset = 210,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Striving to Deliver You the Best',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 15,
              fontWeight: FontWeight.bold, // bold premium look
              color: Colors.black,
              letterSpacing: 0.4,
            ),
          ),
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFFFFD54F).withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _ServiceTile(
                  image: 'assets/images/sell_vehicle.png',
                  label: 'Sell Vehicle',
                  subText: 'Sell Your Vehicle Faster',
                  onTap: () async {
                    final id = await showVehicleSelectionSheetWithApi(
                      context,
                      title: 'What are you selling?',
                    );
                    if (id != null && id.isNotEmpty && context.mounted) {
                      _nav(() => SellVehicleListScreen(vehicleCatId: id));
                    }
                  },
                ),
              ),
              Container(
                width: 0.5,
                color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
              ),
              Expanded(
                child: _ServiceTile(
                  image: 'assets/images/buy_vehicle.png',
                  label: 'Buy Vehicle',
                  subText: 'Find Your Favourite Vehicle With Best Price',
                  onTap: () async {
                    final id = await showVehicleSelectionSheetWithApi(
                      context,
                      title: 'What are you looking?',
                    );
                    if (id != null && id.isNotEmpty && context.mounted) {
                      _nav(() => BuyVehicleScreen(vehicleCatId: id));
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 0.5,
            color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(vertical: 12),
          ),

          /// Emergency Services Card
          _ServiceTileWide(
            image: 'assets/images/emegency_service.png',
            label: 'Emergency Services',
            subText: 'Your Best Solution Where No One To Help You',
            onTap: () async {
              final result = await showSubCategorySheetWithApi(
                context,
                title: 'What are you looking?',
                mainCatId: '5',
              );

              if (result != null && context.mounted) {
                final req = ProductRequest(
                  master_category_id: result['mainCatId'],
                  master_subcategory_id: result['subCatId'],
                  city_id: '0',
                );

                _nav(() => EmergencyServicesScreen(productRequest: req));
              }
            },
            onAction: () async {
              final result = await showSubCategorySheetWithApi(
                context,
                title: 'What are you looking?',
                mainCatId: '5',
              );

              if (result != null && context.mounted) {
                final req = ProductRequest(
                  master_category_id: result['mainCatId'],
                  master_subcategory_id: result['subCatId'],
                  city_id: '0',
                );

                _nav(() => EmergencyServicesScreen(productRequest: req));
              }
            },
          ),
          Container(
            height: 0.5,
            color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(vertical: 12),
          ),
          Row(
            children: [
              Expanded(
                child: _ServiceTile(
                  image: 'assets/images/vehicle_insurance.png',
                  label: 'Vehicle Insurance',
                  subText: 'Grab Your Best Insurance Deals',
                  onTap: () async {
                    final id = await showVehicleSelectionSheetWithApi(
                      context,
                      title: 'What are you looking?',
                    );
                    if (id != null && id.isNotEmpty && context.mounted) {
                      final req = ProductRequest(
                        master_category_id: '4',
                        vehicle_category_id: id,
                        city_id: '0',
                      );
                      _nav(
                        () => VehicleInsuranceListScreen(productRequest: req),
                      );
                    }
                  },
                ),
              ),
              Container(
                height: 0.5,
                color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
                margin: const EdgeInsets.symmetric(vertical: 12),
              ),
              Expanded(
                child: _ServiceTile(
                  image: 'assets/images/spare_parts.png',
                  label: 'Spare Parts',
                  subText: 'Choose Parts at Best Price Without Commission',
                  onTap: () async {
                    final id = await showVehicleSelectionSheetWithApi(
                      context,
                      title: 'What are you looking?',
                    );
                    if (id != null && id.isNotEmpty && context.mounted) {
                      final req = ProductRequest(
                        master_category_id: '6',
                        vehicle_category_id: id,
                        city_id: '0',
                      );
                      _nav(() => SparePartsListScreen(productRequest: req));
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 0.5,
            color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(vertical: 12),
          ),

          /// Book Ride Card (Same Layout)
          _ServiceTileWide(
            image: 'assets/images/cab_service.jpg',
            label: 'Book Ride',
            subText:
                'For Riders & Drivers — Book or Offer Rides Anytime Anywhere',
            actionLabel: 'Become Driver',
            onTap: () => _nav(() => const RoleSelection()),
            onAction: () => _nav(() => const RoleSelection()),
          ),

          Container(
            height: 0.5,
            color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(vertical: 12),
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: _ServiceTile(
          //         image: 'assets/images/vehicle_insurance.png',
          //         label: 'Vehicle Insurance',
          //         subText: 'Grab Your Best Insurance Deals',
          //         onTap: () async {
          //           final id = await showVehicleSelectionSheetWithApi(
          //             context,
          //             title: 'What are you looking?',
          //           );
          //           if (id != null && id.isNotEmpty && context.mounted) {
          //             final req = ProductRequest(
          //               master_category_id: '4',
          //               vehicle_category_id: id,
          //               city_id: '0',
          //             );
          //             _nav(
          //               () => VehicleInsuranceListScreen(productRequest: req),
          //             );
          //           }
          //         },
          //       ),
          //     ),
          //     Container(
          //       width: 0.5,
          //       color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
          //     ),
          //     Expanded(
          //       child: _ServiceTile(
          //         image: 'assets/images/spare_parts.png',
          //         label: 'Spare Parts',
          //         subText: 'Choose Parts at Best Price Without Commission',
          //         onTap: () async {
          //           final id = await showVehicleSelectionSheetWithApi(
          //             context,
          //             title: 'What are you looking?',
          //           );
          //           if (id != null && id.isNotEmpty && context.mounted) {
          //             final req = ProductRequest(
          //               master_category_id: '6',
          //               vehicle_category_id: id,
          //               city_id: '0',
          //             );
          //             _nav(() => SparePartsListScreen(productRequest: req));
          //           }
          //         },
          //       ),
          //     ),
          //   ],
          // ),
          // Container(
          //   height: 0.5,
          //   color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
          //   margin: const EdgeInsets.symmetric(vertical: 12),
          // ),
          // _ServiceTileWide(
          //   image: 'assets/images/courier_service.png',
          //   label: 'Courier Services',
          //   subText: 'Choose Your Delivery At Best Time And Rate',
          //   onTap: () => _nav(() => const CourierServicesScreen()),
          // ),
          // Container(
          //   height: 0.5,
          //   color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
          //   margin: const EdgeInsets.symmetric(vertical: 12),
          // ),
          Row(
            children: [
              Expanded(
                child: _ServiceTile(
                  image: 'assets/images/garage.png',
                  label: 'Garage',
                  subText: 'Choose Best Garage With The Correct Specality',
                  onTap: () async {
                    final result = await showSubCategorySheetWithApi(
                      context,
                      title: 'What are you looking?',
                      mainCatId: '3',
                    );
                    if (result != null && context.mounted) {
                      final req = ProductRequest(
                        master_category_id: result['mainCatId'],
                        master_subcategory_id: result['subCatId'],
                        city_id: '0',
                      );
                      _nav(() => GarageListScreen(productRequest: req));
                    }
                  },
                ),
              ),
              Container(
                width: 0.5,
                color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
              ),
              Expanded(
                child: _ServiceTile(
                  image: 'assets/images/car_accessories.png',
                  label: 'Car Accessories',
                  subText: 'Make Your Vehicle Unique And Cool',
                  onTap: () async {
                    final id = await showVehicleSelectionSheetWithApi(
                      context,
                      title: 'What are you looking?',
                    );
                    if (id != null && id.isNotEmpty && context.mounted) {
                      final req = ProductRequest(
                        master_category_id: '7',
                        vehicle_category_id: id,
                        city_id: '0',
                      );
                      _nav(() => CarAccessoriesListScreen(productRequest: req));
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 0.5,
            color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(vertical: 12),
          ),
          Container(
            height: 0.5,
            color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(vertical: 12),
          ),
          _ServiceTileWide(
            image: 'assets/images/courier_service.png',
            label: 'Courier Services',
            subText: 'Choose Your Delivery At Best Time And Rate',
            onTap: () => _nav(() => const CourierServicesScreen()),
          ),
          Container(
            height: 0.5,
            color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(vertical: 12),
          ),
          Row(
            children: [
              Expanded(
                child: _ServiceTile(
                  image: 'assets/images/heavy_equipments.png',
                  label: 'Heavy Equipments',
                  subText: 'Hire Heavy Equipments Direct From Dealers',
                  onTap: () async {
                    final id = await showHeavyEquipmentSelectionSheet(context);
                    if (id != null && id.isNotEmpty && context.mounted) {
                      final req = ProductRequest(
                        master_category_id: '8',
                        vehicle_category_id: id,
                        city_id: '0',
                      );
                      _nav(() => HeavyEquipmentScreen(productRequest: req));
                    }
                  },
                ),
              ),
              Container(
                width: 0.5,
                color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
              ),
              Expanded(
                child: _ServiceTile(
                  image: 'assets/images/tyre_services.png',
                  label: 'Tyre Services',
                  subText: 'We Fix Your Tyres Anytime Anywhere',
                  onTap: () async {
                    final id = await showVehicleSelectionSheetWithApi(
                      context,
                      title: 'What are you looking?',
                    );
                    if (id != null && id.isNotEmpty && context.mounted) {
                      final req = ProductRequest(
                        master_category_id: '9',
                        vehicle_category_id: id,
                        city_id: '0',
                      );
                      _nav(() => TyreServicesScreen(productRequest: req));
                    }
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 0.5,
            color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
            margin: const EdgeInsets.symmetric(vertical: 12),
          ),
          Row(
            children: [
              Expanded(
                child: _ServiceTile(
                  image: 'assets/images/breakdown.png',
                  label: 'Break Down Services',
                  subText: '24/7 At Your Service',
                  onTap: () async {
                    final result = await showBreakdownSelectionSheet(
                      context,
                      title: 'What are you looking?',
                    );
                    if (result != null && context.mounted) {
                      final req = ProductRequest(
                        master_category_id: result['mainCatId'],
                        master_subcategory_id: result['subCatId'],
                        city_id: '0',
                      );
                      _nav(() => BreakDownScreen(productRequest: req));
                    }
                  },
                ),
              ),
              Container(
                width: 0.5,
                color: const Color(0xFFFFD54F).withValues(alpha: 0.5),
              ),
              Expanded(
                child: _ServiceTile(
                  image: 'assets/images/car_rent.png',
                  label: 'Cars For Rent',
                  subText: 'Choose Your Favourite Car',
                  onTap: () {
                    final req = ProductRequest(
                      master_category_id: '11',
                      city_id: '0',
                    );
                    _nav(() => RentCarScreen(productRequest: req));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String image;
  final String label;
  final String subText;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.image,
    required this.label,
    required this.subText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFFFE082).withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    image,
                    height: 70,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, st) => Image.asset(
                      'assets/images/placeholder.png',
                      height: 70,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subText,
                style: AppTextStyles.textView(size: 9, color: Colors.black87),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  label.toUpperCase(),
                  style: AppTextStyles.semibold9(
                    color: const Color(0xFFFFE066),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceTileWide extends StatelessWidget {
  final String image;
  final String label;
  final String subText;
  final String? actionLabel;
  final VoidCallback onTap;
  final VoidCallback? onAction;

  const _ServiceTileWide({
    required this.image,
    required this.label,
    required this.subText,
    this.actionLabel,
    required this.onTap,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFFE082).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        image,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, st) => Image.asset(
                          'assets/images/placeholder.png',
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    subText,
                    style: AppTextStyles.textView(
                      size: 9,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      label.toUpperCase(),
                      style: AppTextStyles.semibold9(
                        color: const Color(0xFFFFE066),
                      ),
                    ),
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(width: 10),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onAction,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          actionLabel!.toUpperCase(),
                          style: AppTextStyles.semibold9(
                            color: const Color(0xFFFFE066),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
