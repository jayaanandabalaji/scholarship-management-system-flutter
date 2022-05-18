import 'package:json_annotation/json_annotation.dart';
part 'scholarship.g.dart';

@JsonSerializable()
class scholarship {
  final String imageUrl;
  final String title;
  final description;
  final String applicationDeadline;
  final String organization;
  final String organizationId;
  scholarship(
      {required this.imageUrl,
      required this.applicationDeadline,
      required this.description,
      required this.title,
      required this.organization,
      required this.organizationId});

  factory scholarship.fromJson(Map<String, dynamic> json) =>
      _$scholarshipFromJson(json);

  Map<String, dynamic> toJson() => _$scholarshipToJson(this);
}
