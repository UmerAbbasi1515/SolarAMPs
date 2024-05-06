class UserProfileGetUserDetailModel {
  int? acctId;
  String? firstName;
  String? lastName;
  String? userName;
  String? dataOfBirth;
  String? authentication;
  String? emailAddress;
  String? phone;
  String? customerState;
  String? customerType;
  List<PhysicalLocations>? physicalLocations;
  List<CaUtility>? caUtility;
  CaReferralInfo? caReferralInfo;
  String? profileUrl;
  String? entityType;
  int? entityId;
  String? isChecked;
  String? isSubmitted;

  UserProfileGetUserDetailModel(
      {acctId,
      firstName,
      lastName,
      userName,
      dataOfBirth,
      authentication,
      emailAddress,
      phone,
      customerState,
      customerType,
      physicalLocations,
      caUtility,
      caReferralInfo,
      profileUrl,
      entityType,
      entityId,
      isChecked,
      isSubmitted});

  UserProfileGetUserDetailModel.fromJson(Map<String, dynamic> json) {
    acctId = json['acctId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userName = json['userName'];
    dataOfBirth = json['dataOfBirth'];
    authentication = json['authentication'];
    emailAddress = json['emailAddress'];
    phone = json['phone'];
    customerState = json['customerState'];
    customerType = json['customerType'];
    if (json['physicalLocations'] != null) {
      physicalLocations = <PhysicalLocations>[];
      json['physicalLocations'].forEach((v) {
        physicalLocations!.add(PhysicalLocations.fromJson(v));
      });
    }
    if (json['caUtility'] != null) {
      caUtility = <CaUtility>[];
      json['caUtility'].forEach((v) {
        caUtility!.add(CaUtility.fromJson(v));
      });
    }
    caReferralInfo = json['caReferralInfo'] != null
        ? CaReferralInfo.fromJson(json['caReferralInfo'])
        : null;
    profileUrl = json['profileUrl'];
    entityType = json['entityType'];
    entityId = json['entityId'];
    isChecked = json['isChecked'];
    isSubmitted = json['isSubmitted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['acctId'] = acctId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userName'] = userName;
    data['dataOfBirth'] = dataOfBirth;
    data['authentication'] = authentication;
    data['emailAddress'] = emailAddress;
    data['phone'] = phone;
    data['customerState'] = customerState;
    data['customerType'] = customerType;
    if (physicalLocations != null) {
      data['physicalLocations'] =
          physicalLocations!.map((v) => v.toJson()).toList();
    }
    if (caUtility != null) {
      data['caUtility'] = caUtility!.map((v) => v.toJson()).toList();
    }
    if (caReferralInfo != null) {
      data['caReferralInfo'] = caReferralInfo!.toJson();
    }
    data['profileUrl'] = profileUrl;
    data['entityType'] = entityType;
    data['entityId'] = entityId;
    data['isChecked'] = isChecked;
    data['isSubmitted'] = isSubmitted;
    return data;
  }
}

class PhysicalLocations {
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

  PhysicalLocations(
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

  PhysicalLocations.fromJson(Map<String, dynamic> json) {
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

class CaUtility {
  int? id;
  String? accountHolderName;
  int? utilityProviderId;
  String? premise;
  int? averageMonthlyBill;
  String? referenceId;
  List<PhysicalLocations>? physicalLocations;
  bool? isChecked;
  List<String>? fileUrls;

  CaUtility(
      {id,
      accountHolderName,
      utilityProviderId,
      premise,
      averageMonthlyBill,
      referenceId,
      physicalLocations,
      isChecked,
      fileUrls});

  CaUtility.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountHolderName = json['accountHolderName'];
    utilityProviderId = json['utilityProviderId'];
    premise = json['premise'];
    averageMonthlyBill = json['averageMonthlyBill'];
    referenceId = json['referenceId'];
    if (json['physicalLocations'] != null) {
      physicalLocations = <PhysicalLocations>[];
      json['physicalLocations'].forEach((v) {
        physicalLocations!.add(PhysicalLocations.fromJson(v));
      });
    }
    isChecked = json['isChecked'];
    fileUrls = json['fileUrls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['accountHolderName'] = accountHolderName;
    data['utilityProviderId'] = utilityProviderId;
    data['premise'] = premise;
    data['averageMonthlyBill'] = averageMonthlyBill;
    data['referenceId'] = referenceId;
    if (physicalLocations != null) {
      data['physicalLocations'] =
          physicalLocations!.map((v) => v.toJson()).toList();
    }
    data['isChecked'] = isChecked;
    data['fileUrls'] = fileUrls;
    return data;
  }
}

class CaReferralInfo {
  int? id;
  String? source;
  int? representativeId;
  String? promoCode;
  int? entityId;
  String? agentDesignation;
  String? agentName;

  CaReferralInfo(
      {id,
      source,
      representativeId,
      promoCode,
      entityId,
      agentDesignation,
      agentName});

  CaReferralInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    source = json['source'];
    representativeId = json['representativeId'];
    promoCode = json['promoCode'];
    entityId = json['entityId'];
    agentDesignation = json['agentDesignation'];
    agentName = json['agentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['source'] = source;
    data['representativeId'] = representativeId;
    data['promoCode'] = promoCode;
    data['entityId'] = entityId;
    data['agentDesignation'] = agentDesignation;
    data['agentName'] = agentName;
    return data;
  }
}
