import 'dart:convert';

class SliderImagesModal {
  int? id;
  String? attribute;
  String? attributeDescription;
  String? attributeKey;
  List<SliderImageList>? attributeValue;
  String? attributeValueLob;
  String? parentAttribute;
  String? attributeType;
  String? referenceObject;
  String? createdAt;
  String? updatedAt;

  SliderImagesModal(
      {this.id,
      this.attribute,
      this.attributeDescription,
      this.attributeKey,
      this.attributeValue,
      this.attributeValueLob,
      this.parentAttribute,
      this.attributeType,
      this.referenceObject,
      this.createdAt,
      this.updatedAt});

  SliderImagesModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attribute = json['attribute'];
    attributeDescription = json['attributeDescription'];
    attributeKey = json['attributeKey'];
    attributeValue = json['attributeValue'] != null
        ? (jsonDecode(json['attributeValue']) as List<dynamic>)
            .map((e) => SliderImageList.fromJson(e))
            .toList()
        : null;
    attributeValueLob = json['attributeValueLob'];
    parentAttribute = json['parentAttribute'];
    attributeType = json['attributeType'];
    referenceObject = json['referenceObject'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['attribute'] = attribute;
    data['attributeDescription'] = attributeDescription;
    data['attributeKey'] = attributeKey;
    data['attributeValue'] = attributeValue;
    data['attributeValueLob'] = attributeValueLob;
    data['parentAttribute'] = parentAttribute;
    data['attributeType'] = attributeType;
    data['referenceObject'] = referenceObject;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class SliderImageList {
  String? url;
  int? delay;
  int? sequence;

  SliderImageList({this.url, this.delay, this.sequence});

  SliderImageList.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    delay = json['delay'];
    sequence = json['sequence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['delay'] = delay;
    data['sequence'] = sequence;
    return data;
  }
}
