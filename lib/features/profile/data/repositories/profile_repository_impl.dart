import 'package:dartz/dartz.dart';
import 'package:privac/core/error/failures.dart';
import 'package:privac/features/profile/data/datasources/profile_local_source.dart';
import 'package:privac/features/profile/data/models/login_model.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';
import 'package:privac/features/profile/data/models/security_profile_model.dart';
import 'package:privac/features/profile/data/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalSource dataLocalSource;

  ProfileRepositoryImpl({required this.dataLocalSource});

  @override
  Future<Either<Failure, ProfileModel>> profile() async {
    try {
      final result = await dataLocalSource.profile();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> create(ProfileModel data) async {
    try {
      final result = await dataLocalSource.create(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, SecurityLogin>> check() async {
    try {
      final result = await dataLocalSource.check();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> login(LoginModel data) async {
    try {
      final result = await dataLocalSource.login(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> security(SecurityProfileModel data) async {
    try {
      final result = await dataLocalSource.security(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
