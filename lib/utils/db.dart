import 'dart:developer';

import '../domains/memo.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final String collectionName = 'diary';

class DatabaseHelper {

  DatabaseHelper._();
  static final DatabaseHelper _db = DatabaseHelper._();

  CollectionReference collection = FirebaseFirestore.instance.collection(collectionName);
  factory DatabaseHelper() => _db;

  createDiary(Diary diary) async {
    collection.add({
      'title': diary.title,
      'body': diary.body,
      'updatedAt': Timestamp.now(),
    });
  }

  getDiary(String id) async {
    DocumentSnapshot snapshot = await collection.doc(id).get();
    Map<String, dynamic> data = snapshot.data();

    return Diary(
        id: snapshot.id,
        title: data['title'],
        body: data['body'],
        updatedAt: data['updateAt'].toDate()
    );
  }

  Future<List<Diary>> getAllDiaries() async {
    var snapshot = await collection.get();
    List<QueryDocumentSnapshot> values = snapshot.docs;

    List<Diary> list = List<Diary>();
    for(var i=0; i<values.length; i++) {
      Map <String, dynamic> data = values[i].data();

      list.add(
          Diary(
              id: values[i].id,
              title: data['title'],
              body: data['body'],
              updatedAt: data['updatedAt'].toDate()
          )
      );
    }

    return list;
  }

  updateDiary(Diary diary) async {
    collection.doc(diary.id).update({
      'title': diary.title,
      'body': diary.body,
      'updatedAt': Timestamp.now(),
    });
  }

  deleteDiary(String id) async {
    collection.doc(id).delete();
  }
}