import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages2/bloc/candidate_event.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages2/bloc/candidate_state.dart';
import 'package:rooster_empployee/screens/Applicant/Interview%20Stages2/repositary/candidate_repositary.dart';

class CandidateBloc extends Bloc<CandidateEvent, CandidateState> {
  final CandidateRepository repository;

  CandidateBloc(this.repository) : super(CandidateInitial()) {
    on<LoadCandidate>((event, emit) async {
      emit(CandidateLoading());
      try {
        final data = await repository.fetchCandidate();
        emit(CandidateLoaded(data));
      } catch (e) {
        emit(CandidateError(e.toString()));
      }
    });
  }
}
