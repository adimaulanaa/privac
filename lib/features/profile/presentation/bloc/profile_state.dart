import 'package:equatable/equatable.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}
class CheckProfileLoading extends ProfileState {}
class CreateProfileLoading extends ProfileState {}
class LoginLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String profile;

  const ProfileError(this.profile);

  @override
  List<Object> get props => [profile];
}

class CheckProfileError extends ProfileState {
  final String error;

  const CheckProfileError(this.error);

  @override
  List<Object> get props => [error];
}

class ProfileLoaded extends ProfileState {
  final List<ProfileModel> data;
  const ProfileLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class CheckProfileLoaded extends ProfileState {
  final bool check;
  const CheckProfileLoaded(this.check);

  @override
  List<Object> get props => [check];
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

class LoginError extends ProfileState {
  final String error;

  const LoginError(this.error);

  @override
  List<Object> get props => [error];
}

class LoginSuccess extends ProfileState {
  final String success;

  const LoginSuccess(this.success);

  @override
  List<Object> get props => [success];
}