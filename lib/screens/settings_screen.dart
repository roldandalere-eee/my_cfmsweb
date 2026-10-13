import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("SETTINGS & PROFILE",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person_outline,
                        size: 40, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  const Text("Juan Dela Cruz",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Text("juan.delacruz@campus.edu",
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 24),
                  const Divider(),
                  SwitchListTile(
                    title: const Text("Enable Notifications",
                        style: TextStyle(fontSize: 13)),
                    value: _notifications,
                    activeColor: AppTheme.primaryMaroon,
                    onChanged: (val) => setState(() => _notifications = val),
                  ),
                  const ListTile(
                    leading: Icon(Icons.lock_outline, size: 20),
                    title:
                        Text("Change Password", style: TextStyle(fontSize: 13)),
                    trailing: Icon(Icons.chevron_right, size: 20),
                  ),
                  const ListTile(
                    leading: Icon(Icons.help_outline, size: 20),
                    title:
                        Text("Help & Support", style: TextStyle(fontSize: 13)),
                    trailing: Icon(Icons.chevron_right, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
