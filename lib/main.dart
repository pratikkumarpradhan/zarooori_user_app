// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:zarooori_user/Authentication/login_screen.dart';
// import 'package:zarooori_user/Authentication/register_screen.dart';
// import 'package:zarooori_user/main_home_page/home_screen/home_screen.dart';
// import 'package:zarooori_user/sos/sos_screen.dart';
// import 'package:zarooori_user/splash_page/splash_screen.dart';

// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   } catch (e) {
//     // If default app already exists (e.g. from host Android app), continue
//     if (!e.toString().toLowerCase().contains('already exists')) rethrow;
//   }

//   // Initialize Firebase Messaging for FCM token (used at registration)
//   try {
//     await FirebaseMessaging.instance.requestPermission();
//   } catch (_) {}

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final initialRoute =
//         WidgetsBinding.instance.platformDispatcher.defaultRouteName;

//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Zarooori',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFD13D)),
//         useMaterial3: true,
//       ),
//       initialRoute: initialRoute.isEmpty ? '/' : initialRoute,
//       getPages: [
//         GetPage(name: '/', page: () => const SplashScreen()),
//         GetPage(name: '/login', page: () => const LoginScreen()),
//         GetPage(name: '/register', page: () => const RegisterScreen()),
//         GetPage(name: '/home', page: () => const HomeScreen()),
//         GetPage(name: '/sos', page: () => SosScreen()),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zarooori_user/Authentication/login_screen.dart';
import 'package:zarooori_user/Authentication/register_screen.dart';
import 'package:zarooori_user/main_home_page/home_screen/home_screen.dart';
import 'package:zarooori_user/sos/sos_button.dart';
import 'package:zarooori_user/sos/sos_screen.dart';
import 'package:zarooori_user/splash_page/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (!e.toString().toLowerCase().contains('already exists')) rethrow;
  }

  try {
    await FirebaseMessaging.instance.requestPermission();
  } catch (_) {}

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final initialRoute =
        WidgetsBinding.instance.platformDispatcher.defaultRouteName;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zarooori',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFD13D)),
        useMaterial3: true,
      ),
      initialRoute: initialRoute.isEmpty ? '/' : initialRoute,
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/sos', page: () => SosFloatingButton()),
      ],
    );
  }
}