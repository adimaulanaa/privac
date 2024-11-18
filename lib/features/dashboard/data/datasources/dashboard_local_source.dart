import 'package:privac/features/dashboard/data/models/dashboard_model.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DashboardLocalSource {
  Future<String> createNotes(NotesModel data);
  Future<List<DashboardModel>> getDash();
}

class DashboardLocalSourceImpl implements DashboardLocalSource {
  final SharedPreferences sharedPreferences;

  DashboardLocalSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<String> createNotes(NotesModel data) async {
    final DatabaseService database = DatabaseService();
    String create = await database.insertNotes(data);
    return create;
  }

  @override
  Future<List<DashboardModel>> getDash() async {
    // final DatabaseService database = DatabaseService();
    // bool check = await database.isUserTableEmpty();
    return [];
  }
}
