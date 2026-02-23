import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';


class VehicleInsuranceScreen extends StatelessWidget {
  final String vehicleCatId;

  const VehicleInsuranceScreen({super.key, this.vehicleCatId = '1'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple700,
      appBar: AppBar(
        backgroundColor: AppColors.purple700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
        title: Text('Vehicle Insurance', style: AppTextStyles.textView(size: 20, color: AppColors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield, size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text('Vehicle Insurance', style: AppTextStyles.textView(size: 18, color: AppColors.black)),
            Text('Search Insurance for your car', style: AppTextStyles.textView(size: 14, color: AppColors.gray)),
          ],
        ),
      ),
    );
  }
}