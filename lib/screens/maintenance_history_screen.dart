import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/report_model.dart';
import '../widgets/status_chip.dart';

class MaintenanceHistoryScreen extends StatefulWidget {
  final Function(ReportItem) onSelectReport;

  const MaintenanceHistoryScreen({super.key, required this.onSelectReport});

  @override
  State<MaintenanceHistoryScreen> createState() =>
      _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends State<MaintenanceHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ReportItem> getFilteredReports() {
    switch (_tabController.index) {
      case 1: // Aircon
        return sharedReports
            .where((r) => r.title.toLowerCase().contains('aircon'))
            .toList();
      case 2: // Lights
        return sharedReports
            .where((r) => r.title.toLowerCase().contains('light'))
            .toList();
      case 3: // Furniture
        return sharedReports
            .where((r) =>
                r.title.toLowerCase().contains('chair') ||
                r.title.toLowerCase().contains('table'))
            .toList();
      case 4: // Others
        return sharedReports
            .where((r) =>
                !r.title.toLowerCase().contains('aircon') &&
                !r.title.toLowerCase().contains('light') &&
                !r.title.toLowerCase().contains('chair'))
            .toList();
      default: // All
        return sharedReports;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final filteredList = getFilteredReports();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("MAINTENANCE HISTORY",
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
              Tab(text: "Aircon"),
              Tab(text: "Lights"),
              Tab(text: "Furniture"),
              Tab(text: "Others"),
            ],
          ),
          const SizedBox(height: 20),
          filteredList.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                      child: Text("No records found for this category.",
                          style: TextStyle(color: AppTheme.textSecondary))),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 900 ? 2 : 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: screenWidth > 500 ? 3.0 : 2.0,
                  ),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final report = filteredList[index];
                    return InkWell(
                      onTap: () => widget.onSelectReport(report),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Image.asset(report.imageUrl,
                                    errorBuilder: (c, e, s) => const Icon(
                                        Icons.ac_unit,
                                        color: Colors.grey,
                                        size: 36)),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StatusChip(label: report.status),
                                    const SizedBox(height: 6),
                                    Text(report.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                    Text(report.location,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: AppTheme.textSecondary)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
