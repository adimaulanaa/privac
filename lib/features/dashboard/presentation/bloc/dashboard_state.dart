import 'package:equatable/equatable.dart';
import 'package:privac/features/dashboard/data/models/dashboard_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}
class CreateNotesLoading extends DashboardState {}

class DashboardError extends DashboardState {
  final String dashboard;

  const DashboardError(this.dashboard);

  @override
  List<Object> get props => [dashboard];
}

class DashboardLoaded extends DashboardState {
  final List<DashboardModel> data;
  const DashboardLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class CreateNotesError extends DashboardState {
  final String error;

  const CreateNotesError(this.error);

  @override
  List<Object> get props => [error];
}

class CreateNotesSuccess extends DashboardState {
  final String success;

  const CreateNotesSuccess(this.success);

  @override
  List<Object> get props => [success];
}