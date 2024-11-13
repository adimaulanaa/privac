import 'package:equatable/equatable.dart';
import 'package:privac/features/profile/data/models/profile_save_model.dart';

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

class CreateProfile extends ProfileEvent {
  final ProfileSaveModel save;

  const CreateProfile(this.save);

  @override
  List<Object> get props => [save];
}