// remote_file.dart
class RemoteFile {
  final String id;
  final String name;
  final String url;

  const RemoteFile({
    required this.id,
    required this.name,
    required this.url,
  });

  factory RemoteFile.fromJson(Map<String, dynamic> json) {
    return RemoteFile(
      id: json['id'],
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
      };

  @override
  String toString() => 'RemoteFile(name: $name)';
}
