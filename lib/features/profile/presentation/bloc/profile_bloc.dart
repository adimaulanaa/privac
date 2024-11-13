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
    on<CreateProfile>(_onCreateProfile);
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

  void _onCreateProfile(CreateProfile event, Emitter<ProfileState> emit) async {
    emit(CreateProfileLoading());

    final Either<Failure, String> result =
        await _profileRepo.createProfile(event.save);
    result.fold(
      (failure) => emit(CreateProfileError(mapFailureToMessage(failure))),
      (success) => emit(CreateProfileSuccess(success)),
    );
  }
}
