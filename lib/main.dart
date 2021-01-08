import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class Memo {
  final String title;
  final String description;

  Memo(this.title, this.description);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Diary',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: MyHomePage(title: 'My Diary App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final memos = List<Memo>.generate(
  20,
      (i) => Memo(
    'Diary $i',
    '제목과 일기 내용이 나타나도록 할 예정',
  ),
);

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(itemCount: memos.length,
            itemBuilder: (context, index) {
          return Container(
              height: 80,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(todo: memos[index]),
                    ),
                  );
                },
                title: Text(memos[index].title,
                  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                ),

                subtitle: Text(
                  '날짜가 입력되도록 할 예정',
                  style: TextStyle(fontSize: 15.0),
                ),

                trailing: Icon(Icons.keyboard_arrow_right),
              ));
        }),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailDiaryPage()),
              );
            }));
  }
}

final titleInputController = TextEditingController();
final bodyInputController = TextEditingController();

class DetailDiaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Diary',
              style: TextStyle(
                fontSize: 24.0,
              )),
        ),
        body: Row(children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left:20.0, top:20.0, right:20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '제목'),
                        controller: titleInputController
                    )),
                Container(
                    margin: EdgeInsets.only(left:20.0, top:20.0, right:20.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '내용'),
                        controller: bodyInputController
                    ))
              ],
            ),
          )
        ]),
        floatingActionButton: FloatingActionButton
          (child: Icon(Icons.save, color: Colors.white),
    onPressed: () {
    // TextField에 적은 값을 가져와서, 메모 객체를 만든다
    Memo memo = new Memo(
      title: titleInputController.text,
      body: bodyInputController.text,
    );
    }));
  }
}

class DetailScreen extends StatelessWidget {
  final Memo todo;

  // 생성자 매개변수로 Todo를 받도록 강제합니다.
  DetailScreen({Key key, @required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // UI를 그리기 위해 Todo를 사용합니다.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(todo.description),
      ),
    floatingActionButton: FloatingActionButton(
    child: Icon(Icons.edit_rounded, color: Colors.white),
    ));
  }
}

  @override
  Widget build(BuildContext context) {
    // UI를 그리기 위해 Todo를 사용합니다.
    return Scaffold(
      appBar: AppBar(
        title: Text('memo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
