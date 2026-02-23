import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';

class SparePartsScreen extends StatelessWidget {
  final String mainCatId;
  final String vehicleCatId;

  const SparePartsScreen({super.key, this.mainCatId = '6', this.vehicleCatId = '1'});

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
        title: Text('Spare Parts', style: AppTextStyles.textView(size: 20, color: AppColors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build, size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text('Spare Parts', style: AppTextStyles.textView(size: 18, color: AppColors.black)),
            Text('Check out our products.', style: AppTextStyles.textView(size: 14, color: AppColors.gray)),
          ],
        ),
      ),
    );
  }
}