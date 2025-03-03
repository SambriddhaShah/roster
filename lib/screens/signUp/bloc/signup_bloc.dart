
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:rooster_empployee/constants/errors.dart';
import 'package:rooster_empployee/screens/signUp/models/signupRepositary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
part 'package:rooster_empployee/screens/signUp/bloc/signup_event.dart';
part 'package:rooster_empployee/screens/signUp/bloc/signup_state.dart';





class SignupBloc
    extends Bloc<SignupEvent, SignupState> {
  Signuprepository SignupRepository;

  SignupBloc(
    this.SignupRepository
    )
      : super(SignupInitial()) {
    on<SignupEvent>((event, emit) async {
      if (event is InitialEvent) {
        try {
          emit(SignupStart());

         
        } catch (err) {
       
          emit(SignupError(error: BlocError(message: err.toString(), type: 'bloc error', statuscode: '120')
             ));
          rethrow;
        }
      }else if (event is SignupUser) {
        try {

          emit(SignupLoading());
          final SignupData = {
        'firstName': event.firstName,
        'lastName': event.lastName,
        'email': event.email,
        'phone': '${event.countyCode}${event.phone}',
        'location': event.location,
        'profileImage': event.photo,
        'password':event.password
      };
      print('in bloc is $SignupData');
          emit(SignupSuccessful(userData: SignupData));  
        } catch (err) {
       
          emit(SignupError(error: BlocError(message: err.toString(), type: 'bloc error', statuscode: '120')
             ));
          rethrow;
        }
      }
    });
  }
}
