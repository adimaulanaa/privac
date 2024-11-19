import 'package:equatable/equatable.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class GetDashboard extends DashboardEvent {
  const GetDashboard();

  @override
  List<Object> get props => [];
}

class CreateNotes extends DashboardEvent {
  final NotesModel save;

  const CreateNotes(this.save);

  @override
  List<Object> get props => [save];
}

class UpdateNotes extends DashboardEvent {
  final NotesModel save;

  const UpdateNotes(this.save);

  @override
  List<Object> get props => [save];
}

class UpdatePassNotes extends DashboardEvent {
  final int id;
  final String password;

  const UpdatePassNotes({required this.id, required this.password});

  @override
  List<Object> get props => [id, password];
}