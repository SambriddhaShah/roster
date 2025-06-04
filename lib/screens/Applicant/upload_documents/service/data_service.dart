import 'dart:async';
import 'dart:io';
import 'package:rooster_empployee/screens/Applicant/upload_documents/model/remote_file_model.dart';

import '../bloc/upload_event.dart';

class DocumentService {
  Future<LoadInitialFiles> fetchUserDocuments(String userId) async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 1));

    // 🧪 MOCK DATA (easily replace this with real API call later)
    final mockJson = {
      "cv": [
        // {
        //   "id": "1",
        //   "name": "Resume.pdf",
        //   "url": "https://example.com/resume.pdf"
        // }
      ],
      "coverLetter": [
        // {
        //   "id": "2",
        //   "name": "CoverLetter.pdf",
        //   "url": "https://example.com/coverletter.pdf"
        // }
      ],
      "photo": [
        // {
        //   "id": "3",
        //   "name": "Profile.jpg",
        //   "url": "https://via.placeholder.com/150"
        // }
      ],
      "certificates": [
        // {
        //   "id": "4",
        //   "name": "Cert1.pdf",
        //   "url": "https://example.com/cert1.pdf"
        // },
        // {"id": "5", "name": "Cert2.pdf", "url": "https://example.com/cert2.pdf"}
      ],
      "Transcript": []
    };

    return LoadInitialFiles(
      remoteCV:
          (mockJson['cv'] as List).map((e) => RemoteFile.fromJson(e)).toList(),
      remoteCoverLetter: (mockJson['coverLetter'] as List)
          .map((e) => RemoteFile.fromJson(e))
          .toList(),
      remotePhoto: (mockJson['photo'] as List)
          .map((e) => RemoteFile.fromJson(e))
          .toList(),
      remoteCertificates: (mockJson['certificates'] as List)
          .map((e) => RemoteFile.fromJson(e))
          .toList(),
    );
  }

  Future<void> uploadDocuments({
    required List<File> cv,
    required List<File> photo,
    required List<File> coverLetter,
    required List<File> certificates,
  }) async {
    // Simulate uploading
    await Future.delayed(const Duration(seconds: 2));

    // 🔁 Replace this later with real API call using http or dio:
    // final request = http.MultipartRequest('POST', Uri.parse('https://api.com/upload'));
    // request.files.add(await http.MultipartFile.fromPath('cv', cv.first.path));
    // ...
    // final response = await request.send();
    // if (response.statusCode != 200) throw Exception("Upload failed");
  }

  Future<void> deleteRemoteFile(RemoteFile file) async {
    // Simulate API delete call
    await Future.delayed(const Duration(milliseconds: 300));

    // In future: actual API DELETE call
    // final response = await http.delete(Uri.parse("https://api.com/documents/${file.id}"));
    // if (response.statusCode != 200) throw Exception("Failed to delete");
  }
}
