import 'package:equatable/equatable.dart';
import '../utils/db.dart';

class Diary extends Equatable{
  String id;
  String title;
  String body;
  DateTime updatedAt;

  Diary({this.id, this.title, this.body, this.updatedAt});

  @override
  List<Object> get props => [id];

  // Memo 객체를 데이터베이스에 저장할 수 있게 변경
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'body': this.body,
      'updatedAt': this.updatedAt.toIso8601String(),
    };
  }

  // 데이터베이스에 저장된 메모를 객체로 변환
  factory Diary.fromMap(Map<String, dynamic> data) => new Diary(
    id: data["id"],
    title: data["title"],
    body: data["body"],
    updatedAt: DateTime.parse(data["updatedAt"]),
  );

//여기부터 데베.. ?
@override
String toString() {
  String id = this.id;
  String title = this.title;
  return "$id : $title";
}
}