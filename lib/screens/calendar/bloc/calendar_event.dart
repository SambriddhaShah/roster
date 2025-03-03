// part of 'calendar_bloc.dart';

// @immutable
// abstract class CalendarEvent {
// }
// class InitialEvent extends CalendarEvent{
//   InitialEvent();
// }

part of 'calendar_bloc.dart';

@immutable
abstract class CalendarEvent {}

class InitialEvent extends CalendarEvent {
  final DateTime selectedDate;
  InitialEvent(this.selectedDate);
}

class SelectDateEvent extends CalendarEvent {
  final DateTime selectedDate;
  SelectDateEvent(this.selectedDate);
}