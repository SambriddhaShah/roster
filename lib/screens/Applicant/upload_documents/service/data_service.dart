// document_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/model/document_draft.dart';
import 'package:rooster_empployee/screens/Applicant/upload_documents/model/remote_file_model.dart';
import 'package:rooster_empployee/service/apiService.dart';
import 'package:rooster_empployee/service/apiUrls.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';

class DocumentService {
  final ApiService apiService;

  DocumentService({required this.apiService});

  /// Fetch already uploaded documents
  Future<List<RemoteFile>> fetchRemoteDocuments(String userId) async {
    final candidateId = await FlutterSecureData.getCandidateId() ?? "";

    try {
      final response = await apiService.dio.get(
        ApiUrl.getDocuments + candidateId,
      );

      debugPrint(
        'Response from fetchRemoteDocuments: ${response.data}',
        wrapWidth: 1024,
      );

      final data = response.data['data'] as List<dynamic>;

      return data
          .map((json) => RemoteFile.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadDocuments(List<DocumentDraft> drafts) async {
    try {
      for (final draft in drafts) {
        // 1. Upload the actual file
        final file = await MultipartFile.fromFile(
          draft.file!.path,
          filename: draft.file!.path.split('/').last,
        );

        final formData = FormData.fromMap({
          'file': file,
        });

        final uploadResponse = await apiService.dio.post(
          ApiUrl.uploadFile,
          data: formData,
          options: Options(
              contentType: 'multipart/form-data',
              sendTimeout: Duration(minutes: 1)),
        );
        debugPrint('the upload respose is $uploadResponse', wrapWidth: 1024);

        final filePath = uploadResponse.data['filePath'];
        final fileId = filePath['id'];

        if (fileId == null) {
          throw Exception("File upload did not return an ID.");
        }
        final candidateId = await FlutterSecureData.getCandidateId();
        final jobId = await FlutterSecureData.getCandidateJobId();

        // 2. Send file metadata (filename from user input)
        final metadataResponse = await apiService.dio.post(
          ApiUrl.documentUpload,
          data: {
            "candidateId": candidateId,
            "document": fileId,
            "documentType": draft.name,
            "jobId": jobId
          },
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        );

        if (metadataResponse.statusCode != 200 &&
            metadataResponse.statusCode != 201) {
          throw Exception(
              "Metadata registration failed for file: ${draft.name}");
        }
      }
    } catch (e) {
      print("Error uploading documents: $e");
      rethrow;
    }
  }

  /// Delete a specific remote file by its ID
  Future<void> deleteRemoteFile(String fileId) async {
    try {
      await apiService.dio.delete(
        'https://api.example.com/documents/$fileId', // Replace with real
      );
    } catch (e) {
      rethrow;
    }
  }
}
