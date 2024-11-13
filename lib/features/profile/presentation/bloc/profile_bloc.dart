import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart'; // Tambahkan import dartz
import 'package:privac/core/error/failure_to_message.dart';
import 'package:privac/core/error/failures.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';
import 'package:privac/features/profile/data/repositories/profile_repository.dart';

import 'bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepo;

  ProfileBloc({required ProfileRepository profileRepo})
      : _profileRepo = profileRepo,
        super(ProfileInitial()) {
    on<GetProfile>(_onProfile);
    on<CheckProfile>(_onCheck);
    on<CreateProfile>(_onCreate);
    on<LoginProfile>(_onLogin);
  }

  void _onProfile(GetProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    final Either<Failure, List<ProfileModel>> result =
        await _profileRepo.profile();
    result.fold(
      (failure) => emit(ProfileError(mapFailureToMessage(failure))),
      (success) => emit(ProfileLoaded(success)),
    );
  }

  void _onCheck(CheckProfile event, Emitter<ProfileState> emit) async {
    emit(CheckProfileLoading());

    final Either<Failure, bool> result =
        await _profileRepo.check();
    result.fold(
      (failure) => emit(CheckProfileError(mapFailureToMessage(failure))),
      (success) => emit(CheckProfileLoaded(success)),
    );
  }

  void _onCreate(CreateProfile event, Emitter<ProfileState> emit) async {
    emit(CreateProfileLoading());

    final Either<Failure, String> result =
        await _profileRepo.create(event.save);
    result.fold(
      (failure) => emit(CreateProfileError(mapFailureToMessage(failure))),
      (success) => emit(CreateProfileSuccess(success)),
    );
  }

  void _onLogin(LoginProfile event, Emitter<ProfileState> emit) async {
    emit(LoginLoading());

    final Either<Failure, String> result =
        await _profileRepo.login(event.login);
    result.fold(
      (failure) => emit(LoginError(mapFailureToMessage(failure))),
      (success) => emit(LoginSuccess(success)),
    );
  }
}
