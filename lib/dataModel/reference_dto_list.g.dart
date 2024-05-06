// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_dto_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceDTOList _$ReferenceDTOListFromJson(Map<String, dynamic> json) =>
    ReferenceDTOList(
      json['id'] as int,
      json['referenceId'] as int,
      uri: json['uri'] as String? ?? "",
      referenceType: json['referenceType'] as String? ?? "",
    );

Map<String, dynamic> _$ReferenceDTOListToJson(ReferenceDTOList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referenceId': instance.referenceId,
      'uri': instance.uri,
      'referenceType': instance.referenceType,
    };
