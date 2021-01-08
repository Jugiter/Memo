import 'dart:io';

import 'package:armemo/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'memo.dart';

final String databaseName = 'mymo.db';
final String tableName = 'memo';

class DatabaseHelper {

  // Singleton Pattern. 전역에 객체를 하나만 생성하도록
  DatabaseHelper._();  // 생성자를 객체 내부로 두어 외부에서 객체를 새로 생성하지 못하게
  static final DatabaseHelper _db = DatabaseHelper._();
  static Database _database;

  factory DatabaseHelper() => _db;

  Future<Database> get database async {
    if (_database == null) _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, databaseName);

    // Database 생성. 추후 데이터베이스를 변경하고 싶다면 version을 올리면 된다
    return await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          db.execute('''
            CREATE TABLE memo (
              id integer primary key autoincrement,
              title VARCHAR(255) not null,
              body TEXT,
              updatedAt DATETIME not null
            );
          ''');  // SQLite 설명을 한번 읽어보는 걸 추천드려요
        });
  }

  // Make notice this is VERY anti-pattern
  createMemo(Memo memo) async {  // Memo 객체를 받아와서 데이터베이스에 추가
    final db = await database;

    var res = await db.insert(tableName, memo.toMap());
    return res;
  }

  getMemo(int id) async {
    final db = await database;

    // id를 이용해서 특정 메모 객체를 받아오기
    // HINT: 이걸 잘 이용하면 "11월의 메모" 이런식으로 페이지를 구성할 수 있음
    var res = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Memo.fromMap(res.first) : Null;
  }

  Future<List<Memo>> getAllMemos() async {
    final db = await database;

    // 해당 테이블의 모든 메모를 가져오기 => 쿼리 조건을 입력하지 않으면 전체를 가져옴
    // 가장 마지막에 수정한 게 메모 위로 오게 하고 싶으므로, updatedAt으로 내림차순 정렬
    var res = await db.query(tableName, orderBy: 'updatedAt DESC');
    List<Memo> list =
    res.isNotEmpty ? res.map((c) => Memo.fromMap(c)).toList() : [];

    return list;
  }

  // 특정 ID를 가진 메모를 수정함 (덮어씀)
  updateMemo(Memo memo) async {
    final db = await database;
    var res = await db.update(tableName, memo.toMap(),
        where: 'id = ?', whereArgs: [memo.id]);

    return res;
  }

  // 특정 ID를 가진 메모를 삭제함
  deleteMemo(int id) async {
    final db = await database; db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}