import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../domains/memo.dart';
import '../utils/db.dart';

class EditDiaryPage extends StatelessWidget {
  final Diary diary;

  EditDiaryPage({Key key, @required this.diary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditDiaryWidget(diary: diary);
  }
}

class EditDiaryWidget extends StatefulWidget {
  final Diary diary;

  EditDiaryWidget({@required this.diary});

  @override
  _EditDiaryState createState() => _EditDiaryState(diary: diary);
}

class _EditDiaryState extends State<EditDiaryWidget> {
  TextEditingController titleInputController;
  TextEditingController bodyInputController;

  final Diary diary;

  _EditDiaryState({@required this.diary});

  @override
  void initState() {
    super.initState();

    this.titleInputController = TextEditingController(text: diary.title);
    this.bodyInputController = TextEditingController(text: diary.body);
  }

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
            style: TextStyle(fontSize: 24.0, color: Colors.white)),
      ),
      body: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(children: [
            Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                  controller: this.titleInputController,
                )),
            TextField(
              decoration: InputDecoration(
                hintText: 'Content',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: this.bodyInputController,
            ),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          this.diary.title = titleInputController.text;
          this.diary.body = bodyInputController.text;
          this.diary.updatedAt = DateTime.now();

          DatabaseHelper().updateDiary(this.diary);
          Navigator.pop(context);
        },
        tooltip: '새 일기',
        child: Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}

