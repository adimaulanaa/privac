// File: lib/features/auth/data/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:privac/core/error/failures.dart';
import 'package:privac/features/profile/data/models/login_model.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';
import 'package:privac/features/profile/data/models/security_profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> profile();
  Future<Either<Failure, SecurityLogin>> check();
  Future<Either<Failure, String>> create(ProfileModel data);
  Future<Either<Failure, String>> login(LoginModel data);
  Future<Either<Failure, String>> security(SecurityProfileModel data);
}
