class ApiResponse {
  final User user;
  final Job job;

  final List<InterviewStage> interviewStages;

  ApiResponse(
      {required this.user, required this.interviewStages, required this.job});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      user: User.fromJson(json['user']),
      job: Job.fromJson(json['job']),
      interviewStages: (json['interviewStages'] as List)
          .map((e) => InterviewStage.fromJson(e))
          .toList(),
    );
  }
}

class User {
  final String name;
  final String email;
  final String address;
  final String phone;
  final String profileImage;

  User({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      profileImage: json['profileImage'],
    );
  }
}

class Job {
  final String title;
  final String company;
  final String location;
  final String experienceRequired;
  final String employmentType;
  final List<String> descriptionBullets;
  final List<String> skills;

  Job({
    required this.title,
    required this.company,
    required this.location,
    required this.experienceRequired,
    required this.employmentType,
    required this.descriptionBullets,
    required this.skills,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      title: json['title'],
      company: json['company'],
      location: json['location'],
      experienceRequired: json['experienceRequired'],
      employmentType: json['employmentType'],
      descriptionBullets: List<String>.from(json['descriptionBullets'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
    );
  }
}

class InterviewStage {
  final String stageName;
  final String status;
  final String? interviewer;
  final String? taskDone;
  final String? comments;
  final String? failureReason;
  final String? deactivationMessage;
  final String? description;
  final String? type;
  final String? meetingLink;

  InterviewStage({
    required this.stageName,
    required this.status,
    this.interviewer,
    this.taskDone,
    this.comments,
    this.failureReason,
    this.deactivationMessage,
    this.description,
    this.type,
    this.meetingLink,
  });

  factory InterviewStage.fromJson(Map<String, dynamic> json) {
    return InterviewStage(
      stageName: json['stageName'],
      status: json['status'],
      interviewer: json['interviewer'],
      taskDone: json['taskDone'],
      comments: json['comments'],
      failureReason: json['failureReason'],
      deactivationMessage: json['deactivationMessage'],
      description: json['description'],
      type: json['type'],
      meetingLink: json['meetingLink'],
    );
  }
}
