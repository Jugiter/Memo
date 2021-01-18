import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/db.dart';

import '../domains/memo.dart';

class CreateDiaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CreateDiaryWidget();
  }
}

class CreateDiaryWidget extends StatefulWidget {
  @override
  _CreateDiaryState createState() => _CreateDiaryState();
}

class _CreateDiaryState extends State<CreateDiaryWidget>{
  final titleInputController = TextEditingController();
  final bodyInputController = TextEditingController();

  @override
  void dispose() {
    this.titleInputController.dispose();
    this.bodyInputController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Diary',
              style: TextStyle(
                fontSize: 24.0,
              )),
        ),
        body: Padding(
          padding: EdgeInsets.all(6.0),
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top:20.0, bottom: 20.0),
                    child: TextField(

                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: '제목',
                      ),
                      controller: this.titleInputController,
                    )),
                Container(
                    margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '내용',
                      ),
                      controller: this.bodyInputController,
                    ))
              ])),
        floatingActionButton: FloatingActionButton
          (child: Icon(Icons.save, color: Colors.white),
            onPressed: () {
              Diary diary = new Diary(
                title: titleInputController.text,
                body: bodyInputController.text,
                updatedAt: DateTime.now());

              DatabaseHelper().createDiary(diary); // 데이터베이스에 메모 객체를 추가한다
              Navigator.pop(context);
            },
            ));
  }
}

