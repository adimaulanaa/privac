import 'package:equatable/equatable.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}
class CreateNotesLoading extends DashboardState {}
class UpdateNotesLoading extends DashboardState {}
class UpdatePassNotesLoading extends DashboardState {}
class UpdatePinNotesLoading extends DashboardState {}

class DashboardError extends DashboardState {
  final String dashboard;

  const DashboardError(this.dashboard);

  @override
  List<Object> get props => [dashboard];
}

class DashboardLoaded extends DashboardState {
  final List<NotesModel> data;
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

class UpdateNotesError extends DashboardState {
  final String error;

  const UpdateNotesError(this.error);

  @override
  List<Object> get props => [error];
}

class UpdateNotesSuccess extends DashboardState {
  final String success;

  const UpdateNotesSuccess(this.success);

  @override
  List<Object> get props => [success];
}

class UpdatePinNotesError extends DashboardState {
  final String error;

  const UpdatePinNotesError(this.error);

  @override
  List<Object> get props => [error];
}

class UpdatePinNotesSuccess extends DashboardState {
  final String success;

  const UpdatePinNotesSuccess(this.success);

  @override
  List<Object> get props => [success];
}

class UpdatePassNotesError extends DashboardState {
  final String error;

  const UpdatePassNotesError(this.error);

  @override
  List<Object> get props => [error];
}

class UpdatePassNotesSuccess extends DashboardState {
  final String success;

  const UpdatePassNotesSuccess(this.success);

  @override
  List<Object> get props => [success];
}