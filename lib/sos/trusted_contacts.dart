// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:zarooori_user/authentication/local/local_user_service.dart';

// /// TrustedContactsScreen - Manages trusted contacts for SOS emergency alerts
// /// 
// /// Uses locally stored user data (phone/email) from native Android SharedPreferences
// /// as the userId instead of Firebase Authentication.
// /// 
// /// Firebase Collection Structure:
// ///   trustedContacts/
// ///     {mobileNo}/                  // User's mobile number (user ID)
// ///         {contactId}/             // Auto-generated document ID
// ///           name: String           // Contact name
// ///           phone: String           // Contact phone number
// ///           createdAt: Timestamp    // When contact was added
// class TrustedContactsScreen extends StatefulWidget {
//   const TrustedContactsScreen({super.key});

//   @override
//   State<TrustedContactsScreen> createState() =>
//       _TrustedContactsScreenState();
// }

// class _TrustedContactsScreenState extends State<TrustedContactsScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isAdding = false;

//   final FirebaseFirestore _db = FirebaseFirestore.instance;
  
//   /// Get current user ID from local storage (phone number or email)
//   /// Uses LocalUserService to read from native Android SharedPreferences
//   /// Returns null if user is not registered
//   Future<String?> get userId async => await LocalUserService.getUserId();

//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     super.dispose();
//   }

//   Future<void> _showAddContactDialog() async {
//     nameController.clear();
//     phoneController.clear();
//     _isAdding = false;

//     await showDialog(
//       context: context,
//       barrierColor: Colors.black54,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.2),
//                   blurRadius: 24,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.red.shade50,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Icon(Icons.person_add_rounded, color: Colors.red.shade700, size: 24),
//                         ),
//                         const SizedBox(width: 14),
//                         const Text(
//                           'Add Trusted Contact',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF1A1A1A),
//                             letterSpacing: 0.2,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     TextFormField(
//                       controller: nameController,
//                       decoration: InputDecoration(
//                         labelText: 'Name',
//                         hintText: 'Enter contact name',
//                         prefixIcon: Icon(Icons.person_outline_rounded, color: Colors.grey.shade600, size: 20),
//                         filled: true,
//                         fillColor: Colors.grey.shade50,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.grey.shade200),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) return 'Please enter a name';
//                         return null;
//                       },
//                       textCapitalization: TextCapitalization.words,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: phoneController,
//                       decoration: InputDecoration(
//                         labelText: 'Phone Number',
//                         hintText: 'Enter phone number',
//                         prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey.shade600, size: 20),
//                         filled: true,
//                         fillColor: Colors.grey.shade50,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.grey.shade200),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
//                         ),
//                       ),
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) return 'Please enter a phone number';
//                         final digits = value.replaceAll(RegExp(r'[^\d]'), '');
//                         if (digits.length < 10) return 'Please enter a valid phone number';
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextButton(
//                             onPressed: () => Navigator.of(context).pop(),
//                             style: TextButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                             ),
//                             child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: _isAdding ? null : _addContact,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red.shade700,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                             ),
//                             child: _isAdding
//                                 ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                                 : const Text('Add', style: TextStyle(fontWeight: FontWeight.w600)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /// Add a new trusted contact to Firebase
//   /// Stores contact under the current user's ID in Firestore
//   Future<void> _addContact() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _isAdding = true;
//     });

//     final name = nameController.text.trim();
//     final phone = phoneController.text.trim().replaceAll(RegExp(r'[^\d+]'), '');

//     // Get current user ID from local storage (phone or email)
//     final currentUserId = await userId;
//     if (currentUserId == null || currentUserId.isEmpty) {
//       if (mounted) {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('User not registered. Please register first.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//       return;
//     }

//     try {
//       // Check if contact with same phone number already exists for this user
//       final existingContacts = await _db
//           .collection('trustedContacts')
//           .doc(currentUserId)  // Mobile number as user ID
//           .collection('contacts')
//           .where('phone', isEqualTo: phone)
//           .get();

//       if (existingContacts.docs.isNotEmpty) {
//         if (mounted) {
//           Navigator.of(context).pop();
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('This phone number is already in your trusted contacts'),
//               backgroundColor: Colors.orange,
//             ),
//           );
//         }
//         return;
//       }

//       // Add contact to Firebase under current user's ID
//       // Collection path: trustedContacts/{mobileNo}/contacts/{autoId}
//       await _db
//           .collection('trustedContacts')
//           .doc(currentUserId)  // Mobile number as user ID
//           .collection('contacts')
//           .add({
//         "name": name,                    // Contact name
//         "phone": phone,                  // Contact phone number
//         "createdAt": FieldValue.serverTimestamp(),  // Timestamp when added
//       });

//       if (mounted) {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Contact added successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error adding contact: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isAdding = false;
//         });
//       }
//     }
//   }

//   /// Delete a trusted contact from Firebase
//   /// Only deletes from the current user's contact list
//   Future<void> _deleteContact(String docId, String contactName) async {
//     // Show confirmation dialog before deleting
//     final confirmed = await showDialog<bool>(
//       context: context,
//       barrierColor: Colors.black54,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.2),
//                   blurRadius: 24,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: Colors.red.shade50,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade700, size: 32),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Delete Contact',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1A1A1A),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Are you sure you want to delete $contactName from your trusted contacts?',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
//                 ),
//                 const SizedBox(height: 24),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextButton(
//                         onPressed: () => Navigator.of(context).pop(false),
//                         style: TextButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: ElevatedButton(
//                         onPressed: () => Navigator.of(context).pop(true),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red.shade700,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                         child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );

//     if (confirmed != true) return;

//     // Get current user ID from local storage (phone or email)
//     final currentUserId = await userId;
//     if (currentUserId == null || currentUserId.isEmpty) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('User not registered. Please register first.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//       return;
//     }

//     try {
//       // Delete contact from current user's collection only
//       // Path: trustedContacts/{mobileNo}/contacts/{docId}
//       await _db
//           .collection('trustedContacts')
//           .doc(currentUserId)  // Mobile number as user ID
//           .collection('contacts')
//           .doc(docId)  // Specific contact document ID
//           .delete();
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Contact deleted successfully'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error deleting contact: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Use FutureBuilder to get userId from local storage
//     return FutureBuilder<String?>(
//       future: userId,
//       builder: (context, userIdSnapshot) {
//         // Show loading while fetching userId
//         if (userIdSnapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text("Trusted Contacts"),
//               backgroundColor: Colors.red.shade700,
//               foregroundColor: Colors.white,
//             ),
//             body: const Center(child: CircularProgressIndicator()),
//           );
//         }

//         // Check if user is registered (has userId from Firebase or local storage)
//         final currentUserId = userIdSnapshot.data;
//         if (currentUserId == null || currentUserId.isEmpty) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text("Trusted Contacts"),
//               backgroundColor: Colors.red.shade700,
//               foregroundColor: Colors.white,
//             ),
//             body: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Registration Required',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Please log in to view your trusted contacts',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }

//         // Firebase Firestore collection structure:
//         //   trustedContacts/{mobileNo}/contacts/
//         // mobileNo = user's mobile number (user ID)
//         final contactsRef = _db
//             .collection('trustedContacts')
//             .doc(currentUserId)  // Mobile number as user ID
//             .collection('contacts');  // Sub-collection of contacts for this user

//         return Scaffold(
//       appBar: AppBar(
//         title: const Text("Trusted Contacts"),
//         backgroundColor: Colors.red.shade700,
//         foregroundColor: Colors.white,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: contactsRef.snapshots(),
//         builder: (context, snapshot) {
//           // Handle connection state
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           // Handle errors with better visibility
//           if (snapshot.hasError) {
//             debugPrint('TrustedContactsScreen Error: ${snapshot.error}');
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.error_outline, size: 64, color: Colors.red),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Error loading contacts',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey.shade800,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       '${snapshot.error}',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () => setState(() {}),
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           // Handle empty data
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.contacts_outlined,
//                       size: 100,
//                       color: Colors.grey.shade400,
//                     ),
//                     const SizedBox(height: 24),
//                     Text(
//                       'No trusted contacts yet',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Add trusted contacts to receive SOS alerts',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade500,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           // Sort documents by createdAt in memory (newest first)
//           final docs = List.from(snapshot.data!.docs);
//           docs.sort((a, b) {
//             final aData = a.data() as Map<String, dynamic>;
//             final bData = b.data() as Map<String, dynamic>;
//             final aTime = aData['createdAt'] as Timestamp?;
//             final bTime = bData['createdAt'] as Timestamp?;
//             if (aTime == null && bTime == null) return 0;
//             if (aTime == null) return 1;
//             if (bTime == null) return -1;
//             return bTime.compareTo(aTime); // Descending order
//           });

//           return Column(
//             children: [
//               // Header info
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 color: Colors.red.shade50,
//                 child: Row(
//                   children: [
//                     Icon(Icons.info_outline, color: Colors.red.shade700),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Your trusted contacts will be notified in case of emergency',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.red.shade900,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Contacts list
//               Expanded(
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: docs.length,
//                   itemBuilder: (context, index) {
//                     try {
//                       final doc = docs[index];
//                       final data = doc.data();
                      
//                       if (data == null || data is! Map<String, dynamic>) {
//                         return const SizedBox.shrink();
//                       }
                      
//                       final name = data['name']?.toString().trim() ?? 'Unknown';
//                       final phone = data['phone']?.toString().trim() ?? '';

//                       return Card(
//                         margin: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         elevation: 2,
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: Colors.red.shade700,
//                             child: Text(
//                               name.isNotEmpty ? name[0].toUpperCase() : '?',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           title: Text(
//                             name,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           subtitle: Row(
//                             children: [
//                               const Icon(Icons.phone, size: 16),
//                               const SizedBox(width: 4),
//                               Expanded(
//                                 child: Text(
//                                   phone,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _deleteContact(doc.id, name),
//                             tooltip: 'Delete contact',
//                           ),
//                           isThreeLine: false,
//                         ),
//                       );
//                     } catch (e) {
//                       debugPrint('Error building contact item: $e');
//                       return const SizedBox.shrink();
//                     }
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _showAddContactDialog,
//         backgroundColor: Colors.red.shade700,
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: const Text(
//           'Add Contact',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/authentication/local/local_user_service.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';

class TrustedContactsScreen extends StatefulWidget {
  final bool showBackButton;

  const TrustedContactsScreen({super.key, this.showBackButton = true});

  @override
  State<TrustedContactsScreen> createState() =>
      _TrustedContactsScreenState();
}

class _TrustedContactsScreenState extends State<TrustedContactsScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> get userId async => await LocalUserService.getUserId();

  /// ================= ADD CONTACT DIALOG =================

  Future<void> _showAddContactDialog() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final currentUserId = await userId;
              if (currentUserId == null) return;

              await _db
                  .collection('trustedContacts')
                  .doc(currentUserId)
                  .collection('contacts')
                  .add({
                "name": nameController.text.trim(),
                "phone": phoneController.text.trim(),
                "createdAt": FieldValue.serverTimestamp(),
              });

              Get.back();
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  /// ================= DELETE =================

  Future<void> _deleteContact(String docId) async {
    final currentUserId = await userId;
    if (currentUserId == null) return;

    await _db
        .collection('trustedContacts')
        .doc(currentUserId)
        .collection('contacts')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: userId,
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final currentUserId = userSnapshot.data!;

        final contactsRef = _db
            .collection('trustedContacts')
            .doc(currentUserId)
            .collection('contacts');

        return Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,

          /// ================= APP BAR =================
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: widget.showBackButton
                ? Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFFFF59D).withValues(alpha: 0.9),
                        padding: const EdgeInsets.all(8),
                      ),
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.black, size: 20),
                      onPressed: () => Get.back(),
                    ),
                  )
                : null,
            title: Text(
              'Trusted Contacts',
              style: GoogleFonts.openSans(
                fontSize: 18,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),

          /// ================= BODY =================
          body: Container(
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
                /// bubbles
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
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        /// INFO CARD
                        Container(
                          decoration: PremiumDecorations.card().copyWith(
                            border: Border.all(
                                color: Colors.black87, width: 2),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  color: AppColors.black),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Your trusted contacts will be notified in case of emergency.',
                                  style: AppTextStyles.textView(
                                      size: 13,
                                      color: AppColors.black),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// CONTACT LIST
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: contactsRef.snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return _emptyState();
                              }

                              final docs = snapshot.data!.docs;

                              return ListView.builder(
                                itemCount: docs.length,
                                itemBuilder: (_, i) {
                                  final doc = docs[i];
                                  final data =
                                      doc.data() as Map<String, dynamic>;

                                  final name =
                                      data['name'] ?? "Unknown";
                                  final phone =
                                      data['phone'] ?? "";

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 6),
                                    decoration:
                                        PremiumDecorations.card()
                                            .copyWith(
                                      border: Border.all(
                                          color: Colors.black87,
                                          width: 2),
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            AppColors.black,
                                        child: Text(
                                          name[0].toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      title: Text(name),
                                      subtitle: Text(phone),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            _deleteContact(doc.id),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ================= FAB =================
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showAddContactDialog,
            backgroundColor: AppColors.black,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Contact',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  /// ================= EMPTY STATE =================

  Widget _emptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.contacts_outlined,
                size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text(
              'No trusted contacts yet',
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add contacts to receive SOS alerts in emergencies.',
              style: AppTextStyles.textView(
                  size: 14, color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}