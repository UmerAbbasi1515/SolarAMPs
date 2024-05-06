// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_message_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMessageModal _$UserMessageModalFromJson(Map<String, dynamic> json) =>
    UserMessageModal(
      id: json['id'] as int?,
      message: json['message'] as String?,
      firstName: json['firstName'] as String?,
      role: json['role'] as String?,
      internal: json['internal'] as bool?,
      priority: json['priority'] as String?,
      conversationReferenceDTOList:
          (json['conversationReferenceDTOList'] as List<dynamic>?)
              ?.map((e) => ReferenceDTOList.fromJson(e as Map<String, dynamic>))
              .toList(),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$UserMessageModalToJson(UserMessageModal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'firstName': instance.firstName,
      'role': instance.role,
      'internal': instance.internal,
      'priority': instance.priority,
      'conversationReferenceDTOList': instance.conversationReferenceDTOList,
      'createdAt': instance.createdAt,
    };
