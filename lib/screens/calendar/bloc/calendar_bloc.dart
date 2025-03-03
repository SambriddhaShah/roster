import 'dart:convert';
import 'package:rooster_empployee/constants/errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rooster_empployee/service/flutterSecureData.dart';
part 'package:rooster_empployee/screens/calendar/bloc/calendar_event.dart';
part 'package:rooster_empployee/screens/calendar/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc() : super(CalendarFirstInitial()) {
    on<CalendarEvent>((event, emit) async {
      if (event is InitialEvent) {
        try {
          emit(CalendarLoading());
          final listData = [
            {
              'title': 'Meeting with John',
              'note': 'Discuss the new project proposal',
              'date': '2025-02-14',
              'startTime': '10:00 AM',
              'endTime': '11:00 AM',
              'repeat': 'Daily',
              'color': 'Color(0xFF42A5F5)',
            },
            {
              'title': 'Doctor Appointment',
              'note': 'Annual check-up',
              'date': '2025-02-15',
              'startTime': '2:00 PM',
              'endTime': '3:00 PM',
              'repeat': 'Once',
              'color': 'Color(0xFFEF5350)',
            },
            {
              'title': 'Team Meeting',
              'note': 'Review progress on tasks',
              'date': '2025-02-16',
              'startTime': '9:30 AM',
              'endTime': '10:30 AM',
              'repeat': 'Weekly',
              'color': 'Color(0xFF66BB6A)',
            },
            {
              'title': 'Client Call',
              'note': 'Discuss project feedback',
              'date': '2025-02-17',
              'startTime': '4:00 PM',
              'endTime': '4:45 PM',
              'repeat': 'Once',
              'color': 'Color(0xFFFFEB3B)',
            },
            {
              'title': 'Dinner with Friends',
              'note': 'Celebrate Sarah\'s birthday',
              'date': '2025-02-18',
              'startTime': '7:00 PM',
              'endTime': '10:00 PM',
              'repeat': 'Once',
              'color': 'Color(0xFFFF7043)',
            },
          ];
          await FlutterSecureData.setTasks(jsonEncode(listData));
          final taskData = await FlutterSecureData.getTasks() ?? '[]';
          final tasks = jsonDecode(taskData);

          // Filter tasks for the selected date
          final filteredTasks = tasks.where((task) {
            final taskDate = DateTime.parse(task['date']);
            return DateFormat('yyyy-MM-dd').format(taskDate) ==
                DateFormat('yyyy-MM-dd').format(event.selectedDate);
          }).toList();
          await Future.delayed(const Duration(seconds: 3)); // Simulate loading
          emit(CalendarSuccessful(filteredTasks));
        } catch (err) {
          emit(CalendarError(
            error: BlocError(
              message: err.toString(),
              type: 'bloc error',
              statuscode: '120',
            ),
          ));
        }
      }

      if (event is SelectDateEvent) {
        try {
          emit(CalendarLoading());
          final taskData = await FlutterSecureData.getTasks() ?? '[]';
          final tasks = jsonDecode(taskData);

          // Filter tasks for the selected date
          final filteredTasks = tasks.where((task) {
            final taskDate = DateTime.parse(task['date']);
            return DateFormat('yyyy-MM-dd').format(taskDate) ==
                DateFormat('yyyy-MM-dd').format(event.selectedDate);
          }).toList();

          emit(CalendarSuccessful(filteredTasks));
        } catch (err) {
          emit(CalendarError(
            error: BlocError(
              message: err.toString(),
              type: 'bloc error',
              statuscode: '121',
            ),
          ));
        }
      }
    });
  }
}
