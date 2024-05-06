import 'package:json_annotation/json_annotation.dart';

part 'portal_attribute_values_tenant.g.dart';

@JsonSerializable()
class PortalAttributeValuesTenant {
  int? id;
  int? attributeId;
  String? attributeValue;
  int? sequenceNumber;
  String? description;

  PortalAttributeValuesTenant({
    this.id,
    this.attributeId,
    this.attributeValue,
    this.sequenceNumber,
    this.description,
  });

  factory PortalAttributeValuesTenant.fromJson(Map<String, dynamic> json) =>
      _$PortalAttributeValuesTenantFromJson(json);

  Map<String, dynamic> toJson() => _$PortalAttributeValuesTenantToJson(this);

}