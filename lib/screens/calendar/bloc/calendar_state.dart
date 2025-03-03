// part of 'calendar_bloc.dart';

// @immutable
// abstract class CalendarState {}

// class CalendarFirstInitial extends CalendarState{}

// class CalendarInitial extends CalendarState {

// }

// class CalendarLoading extends CalendarState {}

// class CalendarSuccessful extends CalendarState {
//   final List<Appointment> appointments;

//   CalendarSuccessful(this.appointments);
// }

// class CalendarError extends CalendarState {
//   final BlocError error;
//   CalendarError({
//     required this.error,
//   });
// }
part of 'calendar_bloc.dart';

@immutable
abstract class CalendarState {}

class CalendarFirstInitial extends CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarSuccessful extends CalendarState {
  final List<dynamic> tasks;
  CalendarSuccessful(this.tasks);
}

class CalendarError extends CalendarState {
  final BlocError error;
  CalendarError({required this.error});
}