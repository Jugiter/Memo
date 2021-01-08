import 'package:equatable/equatable.dart';
import 'package:armemo/db.dart';

class Memo extends Equatable{
  int id;
  String title;
  String body;
  DateTime updatedAt;

  Memo({this.id, this.title, this.body, this.updatedAt});

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
  factory Memo.fromMap(Map<String, dynamic> data) => new Memo(
    id: data["id"],
    title: data["title"],
    body: data["body"],
    updatedAt: DateTime.parse(data["updatedAt"]),
  );

}