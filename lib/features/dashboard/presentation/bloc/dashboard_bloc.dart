import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart'; // Tambahkan import dartz
import 'package:privac/core/error/failure_to_message.dart';
import 'package:privac/core/error/failures.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/dashboard/data/repositories/dashboard_repository.dart';

import 'bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepo;

  DashboardBloc({required DashboardRepository dashboardRepo})
      : _dashboardRepo = dashboardRepo,
        super(DashboardInitial()) {
    on<GetDashboard>(_onDashboard);
    on<CreateNotes>(_onCreate);
  }

  void _onDashboard(GetDashboard event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());

    final Either<Failure, List<NotesModel>> result =
        await _dashboardRepo.dashboard();
    result.fold(
      (failure) => emit(DashboardError(mapFailureToMessage(failure))),
      (success) => emit(DashboardLoaded(success)),
    );
  }

  void _onCreate(CreateNotes event, Emitter<DashboardState> emit) async {
    emit(CreateNotesLoading());

    final Either<Failure, String> result =
        await _dashboardRepo.createNotes(event.save);
    result.fold(
      (failure) => emit(CreateNotesError(mapFailureToMessage(failure))),
      (success) => emit(CreateNotesSuccess(success)),
    );
  }
}
