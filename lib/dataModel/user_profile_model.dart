class UserProfileAddressModel {
  String? code;
  List<Data>? data;
  String? message;

  UserProfileAddressModel({code, data, message});

  UserProfileAddressModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  int? id;
  String? add1;
  String? add2;
  String? add3;
  String? category;
  String? geoLat;
  String? geoLong;
  String? status;
  String? active;
  String? ext1;
  String? zipCode;
  OrganizationDTO? organizationDTO;
  String? locationType;

  Data(
      {id,
      add1,
      add2,
      add3,
      category,
      geoLat,
      geoLong,
      status,
      active,
      ext1,
      zipCode,
      organizationDTO,
      locationType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    add1 = json['add1'];
    add2 = json['add2'];
    add3 = json['add3'];
    category = json['category'];
    geoLat = json['geoLat'];
    geoLong = json['geoLong'];
    status = json['status'];
    active = json['active'];
    ext1 = json['ext1'];
    zipCode = json['zipCode'];
    organizationDTO = json['organizationDTO'] != null
        ? OrganizationDTO.fromJson(json['organizationDTO'])
        : null;
    locationType = json['locationType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['add1'] = add1;
    data['add2'] = add2;
    data['add3'] = add3;
    data['category'] = category;
    data['geoLat'] = geoLat;
    data['geoLong'] = geoLong;
    data['status'] = status;
    data['active'] = active;
    data['ext1'] = ext1;
    data['zipCode'] = zipCode;
    if (organizationDTO != null) {
      data['organizationDTO'] = organizationDTO!.toJson();
    }
    data['locationType'] = locationType;
    return data;
  }
}

class OrganizationDTO {
  int? id;
  String? organizationName;
  String? businessDescription;
  bool? primaryIndicator;
  String? status;
  String? createdAt;
  String? updatedAt;

  OrganizationDTO(
      {id,
      organizationName,
      businessDescription,
      primaryIndicator,
      status,
      createdAt,
      updatedAt});

  OrganizationDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationName = json['organizationName'];
    businessDescription = json['businessDescription'];
    primaryIndicator = json['primaryIndicator'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['organizationName'] = organizationName;
    data['businessDescription'] = businessDescription;
    data['primaryIndicator'] = primaryIndicator;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
