import 'dart:io';

import 'package:rooster_empployee/screens/Applicant/upload_documents/model/remote_file_model.dart';

class DocumentCategory {
  final String type;
  final List<RemoteFile> remoteFiles;
  final List<File> localFiles;

  DocumentCategory({
    required this.type,
    this.remoteFiles = const [],
    this.localFiles = const [],
  });

  DocumentCategory copyWith({
    List<RemoteFile>? remoteFiles,
    List<File>? localFiles,
  }) {
    return DocumentCategory(
      type: type,
      remoteFiles: remoteFiles ?? this.remoteFiles,
      localFiles: localFiles ?? this.localFiles,
    );
  }
}
