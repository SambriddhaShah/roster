part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState{}

class SignupStart extends SignupState {
}

class SignupLoading extends SignupState {}

class SignupSuccessful extends SignupState {
  final Map<String, String?> userData;


  SignupSuccessful({required this.userData});
}

class SignupError extends SignupState {
  final BlocError error;
  SignupError({
    required this.error,
  });
}