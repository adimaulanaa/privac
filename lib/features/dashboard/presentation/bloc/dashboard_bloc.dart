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
    on<UpdateNotes>(_onUpdate);
    on<UpdatePinNotes>(_onUpdatePin);
    on<UpdateSecurityNotes>(_onUpdatePass);
    on<DeleteNotes>(_onDeleteNote);
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

  void _onUpdate(UpdateNotes event, Emitter<DashboardState> emit) async {
    emit(UpdateNotesLoading());

    final Either<Failure, String> result =
        await _dashboardRepo.updateNotes(event.save);
    result.fold(
      (failure) => emit(UpdateNotesError(mapFailureToMessage(failure))),
      (success) => emit(UpdateNotesSuccess(success)),
    );
  }

  void _onUpdatePin(UpdatePinNotes event, Emitter<DashboardState> emit) async {
    emit(UpdatePinNotesLoading());

    final Either<Failure, String> result =
        await _dashboardRepo.updatePinNotes(event.id, event.pin);
    result.fold(
      (failure) => emit(UpdatePinNotesError(mapFailureToMessage(failure))),
      (success) => emit(UpdatePinNotesSuccess(success)),
    );
  }
  
  void _onUpdatePass(UpdateSecurityNotes event, Emitter<DashboardState> emit) async {
    emit(UpdateSecutiryNotesLoading());

    final Either<Failure, String> result =
        await _dashboardRepo.updateSecurityNotes(event.save);
    result.fold(
      (failure) => emit(UpdateSecurityNotesError(mapFailureToMessage(failure))),
      (success) => emit(UpdateSecurityNotesSuccess(success, event.type)),
    );
  }

  void _onDeleteNote(DeleteNotes event, Emitter<DashboardState> emit) async {
    emit(DeleteNotesLoading());

    final Either<Failure, String> result =
        await _dashboardRepo.deleteNotes(event.id);
    result.fold(
      (failure) => emit(DeleteNotesError(mapFailureToMessage(failure))),
      (success) => emit(DeleteNotesSuccess(success)),
    );
  }
}
