// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_categories_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllCategoriesModal _$AllCategoriesModalFromJson(Map<String, dynamic> json) =>
    AllCategoriesModal(
      id: json['id'] as int? ?? -1,
      attributeId: json['attributeId'] as int? ?? -1,
      sequenceNumber: json['sequenceNumber'] as int? ?? -1,
      attributeValue: json['attributeValue'] as String? ?? "",
      description: json['description'] as String? ?? "",
    );

Map<String, dynamic> _$AllCategoriesModalToJson(AllCategoriesModal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attributeId': instance.attributeId,
      'sequenceNumber': instance.sequenceNumber,
      'attributeValue': instance.attributeValue,
      'description': instance.description,
    };

AllSubscriptionsModal _$AllSubscriptionsModalFromJson(
        Map<String, dynamic> json) =>
    AllSubscriptionsModal(
      premiseNo: json['premiseNo'] as String? ?? '',
      userAcctId: json['userAcctId'] as int? ?? -1,
      activeSince: json['activeSince'] as String? ?? '',
      subId: json['subId'] as String? ?? "",
      variantId: json['variantId'] as String? ?? "",
      siteLocationId: json['siteLocationId'] as int? ?? -1,
      variantName: json['variantName'] as String? ?? "",
      subName: json['subName'] as String? ?? "",
      status: json['status'] as String? ?? "",
    );

Map<String, dynamic> _$AllSubscriptionsModalToJson(
        AllSubscriptionsModal instance) =>
    <String, dynamic>{
      'premiseNo': instance.premiseNo,
      'userAcctId': instance.userAcctId,
      'activeSince': instance.activeSince,
      'subId': instance.subId,
      'variantId': instance.variantId,
      'siteLocationId': instance.siteLocationId,
      'variantName': instance.variantName,
      'subName': instance.subName,
      'status': instance.status,
    };
