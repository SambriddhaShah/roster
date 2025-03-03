part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class InitialEvent extends SignupEvent {
  InitialEvent();
}

class SignupUser extends SignupEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String location;
   String? photo;
   final String countyCode;
  final String password; 

  SignupUser( 
    {required this.countyCode, required this.firstName,
     required this.lastName,
     required this.email,
     required this.phone,
     required this.location,
     required this.photo,required this.password,});
}
