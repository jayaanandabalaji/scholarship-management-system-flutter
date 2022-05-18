// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

application _$applicationFromJson(Map<String, dynamic> json) => application(
      userId: json['userId'] as String,
      scholarshipId: json['scholarshipId'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$applicationToJson(application instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'scholarshipId': instance.scholarshipId,
      'name': instance.name,
    };
