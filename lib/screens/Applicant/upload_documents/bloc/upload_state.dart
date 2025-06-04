import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/model/remote_file_model.dart';

class UploadState extends Equatable {
  final List<File> cv;
  final List<File> photo;
  final List<File> coverLetter;
  final List<File> certificates;

  final List<RemoteFile> remoteCV;
  final List<RemoteFile> remotePhoto;
  final List<RemoteFile> remoteCoverLetter;
  final List<RemoteFile> remoteCertificates;

  final bool isSubmitting;
  final bool isSuccess;
  final String? error;

  const UploadState({
    this.cv = const [],
    this.photo = const [],
    this.coverLetter = const [],
    this.certificates = const [],
    this.remoteCV = const [],
    this.remotePhoto = const [],
    this.remoteCoverLetter = const [],
    this.remoteCertificates = const [],
    this.isSubmitting = false,
    this.isSuccess = false,
    this.error,
  });

  UploadState copyWith({
    List<File>? cv,
    List<File>? photo,
    List<File>? coverLetter,
    List<File>? certificates,
    List<RemoteFile>? remoteCV,
    List<RemoteFile>? remotePhoto,
    List<RemoteFile>? remoteCoverLetter,
    List<RemoteFile>? remoteCertificates,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
  }) {
    return UploadState(
      cv: cv ?? this.cv,
      photo: photo ?? this.photo,
      coverLetter: coverLetter ?? this.coverLetter,
      certificates: certificates ?? this.certificates,
      remoteCV: remoteCV ?? this.remoteCV,
      remotePhoto: remotePhoto ?? this.remotePhoto,
      remoteCoverLetter: remoteCoverLetter ?? this.remoteCoverLetter,
      remoteCertificates: remoteCertificates ?? this.remoteCertificates,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }

  bool get isAllValid =>
      cv.isNotEmpty &&
      photo.isNotEmpty &&
      coverLetter.isNotEmpty &&
      certificates.isNotEmpty;

  @override
  List<Object?> get props => [
        cv,
        photo,
        coverLetter,
        certificates,
        remoteCV,
        remotePhoto,
        remoteCoverLetter,
        remoteCertificates,
        isSubmitting,
        isSuccess,
        error,
      ];
}
