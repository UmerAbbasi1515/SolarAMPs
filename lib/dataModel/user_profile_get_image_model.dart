class UserProfileImageModel {
  int? entity;
  String? fileName;
  int? id;
  String? uri;

  UserProfileImageModel({entity, fileName, id, uri});

  UserProfileImageModel.fromJson(Map<String, dynamic> json) {
    entity = json['entity'];
    fileName = json['fileName'];
    id = json['id'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entity'] = entity;
    data['fileName'] = fileName;
    data['id'] = id;
    data['uri'] = uri;
    return data;
  }
}
