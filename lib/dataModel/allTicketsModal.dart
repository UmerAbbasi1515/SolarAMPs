// ignore_for_file: file_names

import 'package:json_annotation/json_annotation.dart';
import 'package:solaramps/dataModel/reference_dto_list.dart';
import 'package:solaramps/dataModel/user_message_modal.dart';

part 'allTicketsModal.g.dart';

@JsonSerializable()
class AllTicketsModal {
  int? id;
  String summary;
  String message;
  String status;
  String priority;
  String createdAt;
  String category;
  String subCategory;
  int? raisedBy;
  String firstName;
  String role;
  int? customerId;
  List<UserMessageModal>? conversationHistoryDTOList;
  List<ReferenceDTOList>? conversationReferenceDTOList;

  AllTicketsModal(
      {this.id,
      this.summary = "",
      this.message = "",
      this.status = "",
      this.priority = "",
      this.createdAt = "",
      this.category = "",
      this.subCategory = "",
      this.raisedBy,
      this.firstName = "",
      this.role = "",
      this.customerId,
      this.conversationHistoryDTOList,
      this.conversationReferenceDTOList});

  factory AllTicketsModal.fromJson(Map<String, dynamic> json) =>
      _$AllTicketsModalFromJson(json);
  toJson() => _$AllTicketsModalToJson(this);

  // sorting using status
  int compareTo(other) {
    return status.compareTo(other.status);
  }
}
