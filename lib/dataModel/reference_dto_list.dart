import 'package:json_annotation/json_annotation.dart';

part 'reference_dto_list.g.dart';

@JsonSerializable()
class ReferenceDTOList {
  int id, referenceId;
  String uri, referenceType;

  ReferenceDTOList(this.id, this.referenceId,
      {this.uri = "", this.referenceType = ""});

  factory ReferenceDTOList.fromJson(Map<String, dynamic> json) =>
      _$ReferenceDTOListFromJson(json);
  toJson() => _$ReferenceDTOListToJson(this);
}
