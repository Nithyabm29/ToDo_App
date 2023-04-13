import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'note.dart';

class DatabaseHelper {
  static DatabaseHelper? _dbHelper; //singleton database helper
  static Database? _database; // Singleton database

  String noteTable = 'note_Table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper.createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    //factory allow to return some values
    _dbHelper = DatabaseHelper.createInstance();
    return _dbHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }
  Future<Database> initializeDatabase() async {
    //get the directory path
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}notes.db';
    //Create DB at the given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }
  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  //Fetch Operation
  Future<List<Map<String, dynamic>>> getMapNoteList() async {
    Database db = await database;
    var result =
        await db.query(noteTable, orderBy: '$colPriority DESC');
    return result;
  }

  //Insert operation
  Future<int> insertNote(Note note) async {
    var db = await database;
    var res =await db.insert(noteTable, note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  //Update operation
  Future<int> updateNote(Note note) async {
    Database db = await database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId=?', whereArgs: [note.id]);
    return result;
  }

  //Delete operation
  Future<int> deleteNote(int id) async {
    var db = await database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId=$id');
    return result;
  }

  //Get number of note objects in database
  Future<int?> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) from $noteTable');
    var result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async{
    var noteMapList = await getMapNoteList();
    int count = noteMapList.length;
    List<Note> noteList = <Note>[];
    for(int i=0; i<count;i++){
      noteList.add(Note.fromMap(noteMapList[i]));
    }
    return noteList;
  }
}
