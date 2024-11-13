import 'package:privac/features/profile/data/datasources/database_profile_service.dart';
import 'package:privac/features/profile/data/models/profile_save_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalSource {
  Future<String> create(ProfileSaveModel data);
}

class ProfileLocalSourceImpl implements ProfileLocalSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<String> create(ProfileSaveModel data) async {
    final DatabaseProfileService database = DatabaseProfileService();
    String create = await database.insertUser(data);
    return create;
  }
}
