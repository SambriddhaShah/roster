// class CandidateResponse {
//   final bool success;
//   final String message;
//   final CandidateData data;

//   CandidateResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory CandidateResponse.fromJson(Map<String, dynamic> json) {
//     return CandidateResponse(
//       success: json['success'],
//       message: json['message'],
//       data: CandidateData.fromJson(json['data']),
//     );
//   }
// }

// class CandidateData {
//   final Candidate candidate;
//   final List<JobApplication> jobs;

//   CandidateData({
//     required this.candidate,
//     required this.jobs,
//   });

//   factory CandidateData.fromJson(Map<String, dynamic> json) {
//     return CandidateData(
//       candidate: Candidate.fromJson(json['candidate']),
//       jobs: (json['jobs'] as List)
//           .map((e) => JobApplication.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class Candidate {
//   final String id;
//   final String tenantId;
//   final String jobId;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String phone;
//   final String address;
//   final String? city;
//   final String? state;
//   final String? country;
//   final String? zip;
//   final String? statusId;
//   final String? matchScore;
//   final String? source;
//   final String? referredBy;
//   final String? resumeFileId;
//   final String? coverLetterFileId;
//   final String createdAt;
//   final String updatedAt;

//   Candidate({
//     required this.id,
//     required this.tenantId,
//     required this.jobId,
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.phone,
//     required this.address,
//     this.city,
//     this.state,
//     this.country,
//     this.zip,
//     this.statusId,
//     this.matchScore,
//     this.source,
//     this.referredBy,
//     this.resumeFileId,
//     this.coverLetterFileId,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Candidate.fromJson(Map<String, dynamic> json) {
//     return Candidate(
//       id: json['id'],
//       tenantId: json['tenantId'],
//       jobId: json['jobId'],
//       firstName: json['firstName'],
//       lastName: json['lastName'],
//       email: json['email'],
//       phone: json['phone'],
//       address: json['address'],
//       city: json['city'],
//       state: json['state'],
//       country: json['country'],
//       zip: json['zip'],
//       statusId: json['statusId'],
//       matchScore: json['matchScore'],
//       source: json['source'],
//       referredBy: json['referredBy'],
//       resumeFileId: json['resumeFileId'],
//       coverLetterFileId: json['coverLetterFileId'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//     );
//   }
// }

// class JobApplication {
//   final Job job;
//   final Application application;
//   final List<Stage> stages;
//   final List<Interview> interviews;

//   JobApplication({
//     required this.interviews,
//     required this.job,
//     required this.application,
//     required this.stages,
//   });

//   factory JobApplication.fromJson(Map<String, dynamic> json) {
//     return JobApplication(
//       job: Job.fromJson(json['job']),
//       application: Application.fromJson(json['application']),
//       stages: (json['stages'] as List).map((e) => Stage.fromJson(e)).toList(),
//       interviews: (json['interviews'] as List?)
//               ?.map((e) => Interview.fromJson(e))
//               .toList() ??
//           [],
//     );
//   }
// }

// class Job {
//   final String? id;
//   final String? tenantId;
//   final String? title;
//   final String? description;
//   final String? pageId;
//   final String? formId;
//   final String? employmentTypeId;
//   final String? department;
//   final String? hiringStageId;
//   final String? status;
//   final String? archivedAt;
//   final String createdBy;
//   final String? updatedBy;
//   final String? createdAt;
//   final String? updatedAt;

//   Job({
//     required this.id,
//     required this.tenantId,
//     required this.title,
//     required this.description,
//     required this.pageId,
//     required this.formId,
//     this.employmentTypeId,
//     this.department,
//     this.hiringStageId,
//     this.status,
//     this.archivedAt,
//     required this.createdBy,
//     this.updatedBy,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       id: json['id'],
//       tenantId: json['tenantId'],
//       title: json['title'],
//       description: json['description'],
//       pageId: json['pageId'],
//       formId: json['formId'],
//       employmentTypeId: json['employmentTypeId'],
//       department: json['department'],
//       hiringStageId: json['hiringStageId'],
//       status: json['status'],
//       archivedAt: json['archivedAt'],
//       createdBy: json['createdBy'],
//       updatedBy: json['updatedBy'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//     );
//   }
// }

// class Application {
//   final String? id;
//   final String? tenantId;
//   final String? jobId;
//   final String? candidateId;
//   final String? jobStageId;
//   final String? statusId;
//   final String? createdAt;
//   final String? updatedAt;

//   Application({
//     required this.id,
//     required this.tenantId,
//     required this.jobId,
//     required this.candidateId,
//     required this.jobStageId,
//     required this.statusId,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Application.fromJson(Map<String, dynamic> json) {
//     return Application(
//       id: json['id'],
//       tenantId: json['tenantId'],
//       jobId: json['jobId'],
//       candidateId: json['candidateId'],
//       jobStageId: json['jobStageId'],
//       statusId: json['statusId'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//     );
//   }
// }

// class Stage {
//   final String? candidateStageId;
//   final String? jobStageId;
//   final String? statusId;
//   final String? movedAt;
//   final int? jobStageOrder;
//   final String? hiringStageName;
//   final String? hiringStageDescription;
//   final String? statusName;
//   final String? statusType;
//   final List<Assessment> assessments;
//   final List<Interview> interviews;
//   final AcceptedLetter? acceptedLetter;

//   final OfferLetter? offerLetter;
//   Stage(
//       {required this.candidateStageId,
//       required this.jobStageId,
//       required this.statusId,
//       required this.movedAt,
//       required this.jobStageOrder,
//       required this.hiringStageName,
//       required this.hiringStageDescription,
//       required this.statusName,
//       required this.statusType,
//       required this.assessments,
//       required this.interviews,
//       this.offerLetter,
//       this.acceptedLetter});

//   factory Stage.fromJson(Map<String, dynamic> json) {
//     return Stage(
//       candidateStageId: json['candidateStageId'],
//       jobStageId: json['jobStageId'],
//       statusId: json['statusId'],
//       movedAt: json['movedAt'],
//       jobStageOrder: json['jobStageOrder'],
//       hiringStageName: json['hiringStageName'],
//       hiringStageDescription: json['hiringStageDescription'],
//       statusName: json['statusName'],
//       statusType: json['statusType'],
//       assessments: (json['assessments'] as List)
//           .map((e) => Assessment.fromJson(e))
//           .toList(),
//       offerLetter: json['offerLetter'] != null
//           ? OfferLetter.fromJson(json['offerLetter'])
//           : null,
//       interviews: (json['interviews'] as List?)
//               ?.map((e) => Interview.fromJson(e))
//               .toList() ??
//           [],
//       acceptedLetter: json['acceptedLetter'] != null
//           ? AcceptedLetter.fromJson(json['acceptedLetter'])
//           : null,
//     );
//   }
// }

// class Interview {
//   final String? roundName;
//   final String? roundDescription;
//   final String? interviewMode;
//   final String? scheduledAt;
//   final String? remarks;
//   final String? meetingLink;
//   final String? statusId;
//   final String? jobStageId;
//   final String? stageName;

//   Interview({
//     required this.roundName,
//     required this.roundDescription,
//     required this.interviewMode,
//     required this.scheduledAt,
//     this.remarks,
//     this.meetingLink,
//     required this.statusId,
//     required this.jobStageId,
//     required this.stageName,
//   });

//   factory Interview.fromJson(Map<String, dynamic> json) {
//     return Interview(
//       roundName: json['roundName'],
//       roundDescription: json['roundDescription'],
//       interviewMode: json['interviewMode'],
//       scheduledAt: json['scheduledAt'],
//       remarks: json['remarks'],
//       meetingLink: json['meetingLink'],
//       statusId: json['statusId'],
//       jobStageId: json['jobStageId'],
//       stageName: json['stageName'],
//     );
//   }
// }

// class Assessment {
//   final String? id;
//   final String? title;
//   final String? description;
//   final String? taskFileId;
//   final String? statusId;
//   final String? remarks;
//   final String? statusName;
//   final TaskFile? taskFile;
//   final SubmittedFile? submittedFile;

//   Assessment({
//     required this.id,
//     required this.title,
//     required this.description,
//     this.taskFileId,
//     this.statusId,
//     this.remarks,
//     this.statusName,
//     this.taskFile,
//     this.submittedFile,
//   });

//   factory Assessment.fromJson(Map<String, dynamic> json) {
//     return Assessment(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       taskFileId: json['taskFileId'],
//       statusId: json['statusId'],
//       remarks: json['remarks'],
//       statusName: json['statusName'],
//       taskFile:
//           json['taskFile'] != null ? TaskFile.fromJson(json['taskFile']) : null,
//       submittedFile: json['submittedFile'] != null
//           ? SubmittedFile.fromJson(json['submittedFile'])
//           : null,
//     );
//   }
// }

// class TaskFile {
//   final String? id;
//   final String? name;
//   final String? path;
//   final int? size;
//   final String? mimeType;

//   TaskFile({
//     required this.id,
//     required this.name,
//     required this.path,
//     required this.size,
//     required this.mimeType,
//   });

//   factory TaskFile.fromJson(Map<String, dynamic> json) {
//     return TaskFile(
//       id: json['id'],
//       name: json['name'],
//       path: json['path'],
//       size: json['size'],
//       mimeType: json['mimeType'],
//     );
//   }
// }

// class SubmittedFile {
//   final String? id;
//   final String? name;
//   final String? path;
//   final int? size;
//   final String? mimeType;

//   SubmittedFile({
//     required this.id,
//     required this.name,
//     required this.path,
//     required this.size,
//     required this.mimeType,
//   });

//   factory SubmittedFile.fromJson(Map<String, dynamic> json) {
//     return SubmittedFile(
//       id: json['id'],
//       name: json['name'],
//       path: json['path'],
//       size: json['size'],
//       mimeType: json['mimeType'],
//     );
//   }
// }

// class OfferLetter {
//   final String? id;
//   final String? title;
//   final String? offerLetterFileId;
//   final String? offerLetterFilePath;
//   final String? offerLetterFileName;
//   final String? acceptedLetter;

//   OfferLetter(
//       {required this.id,
//       required this.title,
//       this.offerLetterFileId,
//       this.offerLetterFilePath,
//       this.offerLetterFileName,
//       this.acceptedLetter});

//   factory OfferLetter.fromJson(Map<String, dynamic> json) {
//     return OfferLetter(
//       id: json['id'],
//       title: json['title'],
//       offerLetterFileId: json['offerLetterFileId'],
//       offerLetterFilePath: json['offerLetterFilePath'],
//       offerLetterFileName: json['offerLetterFileName'],
//       acceptedLetter: json['acceptedLetter'],
//     );
//   }
// }

// class AcceptedLetter {
//   final String? id;
//   final String? acceptedLetterFilePath;
//   final String? acceptedLetterFileName;

//   AcceptedLetter({
//     required this.id,
//     required this.acceptedLetterFilePath,
//     required this.acceptedLetterFileName,
//   });

//   factory AcceptedLetter.fromJson(Map<String, dynamic> json) {
//     return AcceptedLetter(
//       id: json['id'],
//       acceptedLetterFilePath: json['acceptedLetterFilePath'],
//       acceptedLetterFileName: json['acceptedLetterFileName'],
//     );
//   }
// }

// //  {id: f9fc1aa5-060a-426a-974e-e282f9545556, title: Offer Letter, offerLetterFileId: 17e13d18-8f67-4ebc-96a9-9bf1737fdf1c, offerLetterFilePath: /uploads/cfd291c3-cf2e-49ee-b480-d4d66eefd241/documents/1754561375357-c3e22729-00d6-4f14-8345-6111510102a4-sample_local_pdf.pdf, offerLetterFileName: sample-local-pdf.pdf}

// candidate_response_models.dart
// Safe/defensive models for the payload you shared.
// - JobApplication.job is nullable
// - Stage.offerLetters is a list and supports both nested and flattened file shapes
// - Interview supports startTime/endTime AND scheduledAt
// - All list fields are parsed defensively (null -> empty list)

T? _asMap<T>(dynamic v) => v is T ? v : null;

List<T> _parseList<T>(
  dynamic value,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (value is List) {
    return value
        .where((e) => e is Map<String, dynamic>)
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }
  return <T>[];
}

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
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: CandidateData.fromJson(
          _asMap<Map<String, dynamic>>(json['data']) ?? const {}),
    );
  }
}

class CandidateData {
  final Candidate candidate;
  final List<JobApplication> jobs;
  final List<Reference> references; // present in your payload as []

  CandidateData({
    required this.candidate,
    required this.jobs,
    required this.references,
  });

  factory CandidateData.fromJson(Map<String, dynamic> json) {
    return CandidateData(
      candidate: Candidate.fromJson(
          _asMap<Map<String, dynamic>>(json['candidate']) ?? const {}),
      jobs: _parseList(json['jobs'], (e) => JobApplication.fromJson(e)),
      references: _parseList(json['references'], (e) => Reference.fromJson(e)),
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
      id: json['id']?.toString() ?? '',
      tenantId: json['tenantId']?.toString() ?? '',
      jobId: json['jobId']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString(),
      zip: json['zip']?.toString(),
      statusId: json['statusId']?.toString(),
      matchScore: json['matchScore']?.toString(),
      source: json['source']?.toString(),
      referredBy: json['referredBy']?.toString(),
      resumeFileId: json['resumeFileId']?.toString(),
      coverLetterFileId: json['coverLetterFileId']?.toString(),
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}

class JobApplication {
  final Job? job; // nullable
  final Application application;
  final List<Stage> stages;
  final List<Interview> interviews; // keep for forward compatibility

  JobApplication({
    required this.job,
    required this.application,
    required this.stages,
    required this.interviews,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      job: json['job'] is Map<String, dynamic>
          ? Job.fromJson(json['job'])
          : null,
      application: Application.fromJson(
          _asMap<Map<String, dynamic>>(json['application']) ?? const {}),
      stages: _parseList(json['stages'], (e) => Stage.fromJson(e)),
      interviews: _parseList(json['interviews'], (e) => Interview.fromJson(e)),
    );
  }
}

class Job {
  // Make everything nullable to be resilient to partial job payloads
  final String? id;
  final String? tenantId;
  final String? title;
  final String? description;
  final String? pageId;
  final String? formId;
  final String? employmentTypeId;
  final String? department;
  final String? hiringStageId;
  final String? status;
  final String? archivedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? createdAt;
  final String? updatedAt;

  Job({
    this.id,
    this.tenantId,
    this.title,
    this.description,
    this.pageId,
    this.formId,
    this.employmentTypeId,
    this.department,
    this.hiringStageId,
    this.status,
    this.archivedAt,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id']?.toString(),
      tenantId: json['tenantId']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      pageId: json['pageId']?.toString(),
      formId: json['formId']?.toString(),
      employmentTypeId: json['employmentTypeId']?.toString(),
      department: json['department']?.toString(),
      hiringStageId: json['hiringStageId']?.toString(),
      status: json['status']?.toString(),
      archivedAt: json['archivedAt']?.toString(),
      createdBy: json['createdBy']?.toString(),
      updatedBy: json['updatedBy']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

class Application {
  final String? id;
  final String? tenantId;
  final String? jobId;
  final String? candidateId;
  final String? jobStageId;
  final String? statusId;
  final String? createdAt;
  final String? updatedAt;

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
      id: json['id']?.toString(),
      tenantId: json['tenantId']?.toString(),
      jobId: json['jobId']?.toString(),
      candidateId: json['candidateId']?.toString(),
      jobStageId: json['jobStageId']?.toString(),
      statusId: json['statusId']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}

class Stage {
  final String? candidateStageId;
  final String? jobStageId;
  final String? statusId;
  final String? movedAt;
  final int? jobStageOrder;
  final String? hiringStageName;
  final String? hiringStageDescription;
  final String? statusName;
  final String? statusType;

  final List<Assessment> assessments;
  final List<Interview> interviews;

  // The API sends `offerLetter` as an array; we parse to a list here.
  final List<OfferLetter> offerLetters;

  // Optional, if your API ever provides a separate acceptedLetter object on the stage
  final AcceptedLetter? acceptedLetter;

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
    required this.interviews,
    required this.offerLetters,
    this.acceptedLetter,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      candidateStageId: json['candidateStageId']?.toString(),
      jobStageId: json['jobStageId']?.toString(),
      statusId: json['statusId']?.toString(),
      movedAt: json['movedAt']?.toString(),
      jobStageOrder: json['jobStageOrder'] is int
          ? json['jobStageOrder'] as int
          : int.tryParse('${json['jobStageOrder']}'),
      hiringStageName: json['hiringStageName']?.toString(),
      hiringStageDescription: json['hiringStageDescription']?.toString(),
      statusName: json['statusName']?.toString(),
      statusType: json['statusType']?.toString(),
      assessments:
          _parseList(json['assessments'], (e) => Assessment.fromJson(e)),
      interviews: _parseList(json['interviews'], (e) => Interview.fromJson(e)),
      // Supports: offerLetter: [] or offerLetter: [{...}]
      offerLetters:
          _parseList(json['offerLetter'], (e) => OfferLetter.fromJson(e)),
      acceptedLetter: json['acceptedLetter'] is Map<String, dynamic>
          ? AcceptedLetter.fromJson(json['acceptedLetter'])
          : null,
    );
  }
}

class Interview {
  final String? roundName;
  final String? roundDescription;
  final String? interviewMode;

  // API may use startTime/endTime, but we keep scheduledAt too
  final String? startTime;
  final String? endTime;
  final String? scheduledAt;

  final String? remarks;
  final String? meetingLink;
  final String? statusId;
  final String? jobStageId;
  final String? stageName;

  Interview({
    required this.roundName,
    required this.roundDescription,
    required this.interviewMode,
    this.startTime,
    this.endTime,
    this.scheduledAt,
    this.remarks,
    this.meetingLink,
    this.statusId,
    this.jobStageId,
    this.stageName,
  });

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      roundName: json['roundName']?.toString(),
      roundDescription: json['roundDescription']?.toString(),
      interviewMode: json['interviewMode']?.toString(),
      startTime: json['startTime']?.toString(),
      endTime: json['endTime']?.toString(),
      scheduledAt: json['scheduledAt']?.toString(),
      remarks: json['remarks']?.toString(),
      meetingLink: json['meetingLink']?.toString(),
      statusId: json['statusId']?.toString(),
      jobStageId: json['jobStageId']?.toString(),
      stageName: json['stageName']?.toString(),
    );
  }
}

class Assessment {
  final String? id;
  final String? title;
  final String? description;
  final String? taskFileId;
  final String? statusId;
  final String? remarks;
  final String? statusName;
  final TaskFile? taskFile;
  final SubmittedFile? submittedFile;

  Assessment({
    required this.id,
    required this.title,
    required this.description,
    this.taskFileId,
    this.statusId,
    this.remarks,
    this.statusName,
    this.taskFile,
    this.submittedFile,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      taskFileId: json['taskFileId']?.toString(),
      statusId: json['statusId']?.toString(),
      remarks: json['remarks']?.toString(),
      statusName: json['statusName']?.toString(),
      taskFile: json['taskFile'] is Map<String, dynamic>
          ? TaskFile.fromJson(json['taskFile'])
          : null,
      submittedFile: json['submittedFile'] is Map<String, dynamic>
          ? SubmittedFile.fromJson(json['submittedFile'])
          : null,
    );
  }
}

class TaskFile {
  final String? id;
  final String? name;
  final String? path;
  final int? size;
  final String? mimeType;

  TaskFile({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.mimeType,
  });

  factory TaskFile.fromJson(Map<String, dynamic> json) {
    return TaskFile(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      path: json['path']?.toString(),
      size: json['size'] is int
          ? json['size'] as int
          : int.tryParse('${json['size']}'),
      mimeType: json['mimeType']?.toString(),
    );
  }
}

class SubmittedFile {
  final String? id;
  final String? name;
  final String? path;
  final int? size;
  final String? mimeType;

  SubmittedFile({
    required this.id,
    required this.name,
    required this.path,
    required this.size,
    required this.mimeType,
  });

  factory SubmittedFile.fromJson(Map<String, dynamic> json) {
    return SubmittedFile(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      path: json['path']?.toString(),
      size: json['size'] is int
          ? json['size'] as int
          : int.tryParse('${json['size']}'),
      mimeType: json['mimeType']?.toString(),
    );
  }
}

// Matches the array items inside stage.offerLetter[]
class OfferLetter {
  final String? id;
  final String? title;

  // Nested file objects
  final OfferLetterFile? offerLetterFile;
  final AcceptedLetterFile? acceptedLetterFile;

  // Also present in your "flattened" example object keys:
  // offerLetterFileId / offerLetterFilePath / offerLetterFileName
  final String? acceptedLetter; // optional catch-all if API includes it

  OfferLetter({
    required this.id,
    required this.title,
    this.offerLetterFile,
    this.acceptedLetterFile,
    this.acceptedLetter,
  });

  factory OfferLetter.fromJson(Map<String, dynamic> json) {
    final nestedOffer = _asMap<Map<String, dynamic>>(json['offerLetterFile']);
    final nestedAccepted =
        _asMap<Map<String, dynamic>>(json['acceptedLetterFile']);

    final bool hasFlattened = json.containsKey('offerLetterFileId') ||
        json.containsKey('offerLetterFilePath') ||
        json.containsKey('offerLetterFileName');

    return OfferLetter(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      offerLetterFile: nestedOffer != null
          ? OfferLetterFile.fromJson(nestedOffer)
          : (hasFlattened
              ? OfferLetterFile(
                  id: json['offerLetterFileId']?.toString(),
                  name: json['offerLetterFileName']?.toString(),
                  path: json['offerLetterFilePath']?.toString(),
                  size: null,
                  mimeType: null,
                )
              : null),
      acceptedLetterFile: nestedAccepted != null
          ? AcceptedLetterFile.fromJson(nestedAccepted)
          : null,
      acceptedLetter: json['acceptedLetter']?.toString(),
    );
  }
}

class OfferLetterFile {
  final String? id;
  final String? name;
  final String? path;
  final int? size;
  final String? mimeType;

  OfferLetterFile({
    this.id,
    this.name,
    this.path,
    this.size,
    this.mimeType,
  });

  factory OfferLetterFile.fromJson(Map<String, dynamic> json) {
    return OfferLetterFile(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      path: json['path']?.toString(),
      size:
          json['size'] is int ? json['size'] : int.tryParse('${json['size']}'),
      mimeType: json['mimeType']?.toString(),
    );
  }
}

class AcceptedLetterFile {
  final String? id;
  final String? name;
  final String? path;
  final int? size;
  final String? mimeType;

  AcceptedLetterFile({
    this.id,
    this.name,
    this.path,
    this.size,
    this.mimeType,
  });

  factory AcceptedLetterFile.fromJson(Map<String, dynamic> json) {
    return AcceptedLetterFile(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      path: json['path']?.toString(),
      size:
          json['size'] is int ? json['size'] : int.tryParse('${json['size']}'),
      mimeType: json['mimeType']?.toString(),
    );
  }
}

class AcceptedLetter {
  final String? id;
  final String? acceptedLetterFilePath;
  final String? acceptedLetterFileName;

  AcceptedLetter({
    required this.id,
    required this.acceptedLetterFilePath,
    required this.acceptedLetterFileName,
  });

  factory AcceptedLetter.fromJson(Map<String, dynamic> json) {
    return AcceptedLetter(
      id: json['id']?.toString(),
      acceptedLetterFilePath: json['acceptedLetterFilePath']?.toString(),
      acceptedLetterFileName: json['acceptedLetterFileName']?.toString(),
    );
  }
}

// Placeholder, since your payload had "references": [].
// Define/extend this if your API later returns real data here.
class Reference {
  final String? id;
  Reference({this.id});
  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(id: json['id']?.toString());
  }
}
