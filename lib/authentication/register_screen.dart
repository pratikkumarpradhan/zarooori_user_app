// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:zarooori_user/Authentication/login_screen.dart';
// import 'package:zarooori_user/decorative_ui/app_colours.dart';
// import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
// import 'package:zarooori_user/main_home_page/home_screen/home_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _fullNameController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   bool _isValidEmail(String email) {
//     return RegExp(
//       r'^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
//     ).hasMatch(email);
//   }

//   Future<void> _register() async {
//     final fullName = _fullNameController.text.trim();
//     final mobile = _mobileController.text.trim();
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     if (fullName.isEmpty) {
//       Get.snackbar('Error', 'Please enter full name');
//       return;
//     }
//     if (mobile.isEmpty) {
//       Get.snackbar('Error', 'Please enter mobile number');
//       return;
//     }
//     if (mobile.length < 10) {
//       Get.snackbar('Error', 'Please enter valid mobile number');
//       return;
//     }
//     if (email.isEmpty) {
//       Get.snackbar('Error', 'Please enter email address');
//       return;
//     }
//     if (!_isValidEmail(email)) {
//       Get.snackbar('Error', 'Please enter valid email address');
//       return;
//     }
//     if (password.isEmpty) {
//       Get.snackbar('Error', 'Please enter password');
//       return;
//     }
//     if (password.length < 6) {
//       Get.snackbar('Error', 'Password must be at least 6 characters');
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final credential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);

//       if (credential.user != null) {
//         final now = DateTime.now();
//         String deviceToken = '';
//         try {
//           deviceToken = await FirebaseMessaging.instance.getToken() ?? '';
//         } catch (_) {}

//         await FirebaseFirestore.instance
//             .collection('newusers')
//             .doc(credential.user!.uid)
//             .set({
//               'name': fullName,
//               'mobile': mobile,
//               'email': email,
//               'userId': credential.user!.uid,
//               'createdAt': now.millisecondsSinceEpoch,
//               'time':
//                   '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
//               'date':
//                   '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
//               'dateTime': now.toIso8601String(),
//               'deviceToken': deviceToken,
//             });

//         setState(() => _isLoading = false);
//         Get.snackbar('Success', 'Registration successful');
//         Get.offAll(() => const HomeScreen());
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() => _isLoading = false);
//       if (e.code == 'email-already-in-use') {
//         Get.snackbar('Error', 'Email already registered. Please sign in.');
//       } else if (e.code == 'weak-password') {
//         Get.snackbar(
//           'Error',
//           'Password is too weak. Please use a stronger password.',
//         );
//       } else {
//         Get.snackbar('Error', e.message ?? 'Registration failed');
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       Get.snackbar('Error', 'Registration failed');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.purple700,
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const SizedBox(height: 26),
//                     Image.asset(
//                       'assets/images/app_icon.png',
//                       height: 100,
//                       fit: BoxFit.contain,
//                     ),
//                     const SizedBox(height: 39),
//                     Text(
//                       'All in One Automobile Solution',
//                       style: AppTextStyles.textView(
//                         size: 15,
//                         color: AppColors.black,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 6),
//                     Image.asset(
//                       'assets/images/groupvehicle.png',
//                       fit: BoxFit.contain,
//                     ),
//                     const SizedBox(height: 26),
//                     Text(
//                       'Full name',
//                       style: AppTextStyles.textView(
//                         size: 12,
//                         color: AppColors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _fullNameController,
//                       style: AppTextStyles.editText13Ssp(
//                         color: AppColors.black,
//                       ),
//                       decoration: const InputDecoration(
//                         hintText: 'Enter Full Name',
//                         hintStyle: TextStyle(color: AppColors.black),
//                         filled: true,
//                         fillColor: AppColors.bgEdittext,
//                       ),
//                     ),
//                     const SizedBox(height: 13),
//                     Text(
//                       'Mobile No.',
//                       style: AppTextStyles.textView(
//                         size: 12,
//                         color: AppColors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _mobileController,
//                       keyboardType: TextInputType.number,
//                       style: AppTextStyles.editText13Ssp(
//                         color: AppColors.black,
//                       ),
//                       decoration: const InputDecoration(
//                         hintText: 'Enter Mobile No',
//                         hintStyle: TextStyle(color: AppColors.black),
//                         filled: true,
//                         fillColor: AppColors.bgEdittext,
//                       ),
//                     ),
//                     const SizedBox(height: 13),
//                     Text(
//                       'Email',
//                       style: AppTextStyles.textView(
//                         size: 12,
//                         color: AppColors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       style: AppTextStyles.editText13Ssp(
//                         color: AppColors.black,
//                       ),
//                       decoration: const InputDecoration(
//                         hintText: 'Enter Email',
//                         hintStyle: TextStyle(color: AppColors.black),
//                         filled: true,
//                         fillColor: AppColors.bgEdittext,
//                       ),
//                     ),
//                     const SizedBox(height: 13),
//                     Text(
//                       'Password',
//                       style: AppTextStyles.textView(
//                         size: 12,
//                         color: AppColors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       style: AppTextStyles.editText13Ssp(
//                         color: AppColors.black,
//                       ),
//                       decoration: const InputDecoration(
//                         hintText: 'Enter Password',
//                         hintStyle: TextStyle(color: AppColors.black),
//                         filled: true,
//                         fillColor: AppColors.bgEdittext,
//                       ),
//                     ),
//                     const SizedBox(height: 39),
//                     GestureDetector(
//                       onTap: _register,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 8,
//                           horizontal: 52,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.black,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           'Submit',
//                           style: AppTextStyles.textView(
//                             size: 13,
//                             color: AppColors.purple700,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 13),
//                     GestureDetector(
//                       onTap: () => Get.off(() => const LoginScreen()),
//                       child: Text(
//                         'Already have an account? Sign In',
//                         style: AppTextStyles.textView(
//                           size: 12,
//                           color: AppColors.black,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/main_home_page/home_screen/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty ||
        mobile.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (mobile.length < 10) {
      Get.snackbar('Error', 'Enter valid mobile number');
      return;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);

    try {
      /// Create Firebase Auth user
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      /// Save user to Firestore
      await FirebaseFirestore.instance
          .collection('newusers')
          .doc(cred.user!.uid)
          .set({
        'uid': cred.user!.uid,
        'name': name,
        'mobile': mobile,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() => _isLoading = false);

      Get.snackbar('Success', 'Registration successful');
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', e.message ?? 'Registration failed');
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          /// ✅ FULL SCREEN BACKGROUND
          Positioned.fill(
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
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                /// Decorative bubbles
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

                /// Content
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.black,
                        ),
                      )
                    : SingleChildScrollView(
                        padding:
                            const EdgeInsets.fromLTRB(20, 40, 20, 40),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [
                            /// Logo
                            Center(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/app_icon.png',
                                  height: 90,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// Vehicle Image
                            Image.asset(
                              'assets/images/groupvehicle.png',
                              fit: BoxFit.contain,
                            ),

                            const SizedBox(height: 30),

                            /// Card
                            Container(
                              decoration:
                                  PremiumDecorations.card().copyWith(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFFCF4),
                                    Color(0xFFFFF3E0),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.black
                                      .withValues(alpha: 0.5),
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    26, 30, 26, 30),
                                child: Column(
                                  children: [
                                    _buildField(
                                        'Full Name',
                                        _nameController,
                                        Icons.person),

                                    const SizedBox(height: 20),

                                    _buildField(
                                        'Mobile Number',
                                        _mobileController,
                                        Icons.phone,
                                        TextInputType.phone),

                                    const SizedBox(height: 20),

                                    _buildField(
                                        'Email',
                                        _emailController,
                                        Icons.email,
                                        TextInputType.emailAddress),

                                    const SizedBox(height: 20),

                                    /// Password
                                    Container(
                                      decoration:
                                          PremiumDecorations.input(),
                                      child: TextField(
                                        controller:
                                            _passwordController,
                                        obscureText:
                                            _obscurePassword,
                                        decoration:
                                            PremiumDecorations
                                                .textField(
                                          hintText:
                                              'Enter Password',
                                          prefixIcon:
                                              const Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons
                                                      .visibility_off
                                                  : Icons.visibility,
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

                                    const SizedBox(height: 30),

                                    /// Button
                                    SizedBox(
                                      height: 52,
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed:
                                            _isLoading
                                                ? null
                                                : _register,
                                        style:
                                            PremiumDecorations
                                                .primaryButtonStyle,
                                        child: const Text(
                                          'Register',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.w600,
                                                height: 1.2
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Text(
                                "Already have an account? Login",
                                textAlign: TextAlign.center,
                                style: AppTextStyles.textView(
                                  size: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController controller,
      IconData icon,
      [TextInputType type = TextInputType.text]) {
    return Container(
      decoration: PremiumDecorations.input(),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: PremiumDecorations.textField(
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}