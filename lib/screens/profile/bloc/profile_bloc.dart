import 'dart:convert';

import 'package:rooster_empployee/constants/errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileFirstInitial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is InitialEvent) {
        try {
          emit(ProfileLoading());
          final userData= await FlutterSecureData.getUserData();
          final user= jsonDecode(userData??'{}');
          // await FlutterSecureData.setUserData(jsonEncode({
          //   'firstName': 'John',
          //   'lastName': 'Doe',
          //   'email': 'john.doe@example.com',
          //   'companyName': 'Tech Corp',
          //   'registrationDetails': 'REG12345',
          //   'password': 'password123',
          //   'profileImage':null
          // }));
          // Load user data from secure storage
          // final user = await FlutterSecureData.getUserData() ?? '{}';

          // final userData = jsonDecode(user);
          print('thye final userdata is ${user}');
          emit(ProfileSuccessful(user));
        } catch (err) {
          emit(ProfileError(
            error: BlocError(
              message: err.toString(),
              type: 'bloc error',
              statuscode: '120',
            ),
          ));
        }
      }

      if (event is UpdateProfileEvent) {
        try {
          emit(ProfileLoading());
          // Update user data in secure storage
          await FlutterSecureData.setUserData(jsonEncode(event.updatedData));
          emit(ProfileSuccessful(event.updatedData));
        } catch (err) {
          emit(ProfileError(
            error: BlocError(
              message: err.toString(),
              type: 'bloc error',
              statuscode: '121',
            ),
          ));
        }
      }

      if(event is ChangePasswordEvent){
         try {
        emit(ProfileLoading());
        
        // 1. Verify old password matches stored password
        final storedPassword = await FlutterSecureData.getPassword();
        if (event.oldPassword != storedPassword) {
          throw Exception('Old password is incorrect');
        }

        // 2. Verify new passwords match
        if (event.newPassword != event.confirmPassword) {
          throw Exception('New passwords do not match');
        }

        // 3. Update password in secure storage
        await FlutterSecureData.setPassword(event.newPassword);
        final userData= jsonDecode(await FlutterSecureData.getUserData()??'{}');

        emit(ProfileSuccessful(userData));
      } catch (err) {
        emit(ProfileError(
          error: BlocError(
            message: err.toString(),
            type: 'password_error',
            statuscode: '122'
          )
        ));
      }
      }

      
    });
  }
}
