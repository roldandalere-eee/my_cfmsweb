import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationItemModel {
  final String title;
  final String subtitle;
  final bool isUnread;
  final bool isAnnouncement;
  final String timeCategory; // "Today" or "Yesterday"

  NotificationItemModel({
    required this.title,
    required this.subtitle,
    required this.isUnread,
    required this.isAnnouncement,
    required this.timeCategory,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<NotificationItemModel> _allNotifications = [
    NotificationItemModel(
      title: "Received new report",
      subtitle: "Aircon Not Cooling CITE Building Room 302 (Sept 4, 2026)",
      isUnread: true,
      isAnnouncement: false,
      timeCategory: "Today",
    ),
    NotificationItemModel(
      title: "Work in Progress",
      subtitle: "Aircon Not Cooling CITE Building Room 302 (Sept 4, 2026)",
      isUnread: true,
      isAnnouncement: false,
      timeCategory: "Today",
    ),
    NotificationItemModel(
      title: "System Announcement",
      subtitle: "Scheduled facility maintenance shutdown on Friday.",
      isUnread: false,
      isAnnouncement: true,
      timeCategory: "Today",
    ),
    NotificationItemModel(
      title: "Issue Resolved",
      subtitle: "Aircon Not Cooling CITE Building Room 302 (Sept 4, 2026)",
      isUnread: false,
      isAnnouncement: false,
      timeCategory: "Yesterday",
    ),
    NotificationItemModel(
      title: "Issue Resolved",
      subtitle: "Aircon Not Cooling CITE Building Room 302 (Sept 4, 2026)",
      isUnread: false,
      isAnnouncement: false,
      timeCategory: "Yesterday",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NotificationItemModel> getFilteredNotifications() {
    switch (_tabController.index) {
      case 1: // Unread
        return _allNotifications.where((n) => n.isUnread).toList();
      case 2: // Announcements
        return _allNotifications.where((n) => n.isAnnouncement).toList();
      default: // All
        return _allNotifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredNotifications();
    final todayItems =
        filtered.where((n) => n.timeCategory == "Today").toList();
    final yesterdayItems =
        filtered.where((n) => n.timeCategory == "Yesterday").toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("NOTIFICATIONS",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5)),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppTheme.primaryMaroon,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primaryMaroon,
            tabs: const [
              Tab(text: "All"),
              Tab(text: "Unread"),
              Tab(text: "Announcements"),
            ],
          ),
          const SizedBox(height: 24),
          if (todayItems.isNotEmpty) ...[
            const Text("Today",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondary)),
            const SizedBox(height: 10),
            ...todayItems.map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildNotificationCard(n),
                )),
          ],
          if (yesterdayItems.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Text("Yesterday",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondary)),
            const SizedBox(height: 10),
            ...yesterdayItems.map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildNotificationCard(n),
                )),
          ],
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                  child: Text("No notifications found.",
                      style: TextStyle(color: AppTheme.textSecondary))),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItemModel item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                item.isAnnouncement ? Icons.campaign_outlined : Icons.ac_unit,
                color: Colors.grey,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(item.subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            if (item.isUnread)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
