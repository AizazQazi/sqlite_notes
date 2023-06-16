import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_notes/notes.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    Database db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE notes(id INTEGER PRIMARY KEY ,title TEXT NOT NULL,age INTEGER NOT NULL,email TEXT,description TEXT NOT NULL )"
    );


  }

  Future<notesmodel> insert(notesmodel notesModel) async {
    var dbclient = await db;

    await dbclient?.insert('notes', notesModel.toMap());
    print(notesModel.description);
    return notesModel;
  }
  Future<List<notesmodel>?>getnodesList() async{
    var  dbclient=await db;
    List<Map<String, Object?>>?queryresult=await dbclient?.query('notes');
    return queryresult?.map((e) => notesmodel.fromMap(e)).toList();
  }
  Future<int?> delete(int id)async{
    var dbclient=await db;
    return await dbclient!.delete(
      'notes',
      where: 'id=?',
      whereArgs: [id]
    );


  }
}
