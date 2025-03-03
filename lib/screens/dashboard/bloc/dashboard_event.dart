part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {
}
class InitialEvent extends DashboardEvent{
  InitialEvent();
}
class CheckOutEvent extends DashboardEvent{
  HistoryData data;
  CheckOutEvent({required this.data});
}

