// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:zarooori_user/authentication/local/local_user_service.dart';
// import 'package:zarooori_user/main_home_page/home_screen/home_screen.dart';
// import 'package:zarooori_user/sos/location_service.dart';
// import 'package:zarooori_user/sos/sos_service.dart';
// import 'package:zarooori_user/sos/trusted_contacts.dart';


// class SosScreen extends StatefulWidget {
//   const SosScreen({super.key});

//   @override
//   State<SosScreen> createState() => _SosScreenState();
// }

// class _SosScreenState extends State<SosScreen> with TickerProviderStateMixin {
//   late AnimationController _pulseController;
//   late AnimationController _fabController;
//   late AnimationController _sirenController;
//   late AnimationController _particleController;

//   bool _isPressed = false;
//   final Random _random = Random();

//   @override
//   void initState() {
//     super.initState();

//     // 🔄 Multi-ripple pulse animation
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();

//     // 🔁 FAB floating animation
//     _fabController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//       lowerBound: -4,
//       upperBound: 4,
//     )..repeat(reverse: true);

//     // 🚨 Siren blinking controller
//     _sirenController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     )..repeat(reverse: true);

//     // 🔥 Particle animation (loop)
//     _particleController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 4),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     _fabController.dispose();
//     _sirenController.dispose();
//     _particleController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSosTap(BuildContext context) async {
//     HapticFeedback.mediumImpact();

//     setState(() {
//       _isPressed = true;
//     });
//     await Future.delayed(const Duration(milliseconds: 150));
//     setState(() {
//       _isPressed = false;
//     });

//     try {
//       final userId = await LocalUserService.getUserId();
//       if (userId == null || userId.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please register before using SOS'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }

//       final locationUrl = await LocationService.getLocationUrl();

//       await SosService.sendSOS(
//         userId: userId,
//         locationUrl: locationUrl,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('SOS sent successfully from server to your trusted one'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to send SOS'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   /// 🔹 Particle dot widget
//   Widget _buildParticle() {
//     final double radius = _random.nextDouble() * 130 + 30;
//     final double angle = _random.nextDouble() * 2 * pi;
//     final double size = _random.nextDouble() * 4 + 2;
//     final double x = radius * cos(angle);
//     final double y = radius * sin(angle);

//     return AnimatedBuilder(
//       animation: _particleController,
//       builder: (_, __) {
//         return Positioned(
//           left: 130 + x + _particleController.value * 4,
//           top: 130 + y + _particleController.value * 4,
//           child: Container(
//             width: size,
//             height: size,
//             decoration: BoxDecoration(
//               color: Colors.redAccent.withOpacity(0.6),
//               shape: BoxShape.circle,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//   leading: IconButton(
//     icon: const Icon(Icons.arrow_back_ios_new),
//     onPressed: () => HomeScreen(),
//   ),
//         title: const Text("24/7 Safety Line"),
//         backgroundColor: Colors.red.shade700,
//         foregroundColor: Colors.white,
//         elevation: 4,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(20),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: RadialGradient(
//             center: Alignment.center,
//             radius: 1.2,
//             colors: [
//               Colors.red.shade200.withOpacity(0.3),
//               Colors.red.shade50.withOpacity(0.15),
//               Colors.white.withOpacity(0.05),
//             ],
//             stops: [0.0, 0.6, 1.0],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // 🔴 Extra background circles for effect
//             for (int i = 0; i < 20; i++)
//               Positioned(
//                 left: _random.nextDouble() * MediaQuery.of(context).size.width,
//                 top: _random.nextDouble() * MediaQuery.of(context).size.height,
//                 child: Container(
//                   width: _random.nextDouble() * 100 + 40,
//                   height: _random.nextDouble() * 100 + 40,
//                   decoration: BoxDecoration(
//                     color: Colors.red.shade200.withOpacity(0.05 + _random.nextDouble() * 0.05),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),

//             /// Trusted Contacts FAB
//             Positioned(
//               top: 20,
//               right: 20,
//               child: AnimatedBuilder(
//                 animation: _fabController,
//                 builder: (_, child) {
//                   return Transform.translate(
//                     offset: Offset(0, _fabController.value),
//                     child: child,
//                   );
//                 },
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     FloatingActionButton(
//                       heroTag: "trusted_contacts",
//                       backgroundColor: Colors.red.shade700,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const TrustedContactsScreen(),
//                           ),
//                         );
//                       },
//                       child: const Icon(Icons.add, color: Colors.white),
//                     ),
//                     const SizedBox(height: 6),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.7),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Text(
//                         "Add your trusted contacts",
//                         style: TextStyle(color: Colors.white, fontSize: 12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             /// Center SOS button + ripple + particles
//             Center(
//               child: GestureDetector(
//                 onTap: () => _handleSosTap(context),
//                 child: SizedBox(
//                   width: 260,
//                   height: 260,
//                   child: Stack(
//                       clipBehavior: Clip.none, // ✅ allow siren outside

//                     alignment: Alignment.center,
//                     children: [
//                       // Multi ripple pulse
//                       for (int i = 0; i < 3; i++)
//                         AnimatedBuilder(
//                           animation: _pulseController,
//                           builder: (_, __) {
//                             double progress = (_pulseController.value + i * 0.3) % 1;
//                             return Container(
//                               width: 160 + 100 * progress,
//                               height: 160 + 100 * progress,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.red.withOpacity(0.3 * (1 - progress)),
//                               ),
//                             );
//                           },
//                         ),

//                       // Particle sparks
//                       for (int i = 0; i < 15; i++) _buildParticle(),

//                       // ⚡ Flashing siren above SOS (higher, top layer)
//                       Positioned(
//                         top: -50,
//                         child: AnimatedBuilder(
//                           animation: _sirenController,
//                           builder: (_, child) {
//                             return Opacity(
//                               opacity: _sirenController.value > 0.5 ? 1.0 : 0.3,
//                               child: child,
//                             );
//                           },
//                           child: Container(
//                             width: 45,
//                             height: 45,
//                             decoration: BoxDecoration(
//                               color: Colors.redAccent,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.redAccent.withOpacity(0.7),
//                                   blurRadius: 12,
//                                   spreadRadius: 5,
//                                 ),
//                               ],
//                             ),
//                             child: const Icon(
//                               Icons.warning_rounded,
//                               color: Colors.white,
//                               size: 24,
//                             ),
//                           ),
//                         ),
//                       ),

//                       // SOS button with tap feedback
//                       Transform.scale(
//                         scale: _isPressed ? 0.95 : 1.0,
//                         child: Container(
//                           height: 160,
//                           width: 160,
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.red.withOpacity(_isPressed ? 1.0 : 0.7),
//                                 blurRadius: _isPressed ? 40 : 30,
//                                 spreadRadius: _isPressed ? 12 : 8,
//                               ),
//                             ],
//                           ),
//                           child: const Center(
//                             child: Text(
//                               "SOS",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 36,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // Label below SOS
//                       Positioned(
//                         bottom: -40,
//                         child: Text(
//                           "Tap to send SOS to your trusted ones",
//                           style: TextStyle(
//                             color: Colors.red.shade700,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }