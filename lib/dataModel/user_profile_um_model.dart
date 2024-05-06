// ignore_for_file: unnecessary_null_comparison

class UserProfileGetUserProfileModel {
  String? code;
  Data? data;
  String? message;

  UserProfileGetUserProfileModel({code, data, message});

  UserProfileGetUserProfileModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['code'] = code;
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  int? acctId;
  String? firstName;
  String? lastName;
  String? userName;
  String? dataOfBirth;
  String? status;
  String? emailAddress;
  String? phone;
  String? customerType;
  String? profileUrl;
  int? entityId;
  String? generatedAt;
  String? customerState;

  Data(
      {acctId,
      firstName,
      lastName,
      userName,
      dataOfBirth,
      status,
      emailAddress,
      phone,
      customerType,
      profileUrl,
      entityId,
      generatedAt,
      customerState});

  Data.fromJson(Map<String, dynamic> json) {
    acctId = json['acctId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userName = json['userName'];
    dataOfBirth = json['dataOfBirth'];
    status = json['status'];
    emailAddress = json['emailAddress'];
    phone = json['phone'];
    customerType = json['customerType'];
    profileUrl = json['profileUrl'];
    entityId = json['entityId'];
    generatedAt = json['generatedAt'];
    customerState = json['customerState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['acctId'] = acctId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userName'] = userName;
    data['dataOfBirth'] = dataOfBirth;
    data['status'] = status;
    data['emailAddress'] = emailAddress;
    data['phone'] = phone;
    data['customerType'] = customerType;
    data['profileUrl'] = profileUrl;
    data['entityId'] = entityId;
    data['generatedAt'] = generatedAt;
    data['customerState'] = customerState;
    return data;
  }
}
