part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileFirstInitial extends ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccessful extends ProfileState {
  final Map<String, dynamic> userData;
  ProfileSuccessful(this.userData);
}

class ProfileError extends ProfileState {
  final BlocError error;
  ProfileError({required this.error});
}