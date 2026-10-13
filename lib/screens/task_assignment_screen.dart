import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/report_model.dart';
import '../widgets/status_chip.dart';
import '../widgets/success_dialog.dart';

class StaffMember {
  final String name;
  String status; // "AVAILABLE" or "IN TASK"
  int tasksCount;

  StaffMember(
      {required this.name, required this.status, required this.tasksCount});
}

class TaskAssignmentScreen extends StatefulWidget {
  const TaskAssignmentScreen({super.key});

  @override
  State<TaskAssignmentScreen> createState() => _TaskAssignmentScreenState();
}

class _TaskAssignmentScreenState extends State<TaskAssignmentScreen> {
  final List<StaffMember> _staffList = [
    StaffMember(name: "Juan Dela Cruz", status: "AVAILABLE", tasksCount: 0),
    StaffMember(name: "Maria Santos", status: "AVAILABLE", tasksCount: 0),
    StaffMember(name: "Pedro Penduko", status: "IN TASK", tasksCount: 2),
  ];

  ReportItem get currentReport => sharedReports.firstWhere(
        (r) => r.status == 'PENDING' || r.assignedStaff == "Not Assigned Yet",
        orElse: () => sharedReports.first,
      );

  @override
  Widget build(BuildContext context) {
    final isAssigned = currentReport.assignedStaff != "Not Assigned Yet";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("TASK ASSIGNMENT",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text("Assign Task",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6)),
                    child:
                        const Icon(Icons.ac_unit, size: 36, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusChip(label: currentReport.status),
                        const SizedBox(height: 4),
                        Text(currentReport.title,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text(currentReport.location,
                            style: const TextStyle(
                                fontSize: 11, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isAssigned
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isAssigned
                            ? Colors.green.shade300
                            : Colors.red.shade300,
                      ),
                    ),
                    child: Text(
                      isAssigned
                          ? "Assigned To: ${currentReport.assignedStaff}"
                          : "Not Assigned Yet",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isAssigned
                            ? Colors.green.shade800
                            : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Technical Staff",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      headingRowHeight: 40,
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 48,
                      columns: const [
                        DataColumn(
                            label: Text("TECHNICAL STAFF",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("STATUS",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("CURRENT TASKS",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text("ACTION",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold))),
                      ],
                      rows: _staffList
                          .map((staff) => _buildStaffRow(context, staff))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildStaffRow(BuildContext context, StaffMember staff) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.person, size: 14, color: Colors.black87)),
              const SizedBox(width: 8),
              Text(staff.name, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        DataCell(StatusChip(label: staff.status)),
        DataCell(Text(staff.tasksCount.toString(),
            style: const TextStyle(fontSize: 12))),
        DataCell(
          SizedBox(
            height: 28,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryMaroon,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onPressed: () {
                setState(() {
                  currentReport.assignedStaff = staff.name;
                  currentReport.status = "IN PROGRESS";
                  staff.status = "IN TASK";
                  staff.tasksCount += 1;
                });
                showDialog(
                  context: context,
                  builder: (_) => const SuccessModal(title: "TASK ASSIGNED"),
                );
              },
              child: const Text("ASSIGN", style: TextStyle(fontSize: 10)),
            ),
          ),
        ),
      ],
    );
  }
}
