import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class RaiseTicketScreen extends StatefulWidget {
  const RaiseTicketScreen({super.key});

  @override
  State<RaiseTicketScreen> createState() => _RaiseTicketScreenState();
}

class _RaiseTicketScreenState extends State<RaiseTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  String _selectedCategory = "General Query";
  bool _isLoading = false;

  final List<String> _categories = [
    "General Query",
    "Vehicle Booking Issue",
    "Insurance Issue",
    "Payment Problem",
    "Technical Issue",
  ];

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String phoneNumber = userDoc['phoneNumber'];

      String ticketId = FirebaseFirestore.instance
          .collection('help_tickets')
          .doc()
          .id;

      await FirebaseFirestore.instance
          .collection('help_tickets')
          .doc(ticketId)
          .set({
            'ticketId': ticketId,
            'uid': user.uid,
            'userId': phoneNumber,
            'category': _selectedCategory,
            'message': _messageController.text.trim(),
            'status': 'open',
            'createdAt': FieldValue.serverTimestamp(),
          });

      _messageController.clear();
      Get.back();

      Get.snackbar(
        "Success",
        "Ticket submitted successfully ✅",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true, // 👈 IMPORTANT

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFFFF59D).withValues(alpha: 0.9),
              padding: const EdgeInsets.all(8),
            ),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          'Raise a Ticket',
          style: GoogleFonts.openSans(
            fontSize: 18,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity, // 👈 FULL HEIGHT FIX
        width: double.infinity,

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
            const Positioned(
              top: -40,
              right: -30,
              child: ProfileBubble(size: 140, color: Color(0xFFFF9800)),
            ),
            const Positioned(
              bottom: -60,
              left: -40,
              child: ProfileBubble(size: 180, color: Color(0xFFF57C00)),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 90, 16, 16),
                child: Container(
                  decoration: PremiumDecorations.card().copyWith(
                    border: Border.all(color: Colors.black87, width: 2),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Category",
                          style: AppTextStyles.textView(
                            size: 14,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          items: _categories
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(
                              () => _selectedCategory = value.toString(),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Describe Issue",
                          style: AppTextStyles.textView(
                            size: 14,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _messageController,
                          maxLines: 5,
                          validator: (value) =>
                              value!.isEmpty ? "Enter your issue" : null,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Describe your issue...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            
                            onPressed: _isLoading ? null : _submitTicket,
                            style: PremiumDecorations.primaryButtonStyle,

                            child: _isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.black,
                                    ),
                                  )
                                : const Text("Submit Ticket"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
