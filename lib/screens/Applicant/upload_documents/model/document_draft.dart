// document_draft.dart
import 'dart:io';

class DocumentDraft {
  final String name;
  final File? file;
  final bool isPhoto;

  const DocumentDraft({
    required this.name,
    this.file,
    this.isPhoto = false,
  });

  DocumentDraft copyWith({
    String? name,
    File? file,
    bool? isPhoto,
  }) {
    return DocumentDraft(
      name: name ?? this.name,
      file: file ?? this.file,
      isPhoto: isPhoto ?? this.isPhoto,
    );
  }

  bool get isComplete => name.isNotEmpty && file != null;
}
