// File: lib/features/auth/data/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:privac/core/error/failures.dart';
import 'package:privac/features/dashboard/data/models/dashboard_model.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<DashboardModel>>> dashboard();
  Future<Either<Failure, String>> createNotes(NotesModel data);
}
