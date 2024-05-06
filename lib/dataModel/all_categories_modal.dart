import 'package:json_annotation/json_annotation.dart';
part 'all_categories_modal.g.dart';

@JsonSerializable()
class AllCategoriesModal {
  int id, attributeId, sequenceNumber;
  String attributeValue, description;

  AllCategoriesModal(
      {this.id = -1,
      this.attributeId = -1,
      this.sequenceNumber = -1,
      this.attributeValue = "",
      this.description = ""});

  factory AllCategoriesModal.fromJson(Map<String, dynamic> json) =>
      _$AllCategoriesModalFromJson(json);
  toJson() => _$AllCategoriesModalToJson(this);
}

class AllSubscriptionsModal {
  String? premiseNo;
  int? userAcctId;
  String? activeSince;
  String? subId;
  String? variantId;
  int? siteLocationId;
  String? variantName;
  String? subName;
  dynamic status;

  AllSubscriptionsModal(
      {this.premiseNo,
      this.userAcctId,
      this.activeSince,
      this.subId,
      this.variantId,
      this.siteLocationId,
      this.variantName,
      this.subName,
      this.status});
  factory AllSubscriptionsModal.fromJson(Map<String, dynamic> json) =>
      _$AllSubscriptionsModalFromJson(json);
  toJson() => _$AllSubscriptionsModalToJson(this);
}
