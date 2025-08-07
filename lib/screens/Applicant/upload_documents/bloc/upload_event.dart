// upload_event.dart
import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch remote files from API when screen is opened
class LoadInitialFiles extends UploadEvent {}

/// Add a new empty draft (with empty name and no file)
class AddDraft extends UploadEvent {}

/// Remove a draft by index (before submission)
class RemoveDraft extends UploadEvent {
  final int index;

  const RemoveDraft(this.index);

  @override
  List<Object?> get props => [index];
}

/// Update the name (title) of a draft document
class UpdateDraftName extends UploadEvent {
  final int index;
  final String name;

  const UpdateDraftName({
    required this.index,
    required this.name,
  });

  @override
  List<Object?> get props => [index, name];
}

/// Attach a file or photo to the draft at given index
class SelectDraftFile extends UploadEvent {
  final int index;
  final File file;
  final bool isPhoto;

  const SelectDraftFile({
    required this.index,
    required this.file,
    required this.isPhoto,
  });

  @override
  List<Object?> get props => [index, file, isPhoto];
}

/// Submit all complete drafts to the server
class SubmitAllDocuments extends UploadEvent {}

class SubmitDocuments extends UploadEvent {
  final String assessmentId;

  const SubmitDocuments({required this.assessmentId});

  @override
  List<Object?> get props => [assessmentId];
}

//submit offer letter

class SubmitOfferLetter extends UploadEvent {
  final String offerLetterId;

  const SubmitOfferLetter({required this.offerLetterId});

  @override
  List<Object?> get props => [offerLetterId];
}

/// Delete a previously uploaded remote file (from API)
class DeleteRemoteFile extends UploadEvent {
  final String fileId;

  const DeleteRemoteFile(this.fileId);

  @override
  List<Object?> get props => [fileId];
}

class ClearStatus extends UploadEvent {}
