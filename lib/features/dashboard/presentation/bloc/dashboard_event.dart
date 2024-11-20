import 'package:equatable/equatable.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/dashboard/data/models/update_security_model.dart';

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

class UpdatePinNotes extends DashboardEvent {
  final int id;
  final int pin;

  const UpdatePinNotes({required this.id, required this.pin});

  @override
  List<Object> get props => [id, pin];
}

class UpdateSecurityNotes extends DashboardEvent {
  final UpdateSecurityModel save;

  const UpdateSecurityNotes({required this.save});

  @override
  List<Object> get props => [save];
}
