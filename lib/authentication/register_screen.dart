import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zarooori_user/Authentication/login_screen.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/main_home_page/home_screen/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$').hasMatch(email);
  }

  Future<void> _register() async {
    final fullName = _fullNameController.text.trim();
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (fullName.isEmpty) {
      Get.snackbar('Error', 'Please enter full name');
      return;
    }
    if (mobile.isEmpty) {
      Get.snackbar('Error', 'Please enter mobile number');
      return;
    }
    if (mobile.length < 10) {
      Get.snackbar('Error', 'Please enter valid mobile number');
      return;
    }
    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter email address');
      return;
    }
    if (!_isValidEmail(email)) {
      Get.snackbar('Error', 'Please enter valid email address');
      return;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'Please enter password');
      return;
    }
    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final now = DateTime.now();
        String deviceToken = '';
        try {
          deviceToken = await FirebaseMessaging.instance.getToken() ?? '';
        } catch (_) {}

        await FirebaseFirestore.instance
            .collection('newusers')
            .doc(credential.user!.uid)
            .set({
          'name': fullName,
          'mobile': mobile,
          'email': email,
          'userId': credential.user!.uid,
          'createdAt': now.millisecondsSinceEpoch,
          'time': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
          'date': '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
          'dateTime': now.toIso8601String(),
          'deviceToken': deviceToken,
        });

        setState(() => _isLoading = false);
        Get.snackbar('Success', 'Registration successful');
        Get.offAll(() => const HomeScreen());
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'Email already registered. Please sign in.');
      } else if (e.code == 'weak-password') {
        Get.snackbar('Error', 'Password is too weak. Please use a stronger password.');
      } else {
        Get.snackbar('Error', e.message ?? 'Registration failed');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple700,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 26),
                    Image.asset(
                      'assets/images/app_icon.png',
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 39),
                    Text(
                      'All in One Automobile Solution',
                      style: AppTextStyles.textView(size: 15, color: AppColors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Image.asset(
                      'assets/images/groupvehicle.png',
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'Full name',
                      style: AppTextStyles.textView(size: 12, color: AppColors.black),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _fullNameController,
                      style: AppTextStyles.editText13Ssp(color: AppColors.black),
                      decoration: const InputDecoration(
                        hintText: 'Enter Full Name',
                        hintStyle: TextStyle(color: AppColors.black),
                        filled: true,
                        fillColor: AppColors.bgEdittext,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      'Mobile No.',
                      style: AppTextStyles.textView(size: 12, color: AppColors.black),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.editText13Ssp(color: AppColors.black),
                      decoration: const InputDecoration(
                        hintText: 'Enter Mobile No',
                        hintStyle: TextStyle(color: AppColors.black),
                        filled: true,
                        fillColor: AppColors.bgEdittext,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      'Email',
                      style: AppTextStyles.textView(size: 12, color: AppColors.black),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.editText13Ssp(color: AppColors.black),
                      decoration: const InputDecoration(
                        hintText: 'Enter Email',
                        hintStyle: TextStyle(color: AppColors.black),
                        filled: true,
                        fillColor: AppColors.bgEdittext,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Text(
                      'Password',
                      style: AppTextStyles.textView(size: 12, color: AppColors.black),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: AppTextStyles.editText13Ssp(color: AppColors.black),
                      decoration: const InputDecoration(
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(color: AppColors.black),
                        filled: true,
                        fillColor: AppColors.bgEdittext,
                      ),
                    ),
                    const SizedBox(height: 39),
                    GestureDetector(
                      onTap: _register,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 52),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Submit',
                          style: AppTextStyles.textView(size: 13, color: AppColors.purple700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    GestureDetector(
                      onTap: () => Get.off(() => const LoginScreen()),
                      child: Text(
                        'Already have an account? Sign In',
                        style: AppTextStyles.textView(size: 12, color: AppColors.black),
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