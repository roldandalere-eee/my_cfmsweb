class ReportItem {
  final String id;
  final String title;
  final String location;
  String status;
  final String date;
  final String description;
  String assignedStaff;
  final String imageUrl;

  ReportItem({
    required this.id,
    required this.title,
    required this.location,
    required this.status,
    required this.date,
    required this.description,
    required this.assignedStaff,
    required this.imageUrl,
  });
}

// Mutable shared list of reports
List<ReportItem> sharedReports = [
  ReportItem(
    id: "1",
    title: "Aircon not cooling",
    location: "CITE Building | Room 302",
    status: "PENDING",
    date: "Sept 25, 2026",
    description:
        "The split-type AC in Room 302 is blowing warm air and making a rattling noise. It requires immediate maintenance.",
    assignedStaff: "Not Assigned Yet",
    imageUrl: "assets/images/logo.png",
  ),
  ReportItem(
    id: "2",
    title: "Water Leakage",
    location: "Main Hallway | 2nd Floor",
    status: "IN PROGRESS",
    date: "Sept 24, 2026",
    description:
        "Water dripping from pipe junction above the main corridor ceiling.",
    assignedStaff: "Juan Dela Cruz",
    imageUrl: "assets/images/logo.png",
  ),
  ReportItem(
    id: "3",
    title: "Broken Chair",
    location: "Library | Quiet Zone",
    status: "COMPLETED",
    date: "Sept 22, 2026",
    description: "Study chair backrest broken and detached.",
    assignedStaff: "Maria Santos",
    imageUrl: "assets/images/logo.png",
  ),
];
