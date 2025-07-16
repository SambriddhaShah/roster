import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages2/models/candidate_model.dart';

class CandidateRepository {
  Future<CandidateData> fetchCandidate() async {
    try {
      // Simulate API delay
      await Future.delayed(Duration(seconds: 1));

      // Load static JSON from assets
      final jsonString = await rootBundle.loadString('assets/candidate.json');
      final jsonMap = json.decode(jsonString);

      // Deserialize the data section
      final candidateData = CandidateData.fromJson(jsonMap['data']);
      return candidateData;
    } catch (e) {
      throw Exception('Failed to load candidate data: $e');
    }
  }
}
