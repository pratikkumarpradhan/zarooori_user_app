import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

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
        title: Text('Garage', style: AppTextStyles.textView(size: 20, color: AppColors.black)),
      ),
      body: const Center(child: Text('Garage')),
    );
  }
}