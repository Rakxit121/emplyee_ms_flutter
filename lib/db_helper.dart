import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/employee_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'employee_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Employee Table
    await db.execute('''
   CREATE TABLE employees (
    id TEXT PRIMARY KEY,
    name TEXT,
    gender TEXT,
    phone TEXT,
    address TEXT,
    profile_pic TEXT,
    level INTEGER,
    salary REAL,
    status TEXT
   )
  ''');

    // Create Qualification Table if needed
  }

  // Insert Employee into DB
  Future<void> insertEmployee(Employee employee) async {
    final db = await database;
    await db?.insert(
      'employees',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get All Employees from DB
  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> employeeMaps =
        await db!.query('employees');

    return List.generate(employeeMaps.length, (i) {
      return Employee.fromMap(employeeMaps[i]);
    });
  }

  // Update Employee in DB
  Future<void> updateEmployee(Employee employee) async {
    final db = await database;
    await db?.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  // Delete Employee from DB
  Future<void> deleteEmployee(String id) async {
    final db = await database;
    await db?.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  
}


