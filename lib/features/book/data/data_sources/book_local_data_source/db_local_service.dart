import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../models/book_model.dart';

class FavoriteDatabaseHelper {
  static final FavoriteDatabaseHelper _instance =
      FavoriteDatabaseHelper._internal();
  static Database? _database;

  factory FavoriteDatabaseHelper() => _instance;

  FavoriteDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id TEXT PRIMARY KEY,
            title TEXT,
            authors TEXT,
            thumbnail TEXT
          )
        ''');
      },
    );
  }

  Future<List<BookModel>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('favorites');

    // Convert the list of maps into a List<BookModel>
    return result.map((map) => BookModel.fromMap(map)).toList();
  }

  Future<void> addFavorite(BookModel book) async {
    final db = await database;
    await db.insert(
      'favorites',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String bookId) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [bookId]);
  }

  Future<bool> isFavorite(String bookId) async {
    final db = await database;
    final result =
        await db.query('favorites', where: 'id = ?', whereArgs: [bookId]);
    return result.isNotEmpty;
  }
}
