import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DashboardLocalSource {
  Future<String> createNotes(NotesModel data);
  Future<String> updateNotes(NotesModel data);
  Future<String> updatePassNotes(int id, String password);
  Future<List<NotesModel>> getDash();
}

class DashboardLocalSourceImpl implements DashboardLocalSource {
  final SharedPreferences sharedPreferences;
  final DatabaseService localDatabase;

  DashboardLocalSourceImpl({
    required this.sharedPreferences,
    required this.localDatabase,
  });

  @override
  Future<String> createNotes(NotesModel data) async {
    int usernameId = sharedPreferences.getInt('id') ?? 0;
    String username = sharedPreferences.getString('username') ?? '';
    data.createdBy = username;
    data.updatedBy = username;
    data.createdId = usernameId;
    String create = await localDatabase.insertNotes(data);
    return create;
  }

  @override
  Future<List<NotesModel>> getDash() async {
    int id = sharedPreferences.getInt('id') ?? 0;
    List<NotesModel> notes = [];
    List<NotesModel> get = await localDatabase.getAllNote();
    for (var e in get) {
      if (e.password != '') {
        e.isPassword = true;
      }
      if (e.createdId == id) {
        notes.add(e);
      }
    }
    return notes;
  }
  
  @override
  Future<String> updateNotes(NotesModel data) async {
    String username = sharedPreferences.getString('username') ?? '';
    data.updatedBy = username;
    String create = await localDatabase.updateNotes(data);
    return create;
  }

  @override
  Future<String> updatePassNotes(int id, String password) async {
    String username = sharedPreferences.getString('username') ?? '';
    String create = await localDatabase.updatePasswordNotes(id, password, username);
    return create;
  }
}
