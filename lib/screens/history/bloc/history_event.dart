part of 'history_bloc.dart';

@immutable
abstract class HistoryEvent {}

class LoadHistoryEvent extends HistoryEvent {}