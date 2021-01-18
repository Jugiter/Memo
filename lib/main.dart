import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:armemo/db.dart';
import 'package:armemo/memo.dart';

void main() {
  runApp(MyApp());
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: FutureBuilder<List<Memo>>(
            future: DatabaseHelper().getAllMemos(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Memo>> snapshot) {
              if (!snapshot.hasData) return Center();

              return snapshot.data.length > 0
                  ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Memo item = snapshot.data[index];

                    var formatDateTime =
                    DateFormat('yyyy-MM-dd').format(item.updatedAt);

                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: ListTile(
                        title: Text(item.title,
                            style: TextStyle(fontSize: 18)),
                        subtitle: Text(formatDateTime + '  ' + item.body,
                            style: TextStyle(
                                color: Colors.grey.withOpacity(0.8)),
                            maxLines: 1),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () {
                          _detailDiaryPage(context, item);
                        },
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              _deleteDiary(item.id);
                            })
                      ],
                    );
                  })
                  : Container(child: Center(
                      child: Column(children: <Widget>[
                        (Text("일기장이 비어있어요!",
                            style: TextStyle(color: Colors.grey, fontSize: 20)))
                      ])));
            }),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _createDiaryPage(context);
            }));
  }

  _createDiaryPage(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateDiaryPage()));

    setState(() {});
  }

  _deleteDiary(String memoId) async {
    await DatabaseHelper().deleteMemo(memoId);

    setState(() {});
  }

  _detailDiaryPage(BuildContext context, Memo memo) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailDiaryPage(memo: memo)));

    setState(() {});
  }
}

class MyDiaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Diary',
              style: TextStyle(fontSize: 24.0, color: Colors.white)),
        ),
        body: Row(children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        //border: OutlineInputBorder(),
                        hintText: '제목',
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        //border: OutlineInputBorder(),
                        hintText: '내용',
                      ),
                    ))
              ],
            ),
          )
        ]),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.check, color: Colors.white)));
  }
}

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
        body: Row(children: <Widget>[
          Flexible(
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                    child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '제목'),
                        controller: this.titleInputController
                    )),
                Container(
                    margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                    child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '내용'),
                        controller: this.bodyInputController
                    ))
              ],
            ),
          )
        ]),
        floatingActionButton: FloatingActionButton
          (child: Icon(Icons.save, color: Colors.white),
            onPressed: () {
              Memo memo = new Memo(
                title: titleInputController.text,
                body: bodyInputController.text,
                updatedAt: DateTime.now(),
              );

              DatabaseHelper().createMemo(memo); // 데이터베이스에 메모 객체를 추가한다
              Navigator.pop(context);

              // TODO: onPress 시 데이터베이스에 메모를 추가할 것
            }));
  }
}

class DetailDiaryPage extends StatelessWidget {
  final Memo memo;

  DetailDiaryPage({Key key, @required this.memo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailDiaryWidget(memo: this.memo);
  }
}

class DetailDiaryWidget extends StatefulWidget {
  final Memo memo;

  const DetailDiaryWidget({Key key, this.memo}) : super(key: key);

  @override
  _DetailDiaryState createState() => _DetailDiaryState(this.memo);
}

class _DetailDiaryState extends State<DetailDiaryWidget> {
  final Memo memo;

  _DetailDiaryState(this.memo);

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
                child: Text(
                  this.memo.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                child: Text(
                  this.memo.updatedAt.toIso8601String(),
                  style: TextStyle(color: Colors.grey),
                )),
            Text(this.memo.body),
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
            builder: (context) => EditDiaryPage(memo: this.memo)));
    setState(() {});
  }
}

class EditDiaryPage extends StatelessWidget {
  final Memo memo;

  EditDiaryPage({Key key, @required this.memo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditDiaryWidget(memo: memo);
  }
}

class EditDiaryWidget extends StatefulWidget {
  final Memo memo;

  EditDiaryWidget({@required this.memo});

  @override
  _EditDiaryState createState() => _EditDiaryState(memo: memo);
}

class _EditDiaryState extends State<EditDiaryWidget> {
  TextEditingController titleInputController;
  TextEditingController bodyInputController;

  final Memo memo;

  _EditDiaryState({@required this.memo});

  @override
  void initState() {
    super.initState();

    this.titleInputController = TextEditingController(text: memo.title);
    this.bodyInputController = TextEditingController(text: memo.body);
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
          this.memo.title = titleInputController.text;
          this.memo.body = bodyInputController.text;
          this.memo.updatedAt = DateTime.now();

          DatabaseHelper().updateMemo(this.memo);
          Navigator.pop(context);
        },
        tooltip: '새 일기',
        child: Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}

