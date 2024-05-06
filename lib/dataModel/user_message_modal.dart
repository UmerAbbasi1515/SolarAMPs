import 'package:json_annotation/json_annotation.dart';
import 'package:solaramps/dataModel/reference_dto_list.dart';

part 'user_message_modal.g.dart';

@JsonSerializable()
class UserMessageModal {
  int? id;
  String? message;
  String? firstName;
  String? role;
  bool? internal;
  String? priority;
  List<ReferenceDTOList>? conversationReferenceDTOList;
  String? createdAt;

  UserMessageModal(
      {this.id,
      this.message,
      this.firstName,
      this.role,
      this.internal,
      this.priority,
      this.conversationReferenceDTOList,
      this.createdAt});

  factory UserMessageModal.fromJson(Map<String, dynamic> json) =>
      _$UserMessageModalFromJson(json);
  toJson() => _$UserMessageModalToJson(this);
}
