// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portal_attribute_values_tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortalAttributeValuesTenant _$PortalAttributeValuesTenantFromJson(
        Map<String, dynamic> json) =>
    PortalAttributeValuesTenant(
      id: json['id'] as int?,
      attributeId: json['attributeId'] as int?,
      attributeValue: json['attributeValue'] as String?,
      sequenceNumber: json['sequenceNumber'] as int?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$PortalAttributeValuesTenantToJson(
        PortalAttributeValuesTenant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributeId': instance.attributeId,
      'attributeValue': instance.attributeValue,
      'sequenceNumber': instance.sequenceNumber,
      'description': instance.description,
    };
