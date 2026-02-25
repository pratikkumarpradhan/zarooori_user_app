import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zarooori_user/Authentication/register_screen.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
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
  bool _obscurePassword = true;

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
        Get.snackbar(
          'Error',
          'No account found with this mobile number. Please register.',
        );
        return;
      }

      final email = snapshot.docs[0].data()['email'] as String?;
      if (email == null || email.isEmpty) {
        setState(() => _isLoading = false);
        Get.snackbar(
          'Error',
          'User account not properly configured. Please contact support.',
        );
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
      Get.snackbar(
        'Error',
        'Error finding user. Please check your internet connection.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true, // Optional: if you add an AppBar later
      body: SizedBox.expand(
        child: Container(
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
              // Matching decorative bubbles/orbs like in ProfileScreen
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.black,
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                         child: ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: MediaQuery.of(context).size.height,
    ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // App icon + title (centered)
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ), // 👈 corner radius
                                child: Image.asset(
                                  'assets/images/app_icon.png',
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'All in One Automobile Solution',
                              style: AppTextStyles.textView(
                                size: 16,
                                color: AppColors.black,
                                //  weight: FontWeight.w700, // bolder like profile
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Vehicle image
                            Image.asset(
                              'assets/images/groupvehicle.png',
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 32),

                            // Main form card — similar to profile's card style
                            Container(
                              decoration: PremiumDecorations.card().copyWith(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFFCF4),
                                    Color(0xFFFFF3E0),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.50),
                                  width: 2,
                                ),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black.withValues(alpha: 0.10),
                                //     blurRadius: 35,
                                //     offset: const Offset(0, 14),
                                //   ),
                                //   BoxShadow(
                                //     color: Colors.white.withValues(alpha: 0.7),
                                //     blurRadius: 0,
                                //     offset: const Offset(-2, -2),
                                //   ),
                                // ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  26,
                                  30,
                                  26,
                                  30,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Mobile Number
                                    Text(
                                      'Mobile No.',
                                      style: AppTextStyles.textView(
                                        size: 13,
                                        color: Colors.black.withValues(
                                          alpha: 0.75,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    Container(
                                      decoration: PremiumDecorations.input()
                                          .copyWith(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.05,
                                                ),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                      child: TextField(
                                        controller: _mobileController,
                                        keyboardType: TextInputType.phone,
                                        style: AppTextStyles.editText13Ssp(
                                          color: Colors.black87,
                                        ),
                                        decoration:
                                            PremiumDecorations.textField(
                                              hintText: 'Enter Mobile Number',
                                              prefixIcon: const Icon(
                                                Icons.phone_rounded,
                                              ),
                                            ),
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    /// Password
                                    Text(
                                      'Password',
                                      style: AppTextStyles.textView(
                                        size: 13,
                                        color: Colors.black.withValues(
                                          alpha: 0.75,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    Container(
                                      decoration: PremiumDecorations.input(),
                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        style: AppTextStyles.editText13Ssp(
                                          color: Colors.black87,
                                        ),
                                        decoration: PremiumDecorations.textField(
                                          hintText: 'Enter Password',
                                          prefixIcon: const Icon(
                                            Icons.lock_rounded,
                                          ),

                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_off_rounded
                                                  : Icons.visibility_rounded,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 34),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: PremiumDecorations.primaryButtonStyle,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black,
                                        ),
                                      )
                                    : const Text(
                                        'Submit',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          //color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Register link
                            GestureDetector(
                              onTap: () => Get.to(() => const RegisterScreen()),
                              child: Text(
                                "Don't have an account? Register",
                                style: AppTextStyles.textView(
                                  size: 13,
                                  color: Colors.black,
                                  //weight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              )
            ],
          
          ),
        ),
      ),
    );
  }
}
