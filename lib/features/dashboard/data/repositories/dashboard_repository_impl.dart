import 'package:dartz/dartz.dart';
import 'package:privac/core/error/failures.dart';
import 'package:privac/features/dashboard/data/datasources/dashboard_local_source.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/dashboard/data/models/update_security_model.dart';
import 'package:privac/features/dashboard/data/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalSource dataLocalSource;

  DashboardRepositoryImpl({required this.dataLocalSource});

  @override
  Future<Either<Failure, List<NotesModel>>> dashboard() async {
    try {
      final result = await dataLocalSource.getDash();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createNotes(NotesModel data) async {
    try {
      final result = await dataLocalSource.createNotes(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, String>> updateNotes(NotesModel data) async {
    try {
      final result = await dataLocalSource.updateNotes(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, String>> updateSecurityNotes(UpdateSecurityModel save) async {
    try {
      final result = await dataLocalSource.updateSecurityNotes(save);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, String>> updatePinNotes(String id, int pin) async {
    try {
      final result = await dataLocalSource.updatePinNotes(id, pin);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
