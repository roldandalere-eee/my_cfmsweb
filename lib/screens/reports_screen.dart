import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/report_model.dart';
import '../widgets/status_chip.dart';

class ReportsScreen extends StatefulWidget {
  final Function(ReportItem) onSelectReport;

  const ReportsScreen({super.key, required this.onSelectReport});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ReportItem> getFilteredReports() {
    switch (_tabController.index) {
      case 1:
        return sharedReports.where((r) => r.status == 'IN PROGRESS').toList();
      case 2:
        return sharedReports
            .where((r) => r.status == 'RESOLVED' || r.status == 'COMPLETED')
            .toList();
      case 3:
        return sharedReports.where((r) => r.status == 'CANCELLED').toList();
      default:
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
          const Text("REPORTS",
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
              Tab(text: "In progress"),
              Tab(text: "Resolved"),
              Tab(text: "Cancelled"),
            ],
          ),
          const SizedBox(height: 20),
          filteredList.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                      child: Text("No report items found.",
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
