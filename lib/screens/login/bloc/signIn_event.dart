// part of 'signIn_bloc.dart';

// @immutable
// abstract class signInEvent {}

// class Start extends signInEvent {
//   Start();
// }

part of 'signIn_bloc.dart';

@immutable 
abstract class SigninEvent {
}
class InitialEvent extends SigninEvent{
  InitialEvent();
}

class SignInMainEvent extends SigninEvent{
  final String username;
  final String passowrd;
      SignInMainEvent({required this.username, required this.passowrd});
}