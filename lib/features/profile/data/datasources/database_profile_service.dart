import 'package:path/path.dart';
import 'package:privac/features/profile/data/models/login_model.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProfileService {
  // Singleton pattern
  static final DatabaseProfileService _databaseProfile =
      DatabaseProfileService._internal();
  factory DatabaseProfileService() => _databaseProfile;
  DatabaseProfileService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'profile_sqflite_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store user
  // and a table to store users.
  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {user} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, username TEXT, password TEXT, biomatric_id TEXT, face_id TEXT, primary_key TEXT, created_on TEXT, created_by TEXT, updated_on TEXT, updated_by TEXT)',
    );
  }

  Future<String> insertUser(ProfileModel dt) async {
    try {
      // Get a reference to the database.
      final db = await _databaseProfile.database;

      // Insert the ProfileSaveModel data into the 'user' table
      await db.insert(
        'user',
        dt.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return 'Success';
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Fungsi untuk mengecek apakah tabel kosong atau tidak
  Future<bool> isUserTableEmpty() async {
    final db = await database;

    // Menghitung jumlah baris dalam tabel user
    List<Map<String, Object?>> result =
        await db.rawQuery('SELECT COUNT(*) FROM user');
    return result.isNotEmpty;
  }

  // Fungsi untuk mengambil semua data user
  Future<List<ProfileModel>> getAllUsers() async {
    final db = await database;
    // Mengambil semua data user dari tabel
    List<Map<String, Object?>> result = await db.query('user');
    for (var e in result) {
      print(e['username']);
      print(e['password']);
    }
    List<ProfileModel> res = [];

    return res;
  }

  // Fungsi untuk login
  Future<ProfileModel> login(LoginModel data) async {
    final db = await database;
    // Mengambil semua data user dari tabel
    List<Map<String, Object?>> result = await db.query(
      'user',
      where: 'username = ? AND password = ?',
      // Menyediakan username dan password untuk pencocokan
      whereArgs: [data.username, data.password],
    );
    ProfileModel profile = ProfileModel();
    // Jika data ditemukan
    if (result.isNotEmpty) {
      // Menyusun data hasil query ke dalam model Profile
      Map<String, Object?> userData =
          result.first; // Ambil data pertama yang ditemukan
      profile = ProfileModel.fromMap(userData);

      // Mengembalikan data Profile
      return profile;
    } else {
      // Jika tidak ditemukan, kembalikan null atau handle sesuai kebutuhan
      return profile;
    }
  }
}
