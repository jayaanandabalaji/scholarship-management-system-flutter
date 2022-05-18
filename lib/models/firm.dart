import 'package:json_annotation/json_annotation.dart';
part 'firm.g.dart';

@JsonSerializable()
class Firm {
  final String firmName;
  final id;
  Firm({required this.firmName, required this.id});

  factory Firm.fromJson(Map<String, dynamic> json) => _$FirmFromJson(json);

  Map<String, dynamic> toJson() => _$FirmToJson(this);
}
