import 'package:rooster_empployee/screens/Applicant/Interview%20Stages2/models/candidate_model.dart';

abstract class CandidateState {}

class CandidateInitial extends CandidateState {}

class CandidateLoading extends CandidateState {}

class CandidateLoaded extends CandidateState {
  final CandidateData candidateData;
  CandidateLoaded(this.candidateData);
}

class CandidateError extends CandidateState {
  final String message;
  CandidateError(this.message);
}
