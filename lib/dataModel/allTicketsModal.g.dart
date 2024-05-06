// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'allTicketsModal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllTicketsModal _$AllTicketsModalFromJson(Map<String, dynamic> json) =>
    AllTicketsModal(
      id: json['id'] as int?,
      summary: json['summary'] as String? ?? "",
      message: json['message'] as String? ?? "",
      status: json['status'] as String? ?? "",
      priority: json['priority'] as String? ?? "",
      createdAt: json['createdAt'] as String? ?? "",
      category: json['category'] as String? ?? "",
      subCategory: json['subCategory'] as String? ?? "",
      raisedBy: json['raisedBy'] as int?,
      firstName: json['firstName'] as String? ?? "",
      role: json['role'] as String? ?? "",
      customerId: json['customerId'] as int?,
      conversationHistoryDTOList:
          (json['conversationHistoryDTOList'] as List<dynamic>?)
              ?.map((e) => UserMessageModal.fromJson(e as Map<String, dynamic>))
              .toList(),
      conversationReferenceDTOList:
          (json['conversationReferenceDTOList'] as List<dynamic>?)
              ?.map((e) => ReferenceDTOList.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$AllTicketsModalToJson(AllTicketsModal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'summary': instance.summary,
      'message': instance.message,
      'status': instance.status,
      'priority': instance.priority,
      'createdAt': instance.createdAt,
      'category': instance.category,
      'subCategory': instance.subCategory,
      'raisedBy': instance.raisedBy,
      'firstName': instance.firstName,
      'role': instance.role,
      'customerId': instance.customerId,
      'conversationHistoryDTOList': instance.conversationHistoryDTOList,
      'conversationReferenceDTOList': instance.conversationReferenceDTOList,
    };
