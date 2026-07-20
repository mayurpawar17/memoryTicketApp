import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/memory_model.dart';

abstract class MemoryLocalDataSource {
  Future<List<MemoryModel>> getMemories();
  Future<void> saveMemory(MemoryModel memory);
  Future<void> deleteMemory(String id);
  Future<void> updateFavorite(String id, bool isFavorite);
}

class MemoryLocalDataSourceImpl implements MemoryLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'memories.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE memories(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            location TEXT,
            date TEXT,
            imagePath TEXT,
            category TEXT,
            isFavorite INTEGER
          )
        ''');
      },
    );
  }

  @override
  Future<List<MemoryModel>> getMemories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('memories');
    return maps.map((map) => MemoryModel.fromMap(map)).toList();
  }

  @override
  Future<void> saveMemory(MemoryModel memory) async {
    final db = await database;
    await db.insert(
      'memories',
      memory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteMemory(String id) async {
    final db = await database;
    await db.delete('memories', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> updateFavorite(String id, bool isFavorite) async {
    final db = await database;
    await db.update(
      'memories',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
