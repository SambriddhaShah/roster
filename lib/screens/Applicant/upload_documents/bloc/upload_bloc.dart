import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/model/remote_file_model.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/service/data_service.dart';
import 'upload_event.dart';
import 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final DocumentService _documentService = DocumentService();

  UploadBloc() : super(const UploadState()) {
    on<LoadInitialFiles>(_onLoadInitialFiles);
    on<FileSelected>(_onFileSelected);
    on<SubmitDocuments>(_onSubmitDocuments);
    on<RemoveFile>(_onRemoveFile);
    on<RemoveRemoteFile>(_onRemoveRemoteFile);
  }

  Future<void> _onLoadInitialFiles(
    LoadInitialFiles event,
    Emitter<UploadState> emit,
  ) async {
    try {
      final filesEvent = await _documentService.fetchUserDocuments("user_123");

      emit(state.copyWith(
        remoteCV: filesEvent.remoteCV,
        remotePhoto: filesEvent.remotePhoto,
        remoteCoverLetter: filesEvent.remoteCoverLetter,
        remoteCertificates: filesEvent.remoteCertificates,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load documents'));
    }
  }

  Future<void> _onRemoveRemoteFile(
      RemoveRemoteFile event, Emitter<UploadState> emit) async {
    try {
      await _documentService.deleteRemoteFile(event.file);

      // Re-fetch updated list of files from backend
      final updatedFiles =
          await _documentService.fetchUserDocuments("user_123");

      add(updatedFiles); // Re-dispatch to update state
    } catch (e) {
      emit(state.copyWith(
          error: "Failed to delete remote file: ${e.toString()}"));
    }
  }

  void _onFileSelected(FileSelected event, Emitter<UploadState> emit) {
    switch (event.type) {
      case "cv":
        emit(state.copyWith(cv: event.files));
        break;
      case "photo":
        emit(state.copyWith(photo: event.files));
        break;
      case "coverLetter":
        emit(state.copyWith(coverLetter: event.files));
        break;
      case "certificates":
        emit(state.copyWith(certificates: event.files));
        break;
    }
  }

  void _onRemoveFile(RemoveFile event, Emitter<UploadState> emit) {
    switch (event.type) {
      case "cv":
        emit(state.copyWith(cv: List.from(state.cv)..remove(event.file)));
        break;
      case "photo":
        emit(state.copyWith(photo: List.from(state.photo)..remove(event.file)));
        break;
      case "coverLetter":
        emit(state.copyWith(
            coverLetter: List.from(state.coverLetter)..remove(event.file)));
        break;
      case "certificates":
        emit(state.copyWith(
            certificates: List.from(state.certificates)..remove(event.file)));
        break;
    }
  }

  Future<void> _onSubmitDocuments(
      SubmitDocuments event, Emitter<UploadState> emit) async {
    emit(state.copyWith(isSubmitting: true, error: null, isSuccess: false));

    try {
      await _documentService.uploadDocuments(
        cv: state.cv,
        photo: state.photo,
        coverLetter: state.coverLetter,
        certificates: state.certificates,
      );

      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: false,
        error: "Upload failed: ${e.toString()}",
      ));
    }
  }
}


// class DocumentService {
//   Future<LoadInitialFiles> fetchUserDocuments(String userId) async {
//     final response = await http.get(Uri.parse('https://yourapi.com/user/$userId/documents'));

//     final json = jsonDecode(response.body);

//     return LoadInitialFiles(
//       remoteCV: (json['cv'] as List).map((e) => RemoteFile.fromJson(e)).toList(),
//       remotePhoto: (json['photo'] as List).map((e) => RemoteFile.fromJson(e)).toList(),
//       remoteCoverLetter: (json['coverLetter'] as List).map((e) => RemoteFile.fromJson(e)).toList(),
//       remoteCertificates: (json['certificates'] as List).map((e) => RemoteFile.fromJson(e)).toList(),
//     );
//   }}
