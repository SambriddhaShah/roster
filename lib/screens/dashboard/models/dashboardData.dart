// Data Model
class DashboardData {
  final String employeeName;
  final String employeeEmail;
  final String employeeId;
  final String taskTitle;
  final String taskDescription;
  final String location;
  final DateTime startTime;
  final DateTime endTime;

  DashboardData({
    required this.employeeName,
    required this.employeeEmail,
    required this.employeeId,
    required this.taskTitle,
    required this.taskDescription,
    required this.location,
    required this.startTime,
    required this.endTime,
  });

  // Convert DashboardData to a Map
  Map<String, dynamic> toJson() {
    return {
      'employeeName': employeeName,
      'employeeEmail': employeeEmail,
      'employeeId': employeeId,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'location': location,
      'startTime': startTime.toIso8601String(),  // Convert DateTime to String
      'endTime': endTime.toIso8601String(),      // Convert DateTime to String
    };
  }

  // Create DashboardData from a Map
  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      employeeName: json['employeeName'],
      employeeEmail: json['employeeEmail'],
      employeeId: json['employeeId'],
      taskTitle: json['taskTitle'],
      taskDescription: json['taskDescription'],
      location: json['location'],
      startTime: DateTime.parse(json['startTime']),  // Convert String back to DateTime
      endTime: DateTime.parse(json['endTime']),      // Convert String back to DateTime
    );
  }
}
