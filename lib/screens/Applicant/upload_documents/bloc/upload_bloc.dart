// upload_bloc.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_event.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/bloc/upload_state.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/model/document_draft.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/model/remote_file_model.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/service/data_service.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final DocumentService documentService;

  UploadBloc({required this.documentService}) : super(const UploadState()) {
    on<LoadInitialFiles>(_onLoadInitialFiles);
    on<AddDraft>(_onAddDraft);
    on<RemoveDraft>(_onRemoveDraft);
    on<UpdateDraftName>(_onUpdateDraftName);
    on<SelectDraftFile>(_onSelectDraftFile);
    on<SubmitOfferLetter>(_onSubmitOfferLeter);
    on<SubmitAllDocuments>(_onSubmitAllDocuments);
    on<SubmitDocuments>(_onSubmitDocuments);
    on<DeleteRemoteFile>(_onDeleteRemoteFile);
    on<ClearStatus>((event, emit) {
      emit(state.copyWith(isSuccess: false, error: null, successMessage: ""));
    });
  }

  Future<void> _onLoadInitialFiles(
    LoadInitialFiles event,
    Emitter<UploadState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final remoteFiles =
          await documentService.fetchRemoteDocuments("user_123");
      emit(state.copyWith(remoteFiles: remoteFiles, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load documents',
      ));
    }
  }

  void _onAddDraft(AddDraft event, Emitter<UploadState> emit) {
    final updatedDrafts = List<DocumentDraft>.from(state.drafts)
      ..add(const DocumentDraft(name: ""));
    emit(state.copyWith(drafts: updatedDrafts));
  }

  void _onRemoveDraft(RemoveDraft event, Emitter<UploadState> emit) {
    final updatedDrafts = List<DocumentDraft>.from(state.drafts)
      ..removeAt(event.index);
    emit(state.copyWith(drafts: updatedDrafts));
  }

  void _onUpdateDraftName(UpdateDraftName event, Emitter<UploadState> emit) {
    final updatedDrafts = List<DocumentDraft>.from(state.drafts);
    final current = updatedDrafts[event.index];
    updatedDrafts[event.index] = current.copyWith(name: event.name);
    emit(state.copyWith(drafts: updatedDrafts));
  }

  void _onSelectDraftFile(SelectDraftFile event, Emitter<UploadState> emit) {
    final updatedDrafts = List<DocumentDraft>.from(state.drafts);
    final current = updatedDrafts[event.index];
    updatedDrafts[event.index] =
        current.copyWith(file: event.file, isPhoto: event.isPhoto);
    emit(state.copyWith(drafts: updatedDrafts));
  }

  Future<void> _onSubmitDocuments(
    SubmitDocuments event,
    Emitter<UploadState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, error: null));

    try {
      final List<DocumentDraft> validDrafts =
          state.drafts.where((d) => d.isComplete).toList();

      await documentService.uploadDocumentsother(
          validDrafts, event.assessmentId);

      // Re-fetch uploaded files from server after successful upload
      // final remoteFiles =
      //     await documentService.fetchRemoteDocuments("user_123");

      emit(state.copyWith(
        drafts: [],
        // remoteFiles: remoteFiles,
        successMessage: "Documents uploaded successfully",
        isSubmitting: false,
        isSuccess: true,
      ));
    } catch (e) {
      print("error occured while uploading in the bloc");
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        error: "Upload failed",
      ));
    }
  }

  Future<void> _onSubmitOfferLeter(
    SubmitOfferLetter event,
    Emitter<UploadState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, error: null));

    try {
      final List<DocumentDraft> validDrafts =
          state.drafts.where((d) => d.isComplete).toList();

      await documentService.uploadOfferLetter(validDrafts, event.offerLetterId);

      // Re-fetch uploaded files from server after successful upload
      // final remoteFiles =
      //     await documentService.fetchRemoteDocuments("user_123");

      emit(state.copyWith(
        drafts: [],
        // remoteFiles: remoteFiles,
        successMessage: "Documents uploaded successfully",
        isSubmitting: false,
        isSuccess: true,
      ));
    } catch (e) {
      print("error occured while uploading in the bloc");
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        error: "Upload failed",
      ));
    }
  }

  Future<void> _onSubmitAllDocuments(
    SubmitAllDocuments event,
    Emitter<UploadState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, error: null));

    try {
      final List<DocumentDraft> validDrafts =
          state.drafts.where((d) => d.isComplete).toList();

      await documentService.uploadDocuments(validDrafts);

      // Re-fetch uploaded files from server after successful upload
      // final remoteFiles =
      //     await documentService.fetchRemoteDocuments("user_123");

      emit(state.copyWith(
        drafts: [],
        // remoteFiles: remoteFiles,
        successMessage: "Documents uploaded successfully",
        isSubmitting: false,
        isSuccess: true,
      ));
    } catch (e) {
      print("error occured while uploading in the bloc");
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        error: "Upload failed",
      ));
    }
  }

  Future<void> _onDeleteRemoteFile(
    DeleteRemoteFile event,
    Emitter<UploadState> emit,
  ) async {
    final newDeletingSet = Set<String>.from(state.deletingFileIds)
      ..add(event.fileId);
    emit(state.copyWith(deletingFileIds: newDeletingSet));

    try {
      await documentService.deleteRemoteFile(event.fileId);

      final updatedRemoteFiles =
          state.remoteFiles.where((f) => f.id != event.fileId).toList();

      final finalDeletingSet = Set<String>.from(state.deletingFileIds)
        ..remove(event.fileId);

      emit(state.copyWith(
        remoteFiles: updatedRemoteFiles,
        deletingFileIds: finalDeletingSet,
        isSuccess: true,
        successMessage: "File deleted successfully",
      ));
    } catch (e) {
      final finalDeletingSet = Set<String>.from(state.deletingFileIds)
        ..remove(event.fileId);
      emit(state.copyWith(
        deletingFileIds: finalDeletingSet,
        error: "Failed to delete file",
      ));
    }
  }
}
