import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zarooori_user/api_services/reminders_firestore.dart';
import 'package:zarooori_user/authentication/local/local_auth.dart';
import 'package:zarooori_user/decorative_ui/app_colours.dart';
import 'package:zarooori_user/decorative_ui/app_textstyle.dart';
import 'package:zarooori_user/decorative_ui/premium_decoration.dart';
import 'package:zarooori_user/drawer_menu/profile/profile_bubble_screen.dart';
import 'package:zarooori_user/models/product_model.dart';



class ReminderListScreen extends StatefulWidget {
  final bool showBackButton;

  const ReminderListScreen({super.key, this.showBackButton = true});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> with WidgetsBindingObserver {
  final _searchController = TextEditingController();
  List<ReminderItem> _reminders = [];
  List<ReminderItem> _filteredList = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(_onSearchChanged);
    _loadReminders();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadReminders();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredList = List.from(_reminders);
      } else {
        _filteredList = _reminders.where((item) {
          final title = item.title?.toLowerCase() ?? '';
          final description = item.description?.toLowerCase() ?? '';
          return title.contains(query) || description.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadReminders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = await LocalAuthHelper.getUserId();
      if (userId == null || userId.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = 'Please login to view reminders';
            _reminders = [];
            _filteredList = [];
          });
        }
        return;
      }

      final list = await RemindersFirestore.getMyReminders(userId);
      if (mounted) {
        setState(() {
          _reminders = list;
          _filteredList = List.from(list);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString().replaceAll('Exception: ', '');
          _reminders = [];
          _filteredList = [];
        });
      }
    }
  }

  Future<void> _deleteReminder(ReminderItem item) async {
    final userId = await LocalAuthHelper.getUserId();
    if (userId == null || item.id == null) return;
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete reminder?'),
        content: Text(
          'Delete reminder "${item.title ?? 'Untitled'}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Yes, delete'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    try {
      await RemindersFirestore.deleteReminder(userId, item.id!);
      if (mounted) {
        Get.snackbar(
          'Deleted',
          'Reminder deleted',
          backgroundColor: AppColors.white,
          colorText: AppColors.black,
          snackPosition: SnackPosition.BOTTOM,
        );
        _loadReminders();
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> _showAddReminderDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    await Get.dialog(
      AlertDialog(
        title: const Text('Add Reminder'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: Get.context!,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    dateController.text =
                        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time (HH:MM)',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  final time = await showTimePicker(
                    context: Get.context!,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    timeController.text =
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty ||
                  dateController.text.trim().isEmpty ||
                  timeController.text.trim().isEmpty) {
                Get.snackbar('Error', 'Please fill all required fields');
                return;
              }
              final userId = await LocalAuthHelper.getUserId();
              if (userId == null) {
                Get.snackbar('Error', 'Please login to add reminder');
                Get.back();
                return;
              }
              try {
                await RemindersFirestore.saveReminder(
                  userId: userId,
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  date: dateController.text.trim(),
                  time: timeController.text.trim(),
                );
                Get.back();
                Get.snackbar('Success', 'Reminder added successfully',
                    backgroundColor: AppColors.white,
                    colorText: AppColors.black,
                    snackPosition: SnackPosition.BOTTOM);
                _loadReminders();
              } catch (e) {
                Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '-';
    final parts = date.split('-');
    if (parts.length >= 3) {
      final y = parts[0], m = parts[1], d = parts[2];
      return '$d/$m/$y';
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: widget.showBackButton
            ? Container(
                margin: const EdgeInsets.only(left: 8),
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFFF59D).withValues(alpha: 0.9),
                    padding: const EdgeInsets.all(8),
                  ),
                  icon: const Icon(Icons.arrow_back, color: AppColors.black, size: 20),
                  onPressed: () => Get.back(),
                ),
              )
            : null,
        title: Text(
          'My Reminders',
          style: GoogleFonts.openSans(fontSize: 18, color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFFFF59D).withValues(alpha: 0.9),
                padding: const EdgeInsets.all(8),
              ),
              icon: const Icon(Icons.add, color: AppColors.black, size: 20),
              onPressed: _showAddReminderDialog,
            ),
          ),
        ],
      ),
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    _buildSearchField(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _error != null
                              ? _buildErrorState()
                              : _filteredList.isEmpty
                                  ? _buildEmptyState()
                                  : _buildRemindersList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      child: TextField(
        controller: _searchController,
        decoration: PremiumDecorations.textField(
          hintText: 'Search reminders...',
          prefixIcon: const Icon(Icons.search, color: AppColors.black),
        ),
        style: AppTextStyles.textView(size: 14, color: AppColors.black),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error ?? 'An error occurred',
              style: AppTextStyles.textView(size: 14, color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadReminders,
              style: PremiumDecorations.primaryButtonStyle,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        decoration: PremiumDecorations.card().copyWith(
          border: Border.all(color: Colors.black87, width: 2),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.alarm_off, size: 64, color: AppColors.gray),
            const SizedBox(height: 16),
            Text(
              'No reminders yet',
              style:  GoogleFonts.openSans(fontSize: 16, color: AppColors.black).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add a new reminder',
              style: AppTextStyles.textView(size: 14, color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemindersList() {
    return RefreshIndicator(
      onRefresh: _loadReminders,
      color: AppColors.black,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: _filteredList.length,
        itemBuilder: (context, index) => _ReminderCard(
          item: _filteredList[index],
          formatDate: _formatDate,
          onDelete: () => _deleteReminder(_filteredList[index]),
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final ReminderItem item;
  final String Function(String?) formatDate;
  final VoidCallback onDelete;

  const _ReminderCard({
    required this.item,
    required this.formatDate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: PremiumDecorations.card().copyWith(
        border: Border.all(color: Colors.black87, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF59D).withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.alarm, color: AppColors.black, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? 'Untitled',
                        style: AppTextStyles.textView(size: 16, color: AppColors.black).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatDate(item.date)} at ${item.time ?? '-'}',
                        style: AppTextStyles.textView(size: 13, color: AppColors.gray),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (item.description != null && item.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF59D).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.description!,
                  style: AppTextStyles.textView(size: 13, color: AppColors.black),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}