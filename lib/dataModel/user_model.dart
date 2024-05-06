import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

//done this file

@JsonSerializable()
class UserModel {

  @JsonKey(name: 'userName')
  final String? userName;

  @JsonKey(name: 'userType')
  final String? userType;

  @JsonKey(name: 'emailAddress')
  final String? emailAddress;

  @JsonKey(name: 'acctId')
  int? acctId;
  String? jwtToken, firstName, lastName, registerDate, activeDate, status, createdAt, updatedAt;
  List<String>? roles;
  @JsonKey(name: 'password')
  String? password;

  UserModel(this.password, {this.userName, this.userType, this.emailAddress
  , this.acctId, this.jwtToken, this.firstName, this.registerDate, this.activeDate, this.status, this.createdAt, this.updatedAt, this.lastName, this.roles});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);


}