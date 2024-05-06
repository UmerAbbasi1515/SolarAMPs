// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['password'] as String?,
      userName: json['userName'] as String?,
      userType: json['userType'] as String?,
      emailAddress: json['emailAddress'] as String?,
      acctId: json['acctId'] as int?,
      jwtToken: json['jwtToken'] as String?,
      firstName: json['firstName'] as String?,
      registerDate: json['registerDate'] as String?,
      activeDate: json['activeDate'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      lastName: json['lastName'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userName': instance.userName,
      'userType': instance.userType,
      'emailAddress': instance.emailAddress,
      'acctId': instance.acctId,
      'jwtToken': instance.jwtToken,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'registerDate': instance.registerDate,
      'activeDate': instance.activeDate,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'roles': instance.roles,
      'password': instance.password,
    };
