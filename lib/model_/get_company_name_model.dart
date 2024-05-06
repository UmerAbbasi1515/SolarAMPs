import 'package:flutter/foundation.dart';

class GetCompanyNameLikeModel {
  int? id;
  String? dbName;
  String? status;
  String? companyCode;
  int? companyKey;
  String? companyName;
  String? companyLogo;
  String? loginUrl;
  GetCompanyNameLikeModel(decode,
      {this.dbName,
      this.status,
      this.companyCode,
      this.companyKey,
      this.companyName,
      this.companyLogo,
      this.loginUrl});
  GetCompanyNameLikeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dbName = json['dbName'];
    status = json['status'];
    companyCode = json['companyCode'];
    companyKey = json['companyKey'];
    companyName = json['companyName'];
    companyLogo = json['companyLogo'];
    loginUrl = json['loginUrl'];
  }
}

class GetCompanyNameLikeModelExtend {
  List<GetCompanyNameLikeModel>? companyNameList;
  GetCompanyNameLikeModelExtend({required this.companyNameList});
  GetCompanyNameLikeModelExtend.fromJson(var json) {
    if (kDebugMode) {
      print('Response inside the model :::  $json');
    }
    if (json != null) {
      if (kDebugMode) {
        print('Response inside the model :::  json != null');
      }
      json.forEach((v) {
        companyNameList!.add(GetCompanyNameLikeModel.fromJson(v));
      });
    }
  }
}
