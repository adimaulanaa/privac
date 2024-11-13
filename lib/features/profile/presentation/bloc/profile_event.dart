import 'package:equatable/equatable.dart';
import 'package:privac/features/profile/data/models/login_model.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfile extends ProfileEvent {
  const GetProfile();

  @override
  List<Object> get props => [];
}

class CheckProfile extends ProfileEvent {
  const CheckProfile();

  @override
  List<Object> get props => [];
}

class CreateProfile extends ProfileEvent {
  final ProfileModel save;

  const CreateProfile(this.save);

  @override
  List<Object> get props => [save];
}

class LoginProfile extends ProfileEvent {
  final LoginModel login;

  const LoginProfile(this.login);

  @override
  List<Object> get props => [login];
}