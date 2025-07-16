class CandidateStageResponse {
  final bool success;
  final List<CandidateStage> data;

  CandidateStageResponse({required this.success, required this.data});

  factory CandidateStageResponse.fromJson(Map<String, dynamic> json) {
    return CandidateStageResponse(
      success: json['success'],
      data: (json['data'] as List)
          .map((e) => CandidateStage.fromJson(e))
          .toList(),
    );
  }
}

class CandidateStage {
  final String candidateStageId;
  final String jobId;
  final int displayOrder;
  final String hiringStageName;
  final String statusId;
  final String statusName;
  final List<dynamic> assignedUsers;

  CandidateStage({
    required this.candidateStageId,
    required this.jobId,
    required this.displayOrder,
    required this.hiringStageName,
    required this.statusId,
    required this.statusName,
    required this.assignedUsers,
  });

  factory CandidateStage.fromJson(Map<String, dynamic> json) {
    return CandidateStage(
      candidateStageId: json['candidateStageId'],
      jobId: json['jobId'],
      displayOrder: json['displayOrder'],
      hiringStageName: json['hiringStageName'],
      statusId: json['statusId'],
      statusName: json['statusName'],
      assignedUsers: json['assignedUsers'] ?? [],
    );
  }
}
