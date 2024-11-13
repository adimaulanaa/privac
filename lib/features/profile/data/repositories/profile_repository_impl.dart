import 'package:dartz/dartz.dart';
import 'package:privac/core/error/failures.dart';
import 'package:privac/features/profile/data/datasources/profile_local_source.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';
import 'package:privac/features/profile/data/models/profile_save_model.dart';
import 'package:privac/features/profile/data/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalSource dataLocalSource;

  ProfileRepositoryImpl({required this.dataLocalSource});

  @override
  Future<Either<Failure, List<ProfileModel>>> profile() async {
    try {
      // final result = await dataLocalSource.profile(
      //   // businessRuleRuntimeIdentityId: ConfigService.bRIdProfile,
      //   businessRuleRuntimeIdentityId: ConfigService.bRIdNotification,
      //   sessionId: ConfigService.sessionId,
      // );
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createProfile(ProfileSaveModel data) async {
    try {
      final result = await dataLocalSource.create(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
