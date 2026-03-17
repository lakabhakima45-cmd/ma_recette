import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ma_recette.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE recipes(
      id TEXT PRIMARY KEY,
      name TEXT,
      image TEXT,
      time INTEGER,
      difficulty TEXT,
      dietType TEXT,
      categoryId TEXT,
      calories INTEGER,
      protein INTEGER,
      carbs INTEGER,
      fat INTEGER,
      ingredients TEXT,
      steps TEXT
    )
    ''');
  }

  Future<void> insertRecipe(Map<String, dynamic> recipe) async {
    final db = await instance.database;

    await db.insert(
      'recipes',
      recipe,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getRecipes() async {
    final db = await instance.database;

    final result = await db.query('recipes');

    return result;
  }

  Future<void> deleteRecipe(String id) async {
    final db = await instance.database;

    await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}