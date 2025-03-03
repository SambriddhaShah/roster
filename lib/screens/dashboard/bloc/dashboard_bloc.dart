import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooster_empployee/constants/errors.dart';
import 'package:rooster_empployee/screens/dashboard/models/dashboardData.dart';
import 'package:rooster_empployee/screens/dashboard/repositary/dashboard_repositary.dart';
import 'package:rooster_empployee/screens/history/models/taskData.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
part 'package:rooster_empployee/screens/dashboard/bloc/dashboard_event.dart';
part 'package:rooster_empployee/screens/dashboard/bloc/dashboard_state.dart';





class DashboardBloc
    extends Bloc<DashboardEvent, DashboardState> {
  Dashboardrepository dashboardRepository;

  DashboardBloc(
    this.dashboardRepository
    )
      : super(DashboardFirstInitial()) {
    on<DashboardEvent>((event, emit) async {
      if (event is InitialEvent) {
        print('the initial event is triggred');
        try {

         emit(DashboardLoading());
      final data = await dashboardRepository.getDashboardData();
      final userData= await FlutterSecureData.getUserData();
      final user= jsonDecode(userData??'');
      emit(DashboardSuccessful(data,user));

       

          
        } catch (err) {
       
          emit(DashboardError(error: BlocError(message: err.toString(), type: 'bloc error', statuscode: '120')
             ));
          rethrow;
        }
      }else if (event is CheckOutEvent) {
        print('the initial event is triggred');
        try {

         emit(DashboardCheckOutLoading());
         await FlutterSecureData.setTodo('false');
           final history = await FlutterSecureData.getDoneTask();
        var historyjson = jsonDecode(history ?? '[]');
        historyjson.add(event.data);
        await FlutterSecureData.setDoneTask(jsonEncode(historyjson));
          final userData= await FlutterSecureData.getUserData();
      final user= jsonDecode(userData??'');
        
      final data = await dashboardRepository.getDashboardData();;
      emit(DashboardSuccessful(data, user));

       

          
        } catch (err) {
       
          emit(DashboardError(error: BlocError(message: err.toString(), type: 'bloc error', statuscode: '120')
             ));
          rethrow;
        }
      }
    });
    
  }
}
