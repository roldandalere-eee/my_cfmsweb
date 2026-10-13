import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/report_model.dart';
import 'widgets/responsive_scaffold.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/maintenance_history_screen.dart';
import 'screens/report_details_screen.dart';
import 'screens/task_assignment_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const CFMSApp());
}

class CFMSApp extends StatelessWidget {
  const CFMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CFMS - Campus Facility Maintenance System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const AuthScreen(initialIsSignUp: false),
        '/signup': (context) => const AuthScreen(initialIsSignUp: true),
        '/dashboard': (context) => const MainShell(),
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  ReportItem? _selectedReport;

  @override
  Widget build(BuildContext context) {
    Widget currentBody;

    if (_selectedReport != null) {
      currentBody = ReportDetailsScreen(
        report: _selectedReport!,
        onBack: () => setState(() => _selectedReport = null),
      );
    } else {
      switch (_currentIndex) {
        case 0:
          currentBody = DashboardScreen(
            onSelectReport: (report) =>
                setState(() => _selectedReport = report),
          );
          break;
        case 1:
          currentBody = ReportsScreen(
            onSelectReport: (report) =>
                setState(() => _selectedReport = report),
          );
          break;
        case 2:
          currentBody = MaintenanceHistoryScreen(
            onSelectReport: (report) =>
                setState(() => _selectedReport = report),
          );
          break;
        case 3:
          currentBody = const TaskAssignmentScreen();
          break;
        case 4:
          currentBody = const NotificationsScreen();
          break;
        case 5:
          currentBody = const SettingsScreen();
          break;
        default:
          currentBody = DashboardScreen(
            onSelectReport: (report) =>
                setState(() => _selectedReport = report),
          );
      }
    }

    return ResponsiveScaffold(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
          _selectedReport = null;
        });
      },
      body: currentBody,
    );
  }
}
