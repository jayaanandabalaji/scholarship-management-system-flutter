import 'package:json_annotation/json_annotation.dart';
part 'applications.g.dart';

@JsonSerializable()
class application {
  final String userId;
  final String scholarshipId;
  final String name;
  application(
      {required this.userId, required this.scholarshipId, required this.name});
  factory application.fromJson(Map<String, dynamic> json) =>
      _$applicationFromJson(json);

  Map<String, dynamic> toJson() => _$applicationToJson(this);
}
