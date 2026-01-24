import 'package:get/get.dart';

enum AssignmentStatus {
  pending,
  completed,
  overdue,
}

class AssignmentUIModel {
  final String id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final AssignmentStatus status;

  AssignmentUIModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.status,
  });
}

class AssignmentsController extends GetxController {
  final RxList<AssignmentUIModel> assignments = <AssignmentUIModel>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAssignments();
  }

  void loadAssignments() {
    // Mock data matching the UI image
    final now = DateTime.now();

    assignments.value = [
      AssignmentUIModel(
        id: '1',
        title: 'Math Worksheet - Chapter 5',
        subject: 'Mathematics',
        dueDate: now.add(const Duration(days: 1)),
        status: AssignmentStatus.pending,
      ),
      AssignmentUIModel(
        id: '2',
        title: 'English Essay - Shakespeare Analysis',
        subject: 'English Literature',
        dueDate: now.add(const Duration(days: 3)),
        status: AssignmentStatus.completed,
      ),
      AssignmentUIModel(
        id: '3',
        title: 'Science Report - Solar System',
        subject: 'Physics',
        dueDate: now.subtract(const Duration(days: 1)), // Overdue
        status: AssignmentStatus.overdue,
      ),
      AssignmentUIModel(
        id: '4',
        title: 'History Assignment - World War II',
        subject: 'History',
        dueDate: now.add(const Duration(days: 5)),
        status: AssignmentStatus.pending,
      ),
      AssignmentUIModel(
        id: '5',
        title: 'Chemistry Lab Report',
        subject: 'Chemistry',
        dueDate: now.add(const Duration(days: 2)),
        status: AssignmentStatus.completed,
      ),
    ];
  }

  List<AssignmentUIModel> get filteredAssignments {
    if (searchQuery.value.isEmpty) {
      return assignments;
    }
    return assignments.where((assignment) {
      return assignment.title
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          assignment.subject
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void search(String query) {
    searchQuery.value = query;
  }
}
