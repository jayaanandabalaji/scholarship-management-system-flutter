import 'package:json_annotation/json_annotation.dart';
part 'students.g.dart';

@JsonSerializable()
class Students {
  final String name;
  final String income;
  final int age;
  final id;
  final userProfileUrl;
  Students(
      {required this.name,
      required this.age,
      required this.income,
      required this.id,
      required this.userProfileUrl});
  factory Students.fromJson(Map<String, dynamic> json) =>
      _$StudentsFromJson(json);

  Map<String, dynamic> toJson() => _$StudentsToJson(this);
}
