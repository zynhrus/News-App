import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:newsapp/model/favorite.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "FavoriteDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Favorite ("
          "urlToImage TEXT ,"
          "publishedAt TEXT,"
          "author TEXT,"
          "url TEXT PRIMARY KEY,"
          "title TEXT"
          ")");
    });
  }

  newFavorite(Favorite newFavorite) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into Favorite (urlToImage,publishedAt,author,url,title)"
        " VALUES (?,?,?,?,?)",
        [
          newFavorite.urlToImage,
          newFavorite.publishedAt,
          newFavorite.author,
          newFavorite.url,
          newFavorite.title
        ]);
    print(newFavorite.author);
    return raw;
  }

  Future<List<Favorite>> getAllFavorites() async {
    final db = await database;
    var res = await db.query("Favorite");
    List<Favorite> list =
        res.isNotEmpty ? res.map((c) => Favorite.fromMap(c)).toList() : [];
    return list;
  }

  deleteFavorite(String url) async {
    final db = await database;
    return db.delete("Favorite", where: "url = ?", whereArgs: [url]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from Favorite");
  }
}
