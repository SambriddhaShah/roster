// upload_state.dart
import 'package:equatable/equatable.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/model/document_draft.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/model/remote_file_model.dart';

class UploadState extends Equatable {
  final List<RemoteFile> remoteFiles;
  final List<DocumentDraft> drafts;
  final Set<String> deletingFileIds;
  final bool isSubmitting;
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final String? successMessage;

  const UploadState({
    this.remoteFiles = const [],
    this.drafts = const [],
    this.deletingFileIds = const {},
    this.isSubmitting = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.successMessage,
  });

  UploadState copyWith({
    List<RemoteFile>? remoteFiles,
    List<DocumentDraft>? drafts,
    Set<String>? deletingFileIds,
    bool? isSubmitting,
    bool? isLoading,
    bool? isSuccess,
    String? error,
    String? successMessage,
  }) {
    return UploadState(
      remoteFiles: remoteFiles ?? this.remoteFiles,
      drafts: drafts ?? this.drafts,
      deletingFileIds: deletingFileIds ?? this.deletingFileIds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  bool get canSubmit => drafts.isNotEmpty && drafts.every((d) => d.isComplete);

  @override
  List<Object?> get props => [
        remoteFiles,
        drafts,
        deletingFileIds,
        isSubmitting,
        isLoading,
        isSuccess,
        error,
        successMessage,
      ];
}
