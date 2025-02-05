import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:throw_your_phone/models/throw_entry.dart';
import 'throw_repository.dart';

class SQLThrowRepository extends ThrowRepository {
  static const String _tableName = 'throw_entries';
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'throws.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            distance REAL NOT NULL,
            height REAL NOT NULL,
            date_time DATETIME NOT NULL,
            username VARCHAR NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<ThrowEntry> addThrow(ThrowEntry throwEntry) async {
    final db = await database;
    int id = await db.insert(_tableName, throwEntry.toMap());

    return throwEntry.copyWith(id: id);
  }

  @override
  Future<ThrowEntry> get(id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ThrowEntry.fromMap(maps.first);
    } else {
      throw Exception('ThrowEntry with id $id not found');
    }
  }

  @override
  Future<List<ThrowEntry>> getThrows() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(
      maps.length,
      (i) => ThrowEntry.fromMap(maps[i]),
    );
  }

  @override
  Future remove(ThrowEntry throwEntry) async {
    final db = await database;
    if (throwEntry.id == null) {
      throw Exception('Cannot remove a ThrowEntry without an id');
    }
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [throwEntry.id],
    );
  }
}
