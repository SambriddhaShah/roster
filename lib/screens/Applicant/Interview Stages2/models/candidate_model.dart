import 'package:flutter/foundation.dart';

class CandidateData {
  final CandidateDetails candidateDetails;
  final List<FormValue> formValues;
  final List<HiringStage> hiringStages;

  CandidateData({
    required this.candidateDetails,
    required this.formValues,
    required this.hiringStages,
  });

  factory CandidateData.fromJson(Map<String, dynamic> json) {
    return CandidateData(
      candidateDetails: CandidateDetails.fromJson(json['candidateDetails']),
      formValues: (json['formValues'] as List)
          .map((e) => FormValue.fromJson(e))
          .toList(),
      hiringStages: (json['hiringStages'] as List)
          .map((e) => HiringStage.fromJson(e))
          .toList(),
    );
  }
}

class CandidateDetails {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String? city;
  final String? state;
  final String? country;
  final String? zip;
  final String? resumeFileId;
  final String? coverLetterFileId;
  final String? statusId;
  final String? matchScore;
  final String? source;
  final String? referredBy;
  final String createdAt;
  final String updatedAt;

  CandidateDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    this.city,
    this.state,
    this.country,
    this.zip,
    this.resumeFileId,
    this.coverLetterFileId,
    this.statusId,
    this.matchScore,
    this.source,
    this.referredBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CandidateDetails.fromJson(Map<String, dynamic> json) {
    return CandidateDetails(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zip: json['zip'],
      resumeFileId: json['resumeFileId'],
      coverLetterFileId: json['coverLetterFileId'],
      statusId: json['statusId'],
      matchScore: json['matchScore'],
      source: json['source'],
      referredBy: json['referredBy'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class FormValue {
  final String id;
  final String formElementId;
  final String formFieldValue;

  FormValue({
    required this.id,
    required this.formElementId,
    required this.formFieldValue,
  });

  factory FormValue.fromJson(Map<String, dynamic> json) {
    return FormValue(
      id: json['id'],
      formElementId: json['formElementId'],
      formFieldValue: json['formFieldValue'],
    );
  }
}

class HiringStage {
  final String id;
  final int displayOrder;
  final String hiringStageName;
  final String statusId;
  final String statusName;

  HiringStage({
    required this.id,
    required this.displayOrder,
    required this.hiringStageName,
    required this.statusId,
    required this.statusName,
  });

  factory HiringStage.fromJson(Map<String, dynamic> json) {
    return HiringStage(
      id: json['id'],
      displayOrder: json['displayOrder'],
      hiringStageName: json['hiringStageName'],
      statusId: json['statusId'],
      statusName: json['statusName'],
    );
  }
}
