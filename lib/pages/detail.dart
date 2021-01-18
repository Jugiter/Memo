import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/edit.dart';

import '../domains/memo.dart';

class DetailDiaryPage extends StatelessWidget {
  final Diary diary;

  DetailDiaryPage({Key key, @required this.diary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailDiaryWidget(diary: this.diary);
  }
}

class DetailDiaryWidget extends StatefulWidget {
  final Diary diary;

  const DetailDiaryWidget({Key key, this.diary}) : super(key: key);

  @override
  _DetailDiaryState createState() => _DetailDiaryState(this.diary);
}

class _DetailDiaryState extends State<DetailDiaryWidget> {
  final Diary diary;

  _DetailDiaryState(this.diary);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Diary',
            style: TextStyle(fontSize: 24.0, color: Colors.white)),
      ),
      body: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  this.diary.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                child: Text(
                  this.diary.updatedAt.toIso8601String(),
                  style: TextStyle(color: Colors.grey),
                )),
            Text(this.diary.body),
          ])),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _editPage(context);
          },
          tooltip: '일기 업데이트하기',
          child: Icon(Icons.edit, color: Colors.white)),
    );
  }

  _editPage(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditDiaryPage(diary: this.diary)));
    setState(() {});
  }
}
