import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResponsiveScaffold extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final Widget body;

  const ResponsiveScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
  });

  static const List<Map<String, dynamic>> _navItems = [
    {
      'icon': Icons.dashboard_outlined,
      'activeIcon': Icons.dashboard,
      'label': 'Dashboard'
    },
    {
      'icon': Icons.assignment_outlined,
      'activeIcon': Icons.assignment,
      'label': 'Reports'
    },
    {
      'icon': Icons.history_outlined,
      'activeIcon': Icons.history,
      'label': 'Maintenance History'
    },
    {
      'icon': Icons.task_outlined,
      'activeIcon': Icons.task,
      'label': 'Task Assignment'
    },
    {
      'icon': Icons.notifications_none,
      'activeIcon': Icons.notifications,
      'label': 'Notifications'
    },
    {
      'icon': Icons.settings_outlined,
      'activeIcon': Icons.settings,
      'label': 'Settings'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppTheme.primaryMaroon,
              foregroundColor: Colors.white,
              title: const Text("CFMS",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
      drawer: isDesktop ? null : Drawer(child: _buildSidebarContent(context)),
      body: Row(
        children: [
          if (isDesktop)
            SizedBox(
              width: 240,
              child: Drawer(
                elevation: 0,
                shape: const RoundedRectangleBorder(),
                child: _buildSidebarContent(context),
              ),
            ),
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(context),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Clickable User Profile Area
          PopupMenuButton<String>(
            tooltip: "Profile Options",
            offset: const Offset(0, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onSelected: (value) {
              if (value == 'profile' || value == 'settings') {
                onDestinationSelected(5); // Navigates to Settings
              } else if (value == 'logout') {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: const [
                    Icon(Icons.person_outline,
                        size: 18, color: AppTheme.textPrimary),
                    SizedBox(width: 10),
                    Text("My Profile", style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: const [
                    Icon(Icons.settings_outlined,
                        size: 18, color: AppTheme.textPrimary),
                    SizedBox(width: 10),
                    Text("Settings", style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout, size: 18, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Text("Logout",
                        style:
                            TextStyle(fontSize: 13, color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          "Hi, Juan!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          "Have your facility needs addressed",
                          style: TextStyle(
                              fontSize: 10, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Icon(Icons.person_outline,
                          color: Colors.black87, size: 22),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 30),
          Column(
            children: [
              // Custom Image Logo
              SizedBox(
                width: 48,
                height: 48,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "CFMS",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: AppTheme.primaryMaroon),
              ),
              const Text(
                "CAMPUS FACILITY\nMAINTENANCE SYSTEM",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondary,
                    height: 1.2),
              ),
            ],
          ),
          // ... rest of sidebar content
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryMaroon
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      isSelected
                          ? _navItems[index]['activeIcon']
                          : _navItems[index]['icon'],
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      size: 18,
                    ),
                    title: Text(
                      _navItems[index]['label'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                    onTap: () {
                      onDestinationSelected(index);
                      if (Scaffold.of(context).isDrawerOpen) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout,
                color: AppTheme.textSecondary, size: 18),
            title: const Text("Logout",
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
            onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
