class SaveProfileImageModel {
  Data? data;

  SaveProfileImageModel({data});

  SaveProfileImageModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  EntityDTO? entityDTO;
  String? uri;
  String? fileName;

  Data({id, entityDTO, uri, fileName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entityDTO = json['entityDTO'] != null
        ? EntityDTO.fromJson(json['entityDTO'])
        : null;
    uri = json['uri'];
    fileName = json['fileName'];
  }
}

class EntityDTO {
  int? id;
  String? entityName;
  String? entityType;
  String? status;
  String? contactPersonEmail;
  String? contactPersonPhone;
  List<String>? contractDTOList;
  String? createdAt;
  String? updatedAt;

  EntityDTO(
      {id,
      entityName,
      entityType,
      status,
      contactPersonEmail,
      contactPersonPhone,
      contractDTOList,
      createdAt,
      updatedAt});

  EntityDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entityName = json['entityName'];
    entityType = json['entityType'];
    status = json['status'];
    contactPersonEmail = json['contactPersonEmail'];
    contactPersonPhone = json['contactPersonPhone'];
    if (json['contractDTOList'] != null) {
      contractDTOList = <String>[];
      json['contractDTOList'].forEach((v) {
        contractDTOList!.add(json['contractDTOList'].fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
