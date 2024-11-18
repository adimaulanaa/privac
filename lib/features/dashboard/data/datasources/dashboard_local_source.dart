import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DashboardLocalSource {
  Future<String> createNotes(NotesModel data);
  Future<List<NotesModel>> getDash();
}

class DashboardLocalSourceImpl implements DashboardLocalSource {
  final SharedPreferences sharedPreferences;

  DashboardLocalSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<String> createNotes(NotesModel data) async {
    final DatabaseService database = DatabaseService();
    int usernameId = sharedPreferences.getInt('id') ?? 0;
    String username = sharedPreferences.getString('username') ?? '';
    data.createdBy = username;
    data.updatedBy = username;
    data.createdId = usernameId;
    String create = await database.insertNotes(data);
    return create;
  }

  @override
  Future<List<NotesModel>> getDash() async {
    final DatabaseService database = DatabaseService();
    int id = sharedPreferences.getInt('id') ?? 0;
    List<NotesModel> notes = [];
    List<NotesModel> get = await database.getAllNote();
    for (var e in get) {
      if (e.createdId == id) {
        notes.add(e);
      }
    }
    return notes;
  }
}
