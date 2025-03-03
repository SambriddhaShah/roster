part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardFirstInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}
class DashboardCheckOutLoading extends DashboardState {}


class DashboardSuccessful extends DashboardState {
  final DashboardData? data;
  final dynamic userData;
  DashboardSuccessful(this.data, this.userData);
}

class DashboardError extends DashboardState {
  final BlocError error;
  DashboardError({required this.error});
}