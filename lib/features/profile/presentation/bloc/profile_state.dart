import 'package:equatable/equatable.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}
class CreateProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String profile;

  const ProfileError(this.profile);

  @override
  List<Object> get props => [profile];
}

class ProfileLoaded extends ProfileState {
  final List<ProfileModel> data;
  const ProfileLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class CreateProfileError extends ProfileState {
  final String error;

  const CreateProfileError(this.error);

  @override
  List<Object> get props => [error];
}

class CreateProfileSuccess extends ProfileState {
  final String success;

  const CreateProfileSuccess(this.success);

  @override
  List<Object> get props => [success];
}