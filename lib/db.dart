import 'dart:io';

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sqflite/sqflite.dart';
import 'package:armemo/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:armemo/memo.dart';

final String databaseName = 'memo.db';
final String tableName = 'memo';

class DatabaseHelper {

  // Singleton Pattern. 전역에 객체를 하나만 생성하도록
  DatabaseHelper._();  // 생성자를 객체 내부로 두어 외부에서 객체를 새로 생성하지 못하게
  static final DatabaseHelper _db = DatabaseHelper._();

  CollectionReference collection = FirebaseFirestore.instance.collection("diary");
  factory DatabaseHelper() => _db;

  // Make notice this is VERY anti-pattern
  createMemo(Memo memo) async {  // Memo 객체를 받아와서 데이터베이스에 추가
    collection.add({
      'title': memo.title,
      'body': memo.body,
      'updatedAt': Timestamp.now(),
    });
  }

  getMemo(String id) async {
    DocumentSnapshot snapshot = await collection.doc(id).get();
    Map<String, dynamic> data = snapshot.data();

    return Memo(
        id: snapshot.id,
        title: data['title'],
        body: data['body'],
        updatedAt: data['updatedAt'].toDate()
    );
  }

  Future<List<Memo>> getAllMemos() async {
    var snapshot = await collection.get();
    List<QueryDocumentSnapshot> values = snapshot.docs;

    List<Memo> list = List<Memo>();
    for(var i=0; i < values.length; i++) {
      Map<String, dynamic> data = values[i].data();

      list.add(
          Memo(
              id: values[i].id,
              title: data['title'],
              body: data['body'],
              updatedAt: data['updatedAt'].toDate()
          )
      );
    }

    // 해당 테이블의 모든 메모를 가져오기 => 쿼리 조건을 입력하지 않으면 전체를 가져옴
    // 가장 마지막에 수정한 게 메모 위로 오게 하고 싶으므로, updatedAt으로 내림차순 정렬

    return list;
  }

  // 특정 ID를 가진 메모를 수정함 (덮어씀)
  updateMemo(Memo memo) async {
    collection.doc(memo.id).update({
      'title': memo.title,
      'body': memo.body,
      'updatedAt': Timestamp.now(),
    });
  }

  // 특정 ID를 가진 메모를 삭제함
  deleteMemo(String id) async {
    collection.doc(id).delete();
  }
}