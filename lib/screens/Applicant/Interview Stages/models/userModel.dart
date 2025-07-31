class CandidateResponse {
  final bool success;
  final String message;
  final CandidateData data;

  CandidateResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CandidateResponse.fromJson(Map<String, dynamic> json) {
    return CandidateResponse(
      success: json['success'],
      message: json['message'],
      data: CandidateData.fromJson(json['data']),
    );
  }
}

class CandidateData {
  final Candidate candidate;
  final List<JobApplication> jobs;

  CandidateData({
    required this.candidate,
    required this.jobs,
  });

  factory CandidateData.fromJson(Map<String, dynamic> json) {
    return CandidateData(
      candidate: Candidate.fromJson(json['candidate']),
      jobs: (json['jobs'] as List)
          .map((e) => JobApplication.fromJson(e))
          .toList(),
    );
  }
}

class Candidate {
  final String id;
  final String tenantId;
  final String jobId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String? city;
  final String? state;
  final String? country;
  final String? zip;
  final String? statusId;
  final String? matchScore;
  final String? source;
  final String? referredBy;
  final String? resumeFileId;
  final String? coverLetterFileId;
  final String createdAt;
  final String updatedAt;

  Candidate({
    required this.id,
    required this.tenantId,
    required this.jobId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    this.city,
    this.state,
    this.country,
    this.zip,
    this.statusId,
    this.matchScore,
    this.source,
    this.referredBy,
    this.resumeFileId,
    this.coverLetterFileId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'],
      tenantId: json['tenantId'],
      jobId: json['jobId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zip: json['zip'],
      statusId: json['statusId'],
      matchScore: json['matchScore'],
      source: json['source'],
      referredBy: json['referredBy'],
      resumeFileId: json['resumeFileId'],
      coverLetterFileId: json['coverLetterFileId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class JobApplication {
  final Job job;
  final Application application;
  final List<Stage> stages;
  final List<Interview> interviews;

  JobApplication({
    required this.interviews,
    required this.job,
    required this.application,
    required this.stages,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      job: Job.fromJson(json['job']),
      application: Application.fromJson(json['application']),
      stages: (json['stages'] as List).map((e) => Stage.fromJson(e)).toList(),
      interviews: (json['interviews'] as List?)
              ?.map((e) => Interview.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Job {
  final String id;
  final String tenantId;
  final String title;
  final String description;
  final String pageId;
  final String formId;
  final String? employmentTypeId;
  final String? department;
  final String? hiringStageId;
  final String? status;
  final String? archivedAt;
  final String createdBy;
  final String? updatedBy;
  final String createdAt;
  final String updatedAt;

  Job({
    required this.id,
    required this.tenantId,
    required this.title,
    required this.description,
    required this.pageId,
    required this.formId,
    this.employmentTypeId,
    this.department,
    this.hiringStageId,
    this.status,
    this.archivedAt,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      tenantId: json['tenantId'],
      title: json['title'],
      description: json['description'],
      pageId: json['pageId'],
      formId: json['formId'],
      employmentTypeId: json['employmentTypeId'],
      department: json['department'],
      hiringStageId: json['hiringStageId'],
      status: json['status'],
      archivedAt: json['archivedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Application {
  final String id;
  final String tenantId;
  final String jobId;
  final String candidateId;
  final String jobStageId;
  final String statusId;
  final String createdAt;
  final String updatedAt;

  Application({
    required this.id,
    required this.tenantId,
    required this.jobId,
    required this.candidateId,
    required this.jobStageId,
    required this.statusId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      tenantId: json['tenantId'],
      jobId: json['jobId'],
      candidateId: json['candidateId'],
      jobStageId: json['jobStageId'],
      statusId: json['statusId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Stage {
  final String candidateStageId;
  final String jobStageId;
  final String statusId;
  final String movedAt;
  final int jobStageOrder;
  final String hiringStageName;
  final String hiringStageDescription;
  final String statusName;
  final String statusType;
  final List<Assessment> assessments;

  Stage({
    required this.candidateStageId,
    required this.jobStageId,
    required this.statusId,
    required this.movedAt,
    required this.jobStageOrder,
    required this.hiringStageName,
    required this.hiringStageDescription,
    required this.statusName,
    required this.statusType,
    required this.assessments,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      candidateStageId: json['candidateStageId'],
      jobStageId: json['jobStageId'],
      statusId: json['statusId'],
      movedAt: json['movedAt'],
      jobStageOrder: json['jobStageOrder'],
      hiringStageName: json['hiringStageName'],
      hiringStageDescription: json['hiringStageDescription'],
      statusName: json['statusName'],
      statusType: json['statusType'],
      assessments: (json['assessments'] as List)
          .map((e) => Assessment.fromJson(e))
          .toList(),
    );
  }
}

class Interview {
  final String roundName;
  final String roundDescription;
  final String interviewMode;
  final String scheduledAt;
  final String? remarks;
  final String? meetingLink;
  final String statusId;
  final String jobStageId;
  final String stageName;

  Interview({
    required this.roundName,
    required this.roundDescription,
    required this.interviewMode,
    required this.scheduledAt,
    this.remarks,
    this.meetingLink,
    required this.statusId,
    required this.jobStageId,
    required this.stageName,
  });

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      roundName: json['roundName'],
      roundDescription: json['roundDescription'],
      interviewMode: json['interviewMode'],
      scheduledAt: json['scheduledAt'],
      remarks: json['remarks'],
      meetingLink: json['meetingLink'],
      statusId: json['statusId'],
      jobStageId: json['jobStageId'],
      stageName: json['stageName'],
    );
  }
}

class Assessment {
  final String id;
  final String title;
  final String description;
  final String? taskFileId;
  final String? statusId;
  final String? remarks;
  final String? statusName;

  Assessment({
    required this.id,
    required this.title,
    required this.description,
    this.taskFileId,
    this.statusId,
    this.remarks,
    this.statusName,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      taskFileId: json['taskFileId'],
      statusId: json['statusId'],
      remarks: json['remarks'],
      statusName: json['statusName'],
    );
  }
}
