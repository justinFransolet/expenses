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

  Future<void> create(Expense expense) async {
    debugPrint('Inserting expense: ${expense.toMap()}');
    final db = await instance.database;
    await db.insert('expenses', expense.toMap());
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
    final maps = await db.query('expenses');
    return maps.map((m) => Expense.fromMap(m)).toList();
  }

  Future<void> update(Expense expense) async {
    if (expense.id == null) {
      throw ArgumentError('Cannot update an expense without an id.');
    }
    final db = await instance.database;
    final values = Map<String, dynamic>.from(expense.toMap())..remove('id');
    await db.update(
      'expenses',
      values,
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> save(Expense expense) async {
    if (expense.id == null) {
      await create(expense);
    }
    await update(expense);
  }
}
