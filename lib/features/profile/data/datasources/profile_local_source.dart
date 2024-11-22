import 'package:privac/core/error/failures.dart';
import 'package:privac/features/profile/data/models/security_profile_model.dart';
import 'package:privac/features/services/database_service.dart';
import 'package:privac/features/profile/data/models/login_model.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ProfileLocalSource {
  Future<List<ProfileModel>> profile();
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
      List<ProfileModel> result = await database.getAllUsers();
      bool userFound = false;
      for (var e in result) {
        if (e.username == data.username) {
          if (e.password == data.password) {
            userFound = true; // Pengguna ditemukan
            message = 'Login berhasil';
            await sharedPreferences.setString('id', e.id!);
            await sharedPreferences.setString('name', e.name!);
            await sharedPreferences.setString('username', e.username!);
          } else {
            message = 'Password salah';
          }
          break; // Keluar dari loop setelah menemukan pengguna
        } else {
          message = 'User tidak ditemukan';
        }
      }
      if (!userFound) {
        throw ServerFailure(message);
      }
      return message;
    } catch (e) {
      if (e is ServerFailure) {
        message = e.message;
      } else {
        message = 'Login gagal: Terjadi kesalahan pada server';
      }
      throw ServerFailure(message);
    }
  }

  @override
  Future<List<ProfileModel>> profile() async {
    final DatabaseService database = DatabaseService();
    List<ProfileModel> data = await database.getAllUsers();
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
