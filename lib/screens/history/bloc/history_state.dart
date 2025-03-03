part of 'history_bloc.dart';

@immutable
abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoryData> tasks;
  HistoryLoaded(this.tasks);
}

class HistoryError extends HistoryState {
  final String error;
  HistoryError(this.error);
}