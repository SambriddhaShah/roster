import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rooster_empployee/screens/history/models/taskData.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
part 'package:rooster_empployee/screens/history/bloc/history_event.dart';
part 'package:rooster_empployee/screens/history/bloc/history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  

  HistoryBloc() : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
  }

  Future<void> _onLoadHistory(LoadHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final tasksJson = await FlutterSecureData.getDoneTask() ?? '[]';
      print('the tasks is ${tasksJson}');
      final List<dynamic> tasksList = jsonDecode(tasksJson);
      print('the tasks list is ${tasksList}');
      final tasks = tasksList.map((task) => HistoryData.fromJson(task)).toList();
      print('the tasks is ${tasks}');
      emit(HistoryLoaded(tasks));
    } catch (e) {
      emit(HistoryError('Failed to load history: ${e.toString()}'));
    }
  }
}