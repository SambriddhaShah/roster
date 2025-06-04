import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/model/remote_file_model.dart';

abstract class UploadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadInitialFiles extends UploadEvent {
  final List<RemoteFile> remoteCV;
  final List<RemoteFile> remotePhoto;
  final List<RemoteFile> remoteCoverLetter;
  final List<RemoteFile> remoteCertificates;

  LoadInitialFiles({
    this.remoteCV = const [],
    this.remotePhoto = const [],
    this.remoteCoverLetter = const [],
    this.remoteCertificates = const [],
  });

  @override
  List<Object?> get props =>
      [remoteCV, remotePhoto, remoteCoverLetter, remoteCertificates];
}

class FileSelected extends UploadEvent {
  final String type;
  final List<File> files;

  FileSelected(this.type, this.files);

  @override
  List<Object?> get props => [type, files];
}

class RemoveRemoteFile extends UploadEvent {
  final String type;
  final RemoteFile file;

  RemoveRemoteFile(this.type, this.file);

  @override
  List<Object?> get props => [type, file];
}

class RemoveFile extends UploadEvent {
  final String type;
  final File file;

  RemoveFile(this.type, this.file);

  @override
  List<Object?> get props => [type, file];
}

class SubmitDocuments extends UploadEvent {}
