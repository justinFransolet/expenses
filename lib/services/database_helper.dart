import 'package:expenses/models/expense.dart';
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
    // TODO: Create expenses table (with id as autoincrement primary key, and all fields non-nullable)
  }

  Future<int> create(Expense expense) async {
    final db = await instance.database;
    return db.insert('expenses', expense.toMap());
  }

  Future<void> delete(int i) async {
    // TODO: implement delete method
  }

  Future<List<Expense>> readAllExpenses() async {
    // TODO: read all expenses from the database
    return [];
  }

  Future<void> update(Expense expense) async {
    // TODO: update expense
  }
}
