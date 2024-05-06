// ignore_for_file: file_names

import 'package:solaramps/dataModel/portal_attribute_values_tenant.dart';

/// id : 57
/// name : "Others"
/// associateTo : "others"
/// attributeType : "Text"
/// locked : true
/// portalAttributeValuesTenant : [{"id":678,"attributeId":57,"attributeValue":"general","sequenceNumber":1,"description":"General"}]

class CategoryById {
  CategoryById({
    int? id,
    String? name,
    String? associateTo,
    String? attributeType,
    bool? locked,
    List<PortalAttributeValuesTenant>? portalAttributeValuesTenant,
  }) {
    _id = id;
    _name = name;
    _associateTo = associateTo;
    _attributeType = attributeType;
    _locked = locked;
    _portalAttributeValuesTenant = portalAttributeValuesTenant;
  }

  CategoryById.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _associateTo = json['associateTo'];
    _attributeType = json['attributeType'];
    _locked = json['locked'];
    if (json['portalAttributeValuesTenant'] != null) {
      _portalAttributeValuesTenant = [];
      json['portalAttributeValuesTenant'].forEach((v) {
        _portalAttributeValuesTenant
            ?.add(PortalAttributeValuesTenant.fromJson(v));
      });
    }
  }
  int? _id;
  String? _name;
  String? _associateTo;
  String? _attributeType;
  bool? _locked;
  List<PortalAttributeValuesTenant>? _portalAttributeValuesTenant;

  int? get id => _id;
  String? get name => _name;
  String? get associateTo => _associateTo;
  String? get attributeType => _attributeType;
  bool? get locked => _locked;
  List<PortalAttributeValuesTenant>? get portalAttributeValuesTenant =>
      _portalAttributeValuesTenant;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['associateTo'] = _associateTo;
    map['attributeType'] = _attributeType;
    map['locked'] = _locked;
    if (_portalAttributeValuesTenant != null) {
      map['portalAttributeValuesTenant'] =
          _portalAttributeValuesTenant?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
