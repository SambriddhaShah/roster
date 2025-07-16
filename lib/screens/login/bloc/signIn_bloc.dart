import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:rooster_empployee/constants/errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/service/apiService.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
import 'package:rooster_empployee/utils/tostMessage.dart';
part 'package:rooster_empployee/screens/login/bloc/signIn_event.dart';
part 'package:rooster_empployee/screens/login/bloc/signIn_state.dart';

class signInBloc extends Bloc<SigninEvent, signInState> {
  final api = ApiService(Dio());
  // signInrepository signInRepository;

  signInBloc(
      // this.signInRepository
      )
      : super(signInFirstInitial()) {
    on<SigninEvent>((event, emit) async {
      if (event is InitialEvent) {
        print('the initial event is triggred');
        try {
          emit(signInLoading());

          final isChecked =
              toBoolean((await FlutterSecureData.getRememberMe()).toString());
          String username = '';

          if (await FlutterSecureData.getRememberMe() == "true") {
            final usernameData = await FlutterSecureData.getUserName() ?? "";
            username = usernameData;
          }

          emit(signInInitial(username: username, isChecked: isChecked));
        } catch (err) {
          print('error Occured ${err.toString()}');
          emit(signInError(
              error: BlocError(
                  message: err.toString(),
                  type: 'bloc error',
                  statuscode: '120')));
          rethrow;
        }
      }
      if (event is SignInMainEvent) {
        emit(signInLoading());

        if (event.passowrd.isEmpty || event.username.isEmpty) {
          emit(signInError(
              error: BlocError(
                  message: 'Fill all the fileds',
                  type: 'bloc error',
                  statuscode: '120')));
        } else {
          try {
            final response =
                await api.loginCandidate(event.username, event.passowrd);

            final candidateResponse = await api.getCandiate();

            await FlutterSecureData.setIsHired(false);

            // You can add more logic here if needed
            await FlutterSecureData.setUserData(jsonEncode(candidateResponse));
            await FlutterSecureData.setUserName(event.username);
            emit(signInSuccessful("Welcome to the application"));
            ToastMessage.showMessage('Login Successful');
          } on DioException catch (dioError) {
            final error = dioError.error;
            if (error is ApiError) {
              emit(signInError(
                error: BlocError(
                  message: error.message,
                  type: error.type ?? "",
                  statuscode: 'custom',
                ),
              ));
            } else {
              emit(signInError(
                error: BlocError(
                  message: dioError.message ?? 'Something went wrong',
                  type: 'dio_error',
                  statuscode: '500',
                ),
              ));
            }
          }
          // try {
          //   final username = await FlutterSecureData.getUserName();
          //   final password = await FlutterSecureData.getPassword();
          //   final userData = await FlutterSecureData.getUserData();
          //   final user = jsonDecode(userData ?? '{}');
          //   print('the user data is $user');
          //   if ((event.username == user['email'] &&
          //           event.passowrd == password) ||
          //       event.username == "jondoe@gmail.com") {
          //     emit(signInSuccessful("Welcome to the Rapplication"));
          //     ToastMessage.showMessage('Login Sucessful');
          //   } else {
          //     emit(signInError(
          //         error: BlocError(
          //             message: 'Invalid username or password',
          //             type: 'bloc error',
          //             statuscode: '401')));
          //   }
          // } catch (err) {
          //   signInError(
          //       error: BlocError(
          //           message: err.toString(),
          //           type: 'bloc error',
          //           statuscode: "120"));
          // }
        }
      }
    });
  }
}

// Convert a string to a boolean value
bool toBoolean(String string) {
  if (string == 'true') {
    return true;
  } else {
    return false;
  }
}
