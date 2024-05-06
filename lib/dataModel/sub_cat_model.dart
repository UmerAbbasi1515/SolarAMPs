class SubCategoryModel {
  int? id;
  String? name;
  String? associateTo;
  String? attributeType;
  String? locked;
  List<PortalAttributeValuesTenant>? portalAttributeValuesTenant;

  SubCategoryModel(
      {id,
      name,
      associateTo,
      attributeType,
      locked,
      portalAttributeValuesTenant});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    associateTo = json['associateTo'];
    attributeType = json['attributeType'];
    locked = json['locked'];
    if (json['portalAttributeValuesTenant'] != null) {
      portalAttributeValuesTenant = <PortalAttributeValuesTenant>[];
      json['portalAttributeValuesTenant'].forEach((v) {
        portalAttributeValuesTenant!
            .add(PortalAttributeValuesTenant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['associateTo'] = associateTo;
    data['attributeType'] = attributeType;
    data['locked'] = locked;
    if (portalAttributeValuesTenant != null) {
      data['portalAttributeValuesTenant'] =
          portalAttributeValuesTenant!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PortalAttributeValuesTenant {
  int? id;
  int? attributeId;
  String? attributeValue;
  int? sequenceNumber;
  String? description;

  PortalAttributeValuesTenant(
      {id, attributeId, attributeValue, sequenceNumber, description});

  PortalAttributeValuesTenant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeId = json['attributeId'];
    attributeValue = json['attributeValue'];
    sequenceNumber = json['sequenceNumber'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['attributeId'] = attributeId;
    data['attributeValue'] = attributeValue;
    data['sequenceNumber'] = sequenceNumber;
    data['description'] = description;
    return data;
  }
}
