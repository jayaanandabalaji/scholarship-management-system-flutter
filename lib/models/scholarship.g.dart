// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scholarship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

scholarship _$scholarshipFromJson(Map<String, dynamic> json) => scholarship(
      imageUrl: json['imageUrl'] as String,
      applicationDeadline: json['applicationDeadline'] as String,
      description: json['description'],
      title: json['title'] as String,
      organization: json['organization'] as String,
      organizationId: json['organizationId'] as String,
    );

Map<String, dynamic> _$scholarshipToJson(scholarship instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'description': instance.description,
      'applicationDeadline': instance.applicationDeadline,
      'organization': instance.organization,
      'organizationId': instance.organizationId,
    };
