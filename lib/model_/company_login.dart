
class GetCompanyKeyModel {
  int? compKey;
  String? companyCode;
  String? companyName;
  String? companyLogo;
  String? loginUrl;
  String? status;
  String? landingText;
  dynamic landingImagesUrl;

  GetCompanyKeyModel(
      {compKey,
      companyCode,
      companyName,
      companyLogo,
      loginUrl,
      status,
      landingText,
      landingImagesUrl});

  GetCompanyKeyModel.fromJson(Map<String, dynamic> json) {
    compKey = json['compKey'];
    companyCode = json['companyCode'];
    companyName = json['companyName'];
    companyLogo = json['companyLogo'];
    loginUrl = json['loginUrl'];
    status = json['status'];
    landingText = json['landingText'];
    landingImagesUrl = json['landingImagesUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['compKey'] = compKey;
    data['companyCode'] = companyCode;
    data['companyName'] = companyName;
    data['companyLogo'] = companyLogo;
    data['loginUrl'] = loginUrl;
    data['status'] = status;
    data['landingText'] = landingText;
    data['landingImagesUrl'] = landingImagesUrl;
    return data;
  }
}
