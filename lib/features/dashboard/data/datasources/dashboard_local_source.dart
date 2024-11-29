import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/dashboard/data/models/update_security_model.dart';
import 'package:privac/features/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DashboardLocalSource {
  Future<String> createNotes(NotesModel data);
  Future<String> updateNotes(NotesModel data);
  Future<String> updateSecurityNotes(UpdateSecurityModel save);
  Future<String> updatePinNotes(String id, int pin);
  Future<String> deleteNotes(String id);
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
    String usernameId = sharedPreferences.getString('id') ?? '';
    String username = sharedPreferences.getString('username') ?? '';
    data.createdBy = username;
    data.updatedBy = username;
    data.createdId = usernameId;
    String create = await localDatabase.insertNotes(data);
    return create;
  }

  @override
  Future<List<NotesModel>> getDash() async {
    String id = sharedPreferences.getString('id') ?? '';
    List<NotesModel> notes = [];
    List<NotesModel> get = await localDatabase.getAllNote();
    for (var e in get) {
      if (e.password != '' || e.fingerprintId != '' || e.faceId != '') {
        e.isPassword = true;
      }
      if (e.createdId == id) {
        notes.add(e);
      }
    }
    if (notes.isNotEmpty) {
      // Memprioritaskan catatan berdasarkan nilai isPin (nilai tertinggi di atas)
      notes.sort((a, b) => b.isPin!.compareTo(a.isPin!));
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
  Future<String> updateSecurityNotes(UpdateSecurityModel save) async {
    String username = sharedPreferences.getString('username') ?? '';
    String create = await localDatabase.updatePasswordNotes(save, username);
    return create;
  }
  
  @override
  Future<String> updatePinNotes(String id, int pin)  async {
    String username = sharedPreferences.getString('username') ?? '';
    String create = await localDatabase.updatePinNotes(id, pin, username);
    return create;
  }
  
  @override
  Future<String> deleteNotes(String id) async {
    String delete = await localDatabase.deleteNotes(id);
    return delete;
  }
}
