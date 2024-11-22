import 'package:path/path.dart';
import 'package:privac/features/dashboard/data/models/notes_model.dart';
import 'package:privac/features/dashboard/data/models/update_security_model.dart';
import 'package:privac/features/profile/data/models/login_model.dart';
import 'package:privac/features/profile/data/models/profile_model.dart';
import 'package:privac/features/profile/data/models/security_profile_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();
  final uuid = const Uuid();

  // Membuat ID unik
  String generateUniqueId() {
    return uuid.v4(); // Versi 4 adalah UUID berbasis random
  }

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
    final path = join(databasePath, 'notes_database.db');

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
      'CREATE TABLE user(_id TEXT PRIMARY KEY, name TEXT, username TEXT, password TEXT, biomatric_id TEXT, face_id TEXT, fingerprint_id TEXT, tokens TEXT, is_admin TEXT, created_on TEXT, created_by TEXT, updated_on TEXT, updated_by TEXT)',
    );
    await db.execute(
      'CREATE TABLE notes(_id TEXT PRIMARY KEY, title TEXT, content TEXT, is_pin INTEGER, is_locked INTEGER, password TEXT, biomatric_id TEXT, face_id TEXT, fingerprint_id TEXT, tokens TEXT, created_id INTEGER, created_on TEXT, created_by TEXT, updated_on TEXT, updated_by TEXT)',
    );
  }

  // ! Profile

  Future<String> insertUser(ProfileModel dt) async {
    try {
      // Get a reference to the database.
      final db = await _databaseService.database;
      dt.id = generateUniqueId();

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
    List<Map<String, Object?>> result =
        await db.rawQuery('SELECT COUNT(*) AS count FROM user');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }

  // Fungsi untuk mengambil semua data user
  Future<int> getAdminUsers() async {
    final db = await database;
    // Mengambil semua data user dari tabel
    List<Map<String, Object?>> result = await db.query('user');
    int res = 0;
    for (var e in result) {
      if (e['is_admin'] != '') {
        if (e['password'] != '') {
          res = 1;
        } else if (e['fingerprint_id'] != '') {
          res = 2;
        }
      }
    }
    return res;
  }

  // Fungsi untuk mengambil semua data user
  Future<List<ProfileModel>> getUsers() async {
    // final db = await database;
    // Mengambil semua data user dari tabel
    // List<Map<String, Object?>> result = await db.query('user');
    // for (var e in result) {
    //   print(e['username']);
    //   print(e['password']);
    // }
    List<ProfileModel> res = [];

    return res;
  }

  // Fungsi untuk mengambil semua data user
  Future<List<ProfileModel>> getAllUsers() async {
    final db = await database;
    List<ProfileModel> list = [];
    // Mengambil semua data user dari tabel
    List<Map<String, Object?>> result = await db.query('user');
    for (var e in result) {
      list.add(
        ProfileModel(
          id: e['_id'].toString(),
          name: e['name'].toString(),
          username: e['username'].toString(),
          password: e['password'].toString(),
          biomatricId: e['biomatric_id'].toString(),
          faceId: e['face_id'].toString(),
          fingerprintId: e['fingerprint_id'].toString(),
          tokens: e['tokens'].toString(),
          isAdmin: e['is_admin'].toString(),
          createdBy: e['created_by'].toString(),
          createdOn: DateTime.parse(e['created_on'].toString()),
          updatedBy: e['updated_by'].toString(),
          updatedOn: DateTime.parse(e['updated_on'].toString()),
        ),
      );
    }
    return list;
  }

  Future<String> updateSecurityProfile(
      String id, nameId, SecurityProfileModel dt) async {
    try {
      final db = await database;
      final updatedData = <String, dynamic>{
        'password': dt.password,
        'fingerprint_id': dt.fingerprint,
        'updated_on': DateTime.now().toString(),
        'updated_by': nameId,
      };
      final result = await db.update(
        'user',
        updatedData, // Hanya mengirim kolom yang ingin diperbarui
        where: '_id = ?', // Kriteria pemilihan data berdasarkan id
        whereArgs: [id], // Nilai untuk kriteria
      );
      if (result > 0) {
        return 'Update Keamanan Berhasil';
      } else {
        return 'Update Keamanan Gagal';
      }
    } catch (e) {
      return 'Error $e';
    }
  }

  // Fungsi untuk login
  Future<List<ProfileModel>> login(LoginModel data) async {
    final db = await database;
    // Mengambil semua data user dari tabel
    List<Map<String, Object?>> result = await db.query(
      'user',
      where: 'username = ? AND password = ?',
      // Menyediakan username dan password untuk pencocokan
      whereArgs: [data.username, data.password],
    );
    List<ProfileModel> profile = [];
    // Jika data ditemukan
    if (result.isNotEmpty) {
      for (var e in result) {
        Map<String, Object?> userData = e;
        ProfileModel dt = ProfileModel.fromMap(userData);
        profile.add(dt);
      }
      // Mengembalikan data Profile
      return profile;
    } else {
      // Jika tidak ditemukan, kembalikan null atau handle sesuai kebutuhan
      return profile;
    }
  }

  // ! Dashboard

  Future<String> insertNotes(NotesModel dt) async {
    try {
      // Get a reference to the database.
      final db = await _databaseService.database;
      dt.id = generateUniqueId();
      await db.insert(
        'notes',
        dt.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return 'Success';
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Fungsi untuk mengambil semua data notes
  Future<List<NotesModel>> getAllNote() async {
    final db = await database;
    List<NotesModel> res = [];
    List<Map<String, Object?>> result = await db.query('notes');
    for (var e in result) {
      res.add(
        NotesModel(
          id: e['_id'].toString(),
          title: e['title'].toString(),
          content: e['content'].toString(),
          isPin: int.parse(e['is_pin'].toString()),
          isLocked: int.parse(e['is_locked'].toString()),
          password: e['password'].toString(),
          biomatricId: e['biomatric_id'].toString(),
          faceId: e['face_id'].toString(),
          fingerprintId: e['fingerprint_id'].toString(),
          tokens: e['tokens'].toString(),
          createdId: e['created_id'].toString(),
          createdOn: DateTime.parse(e['created_on'].toString()),
          createdBy: e['created_by'].toString(),
          updatedOn: DateTime.parse(e['updated_on'].toString()),
          updatedBy: e['updated_by'].toString(),
        ),
      );
    }
    return res;
  }

  Future<String> updateNotes(NotesModel updatedNote) async {
    try {
      final db = await database;
      final result = await db.update(
        'Notes',
        updatedNote.toMap(),
        where: '_id = ?',
        whereArgs: [updatedNote.id],
      );
      if (result > 0) {
        return 'Update Berhasil';
      } else {
        return 'Update Gagal';
      }
    } catch (e) {
      return 'Error $e';
    }
  }

  Future<String> updatePinNotes(String id, int pin, nameId) async {
    try {
      final db = await database;
      final updatedData = <String, dynamic>{
        'is_pin': pin,
        'updated_on': DateTime.now().toString(),
        'updated_by': nameId,
      };
      final result = await db.update(
        'Notes',
        updatedData, // Hanya mengirim kolom yang ingin diperbarui
        where: '_id = ?', // Kriteria pemilihan data berdasarkan id
        whereArgs: [id], // Nilai untuk kriteria
      );
      if (result > 0) {
        return 'Update Pin Berhasil';
      } else {
        return 'Update Pin Gagal';
      }
    } catch (e) {
      return 'Error $e';
    }
  }

  Future<String> updatePasswordNotes(UpdateSecurityModel save, nameId) async {
    try {
      final db = await database;
      final updatedData = <String, dynamic>{
        'password': save.password,
        'biomatric_id': save.biomatricId,
        'fingerprint_id': save.fingerprintId,
        'face_id': save.faceId,
        'tokens': save.tokens,
        'updated_on': DateTime.now().toString(),
        'updated_by': nameId,
      };
      final result = await db.update(
        'Notes',
        updatedData, // Hanya mengirim kolom yang ingin diperbarui
        where: '_id = ?', // Kriteria pemilihan data berdasarkan id
        whereArgs: [save.id], // Nilai untuk kriteria
      );
      if (result > 0) {
        return 'Update Berhasil';
      } else {
        return 'Update Gagal';
      }
    } catch (e) {
      return 'Error $e';
    }
  }

  deleteNotes(int id) async {
    final db = await database;
    await db.delete('Notes', where: '_id = ?', whereArgs: [id]);
  }
}
