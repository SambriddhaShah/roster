part of 'signIn_bloc.dart';

@immutable
abstract class signInState {}

class signInFirstInitial extends signInState{}

class signInInitial extends signInState {
  final String username;
  final bool isChecked;
  signInInitial({required this.username, required this.isChecked});
}

class signInLoading extends signInState {}

class signInSuccessful extends signInState {
  final String signInmsg;

  signInSuccessful(this.signInmsg);
}

class signInError extends signInState {
  final Exception error;
  signInError({
    required this.error,
  });
}