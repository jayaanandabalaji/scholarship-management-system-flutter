// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'students.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Students _$StudentsFromJson(Map<String, dynamic> json) => Students(
      name: json['name'] as String,
      age: json['age'] as int,
      income: json['income'] as String,
      id: json['id'],
      userProfileUrl: json['userProfileUrl'],
    );

Map<String, dynamic> _$StudentsToJson(Students instance) => <String, dynamic>{
      'name': instance.name,
      'income': instance.income,
      'age': instance.age,
      'id': instance.id,
      'userProfileUrl': instance.userProfileUrl,
    };
