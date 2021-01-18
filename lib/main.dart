import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'utils/db.dart';

import 'pages/newcreate.dart';
import 'pages/detail.dart';
import 'domains/memo.dart';


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
          toolbarHeight: 70,
          title: Text(widget.title,
            style: TextStyle(fontSize:28.0, color: Colors.white)),
        ),
        body: FutureBuilder<List<Diary>>(
            future: DatabaseHelper().getAllDiaries(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Diary>> snapshot) {
              if (!snapshot.hasData) return Center();

              return snapshot.data.length > 0
                  ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Diary item = snapshot.data[index];
                    log("item index $index");

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
                  : Container(
                    child: Center(
                      child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        (Text("일기장이 비어있어요!",
                            style: TextStyle(color: Colors.grey, fontSize: 20)))
                      ])));
            }),
        floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.add, color: Colors.white),
            label: Text('일기 쓰기', style: TextStyle(color: Colors.white)),
            tooltip: '오늘의 일기를 남겨요',
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

  _deleteDiary(String diaryId) async {
    await DatabaseHelper().deleteDiary(diaryId);

    setState(() {});
  }

  _detailDiaryPage(BuildContext context, Diary diary) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailDiaryPage(diary: diary)));

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