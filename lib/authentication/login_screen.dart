import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zarooori_user/Authentication/register_screen.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/main_home_page/home_screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.offAll(() => const HomeScreen());
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final mobile = _mobileController.text.trim();
    final password = _passwordController.text.trim();

    if (mobile.isEmpty) {
      Get.snackbar('Error', 'Please enter mobile number');
      return;
    }
    if (mobile.length < 10) {
      Get.snackbar('Error', 'Please enter valid mobile number');
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
      final snapshot = await FirebaseFirestore.instance
          .collection('newusers')
          .where('mobile', isEqualTo: mobile)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() => _isLoading = false);
        Get.snackbar('Error', 'No account found with this mobile number. Please register.');
        return;
      }

      final email = snapshot.docs[0].data()['email'] as String?;
      if (email == null || email.isEmpty) {
        setState(() => _isLoading = false);
        Get.snackbar('Error', 'User account not properly configured. Please contact support.');
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      setState(() => _isLoading = false);
      Get.snackbar('Success', 'Login successful');
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Incorrect password. Please try again.');
      } else if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No account found. Please register.');
      } else {
        Get.snackbar('Error', e.message ?? 'Login failed');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Error finding user. Please check your internet connection.');
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
                        hintText: 'Enter Mobile Number',
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
                      onTap: _login,
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
                      onTap: () => Get.to(() => const RegisterScreen()),
                      child: Text(
                        "Don't have an account? Register",
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