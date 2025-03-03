class HistoryData {
  final String taskTitle;
  final String taskDescription;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final String employeeName;
  final String employeeEmail;
  final String isLate;

  HistoryData({
    required this.taskTitle,
    required this.taskDescription,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.employeeEmail,
    required this.employeeName,
    required this.isLate
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      taskTitle: json['taskTitle'],
      taskDescription: json['taskDescription'],
      location: json['location'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      employeeEmail: json['employeeEmail'],
      employeeName: json['employeeName'], isLate: json['isLate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'location': location,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'employeeEmail':employeeEmail,
      'employeeName':employeeName,
      'isLate':isLate
    };
  }
}