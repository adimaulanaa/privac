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