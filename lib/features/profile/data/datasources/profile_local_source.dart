import 'package:privac/core/error/failures.dart';
import 'package:privac/features/services/database_service.dart';
import 'package:privac/features/profile/data/models/login_model.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalSource {
  Future<String> create(ProfileModel data);
  Future<bool> check();
  Future<String> login(LoginModel data);
}

class ProfileLocalSourceImpl implements ProfileLocalSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<String> create(ProfileModel data) async {
    final DatabaseProfileService database = DatabaseProfileService();
    String create = await database.insertUser(data);
    return create;
  }

  @override
  Future<bool> check() async {
    final DatabaseProfileService database = DatabaseProfileService();
    bool check = await database.isUserTableEmpty();
    return check;
  }

  @override
  Future<String> login(LoginModel data) async {
    String message = '';
    final DatabaseProfileService database = DatabaseProfileService();
    try {
      ProfileModel result = await database.login(data);
      if (result.id != 0) {
        message = 'Login berhasil';
      } else {
        message = 'Login gagal';
        throw ServerFailure(message);
      }
    } catch (e) {
      message = 'Login gagal: Terjadi kesalahan pada server';
      throw ServerFailure(message);
    }
    return message;
  }
}
