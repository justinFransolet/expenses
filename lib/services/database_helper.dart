import 'package:expenses/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category INTEGER NOT NULL
      )
    ''');
  }

  /// Insère et renvoie l'id inséré.
  Future<int> create(Expense expense) async {
    debugPrint('Inserting expense: ${expense.toMap()}');
    final db = await instance.database;
    final expenseMap = expense.toMap()..remove('id');
    return await db.insert('expenses', expenseMap);
  }

  Future<void> delete(int i) async {
    final db = await instance.database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [i],
    );
  }

  Future<List<Expense>> readAllExpenses() async {
    final db = await instance.database;
    final maps = await db.query('expenses', orderBy: 'id DESC');
    return maps.map((m) => Expense.fromMap(m)).toList();
  }

  /// Met à jour et renvoie le nombre de lignes affectées.
  Future<int> update(Expense expense) async {
    if (expense.id == null) {
      throw ArgumentError('Cannot update an expense without an id.');
    }
    final db = await instance.database;
    final values = Map<String, dynamic>.from(expense.toMap())..remove('id');
    return await db.update(
      'expenses',
      values,
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  /// Upsert : insère si `id` est null, sinon tente une update.
  /// Retourne l'id de la dépense insérée ou l'id existant si update OK.
  Future<int> save(Expense expense) async {
    if (expense.id == null) {
      return await create(expense);
    }
    final updatedCount = await update(expense);
    if (updatedCount == 0) {
      // si update n'a rien modifié, insérer et récupérer l'id
      return await create(expense);
    }
    return expense.id!;
  }
}
