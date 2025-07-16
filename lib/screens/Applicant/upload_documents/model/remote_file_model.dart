class RemoteFile {
  final String id; // Use path or hash as fallback
  final String name;
  final String path;
  final String type;

  RemoteFile({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
  });

  factory RemoteFile.fromJson(Map<String, dynamic> json) {
    final path = json['documentPath'] ?? '';
    return RemoteFile(
      id: path.hashCode.toString(), // if no real ID, use hash of path
      name: json['documentName'] ?? 'Unnamed File',
      path: path,
      type: json['docstype'] ?? 'Document',
    );
  }
}
