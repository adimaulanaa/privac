import 'package:privac/core/error/failures.dart';
import 'package:privac/features/profile/data/models/security_profile_model.dart';
import 'package:privac/features/services/database_service.dart';
import 'package:privac/features/profile/data/models/login_model.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalSource {
  Future<ProfileModel> profile();
  Future<String> create(ProfileModel data);
  Future<SecurityLogin> check();
  Future<String> login(LoginModel data);
  Future<String> security(SecurityProfileModel data);
}

class ProfileLocalSourceImpl implements ProfileLocalSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<String> create(ProfileModel data) async {
    final DatabaseService database = DatabaseService();
    String create = await database.insertUser(data);
    return create;
  }

  @override
  Future<SecurityLogin> check() async {
    final DatabaseService database = DatabaseService();
    bool user = await database.isUserTableEmpty();
    int type = await database.getAdminUsers();
    SecurityLogin check = SecurityLogin(
      check: user,
      isSecurity: type,
    );
    return check;
  }

  @override
  Future<String> login(LoginModel data) async {
    String message = '';
    final DatabaseService database = DatabaseService();
    try {
      ProfileModel result = await database.login(data);
      if (result.id != '') {
        await sharedPreferences.setString('id', result.id!);
        await sharedPreferences.setString('name', result.name!);
        await sharedPreferences.setString('username', result.username!);
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
  
  @override
  Future<ProfileModel> profile() async {
    final DatabaseService database = DatabaseService();
    String id = sharedPreferences.getString('id') ?? '';
    ProfileModel data = await database.getUsers(id);
    return data;
  }
  
  @override
  Future<String> security(SecurityProfileModel data) async {
    final DatabaseService database = DatabaseService();
    String id = sharedPreferences.getString('id') ?? '';
    String username = sharedPreferences.getString('username') ?? '';
    String dt = await database.updateSecurityProfile(id, username, data);
    return dt;
  }
}
