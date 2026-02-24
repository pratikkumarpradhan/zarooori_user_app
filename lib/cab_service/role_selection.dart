import 'package:flutter/material.dart';

class RoleSelection extends StatelessWidget {
  const RoleSelection({super.key});

  Widget gradientButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(colors: gradientColors),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            gradientButton(
              onPressed: () {
                // Get.to(() => UserLoginScreen());
              },
              label: "User",
              icon: Icons.person,
              gradientColors: [Colors.blue.shade400, Colors.blue.shade800],
            ),
            SizedBox(height: 20),
            gradientButton(
              onPressed: () {
                // Get.to(() => DriverDashboardScreen(
                //     // driverName: 'James',
                //     ));
                //  Get.to(() => DriverLoginPage());
              },
              label: "Driver",
              icon: Icons.drive_eta,
              gradientColors: [Colors.orange.shade400, Colors.orange.shade800],
            ),
          ],
        ),
      ),
    );
  }
}
