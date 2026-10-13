import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/report_model.dart';
import '../widgets/status_chip.dart';

class ReportDetailsScreen extends StatelessWidget {
  final ReportItem report;
  final VoidCallback onBack;

  const ReportDetailsScreen({
    super.key,
    required this.report,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("REPORT DETAILS",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back,
                size: 16, color: AppTheme.textPrimary),
            label: const Text("Back",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 650;
                  return isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImageContainer(240, 180),
                            const SizedBox(width: 24),
                            Expanded(child: _buildDetailsContent()),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImageContainer(double.infinity, 200),
                            const SizedBox(height: 20),
                            _buildDetailsContent(),
                          ],
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.ac_unit, size: 64, color: Colors.grey),
    );
  }

  Widget _buildDetailsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusChip(label: report.status),
        const SizedBox(height: 8),
        Text(report.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(report.location,
            style:
                const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        const SizedBox(height: 16),
        const Text("Description:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          report.description,
          style: const TextStyle(
              fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
        ),
        const SizedBox(height: 20),
        Text("Assigned To: ${report.assignedStaff}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
