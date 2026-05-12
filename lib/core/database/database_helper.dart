import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CalculationEntry {
  final int? id;
  final String type;
  final Map<String, dynamic> inputs;
  final Map<String, dynamic> result;
  final DateTime createdAt;

  CalculationEntry({
    this.id,
    required this.type,
    required this.inputs,
    required this.result,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'inputs': jsonEncode(inputs),
      'result': jsonEncode(result),
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CalculationEntry.fromMap(Map<String, dynamic> map) {
    return CalculationEntry(
      id: map['id'] as int?,
      type: map['type'] as String,
      inputs: jsonDecode(map['inputs'] as String) as Map<String, dynamic>,
      result: jsonDecode(map['result'] as String) as Map<String, dynamic>,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'inductor_coil_calculator.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE calculations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        inputs TEXT NOT NULL,
        result TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertCalculation(CalculationEntry entry) async {
    final db = await database;
    return await db.insert('calculations', entry.toMap());
  }

  Future<List<CalculationEntry>> getAllCalculations() async {
    final db = await database;
    final maps = await db.query(
      'calculations',
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => CalculationEntry.fromMap(map)).toList();
  }

  Future<List<CalculationEntry>> getCalculationsByType(String type) async {
    final db = await database;
    final maps = await db.query(
      'calculations',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => CalculationEntry.fromMap(map)).toList();
  }

  Future<int> deleteCalculation(int id) async {
    final db = await database;
    return await db.delete(
      'calculations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllCalculations() async {
    final db = await database;
    return await db.delete('calculations');
  }
}
