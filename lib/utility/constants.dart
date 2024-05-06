// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum Environment { DEV, STAGING, PROD }

class Constants {
  Constants._();
  static const double padding = 15;
  static const double avatarRadius = 45;
  static Map<String, dynamic> config = {};

  static const String STARTDATE = "startDate";
  static const String STARTTIME = "startTime";
  static const String ENDDATE = "endDate";
  static const String ENDTIME = "endTime";
  static const String HIGHRISK = "is_at_high_risk";
  static const String IS_CREATED = "is_created";
  static const String ORGANIZATION_ID = "organisation_id";
  static const String CLIENT_ID = "client_id";
  static const String LAT = "lat";
  static const String LNG = "lng";
  static const String LOCATION_TITLE = "location_title";
  static const String CHARGING = "charging";
  static const String BATTERY_LEVEL = "battery_level";
  static const String BATTERY_STATUS = "battery_status";
  static const String TIME_ZONE = "timezone";
  static const String BOOK_ON = "book_on";
  static const String SMS_RAISE_SOS = "book_on";
  static const String FIRST_INSTALL = "firstInstall";

  static const String JOB_ID = "jobId";
  static const String BOOK_TYPE = "bookType";
  static const String DELAYED_CALL = "delayedcall";
  static const String ACTION_TIME = "actiontime";
  static const String PIN = "pin";
  static const String TYPE = "type";
  static const String EMAIL_REQUIRE = "Your email address is required";
  static const String EMAIL_VALID = "Please provide a valid email address";
  static const String PHONE_CHARA =
      "Phone Number must be greater than 12 character.";
  static const String PAS_REQUIRE = "Password is required";
  static const String COMP_ID_REQUIRE = "Company ID is required";
  static const String CON_PWD = "Confirm Password does not matched.";
  static const String PHONE_REQUIRE = "Phone Number is required.";
  static const String INPUT_REQUIRE = "Please enter some value.";
  static const String SELECT_RELATION = "Please Select Relationship.";
  static const String TAG_RELATIONSHIP = "Relationship";

  static const String TermsOfService =
      'The Solar Amps platform may be made available to you by your solar developer on a subscription basis to facilitate the monitoring and management of your solar power production.  The Solar Amps platform is owned and operated by Solar Informatics, LLC.  In addition to the terms of your agreement with your solar developer, these Terms of Service (“this Agreement”) are a binding agreement between Solar Informatics, LLC (“SI”) and you ("End User," "You" or “Your”) and govern your access and use of the Solar Amps platform including any optimized version of our website via a wireless device or through our mobile application (collectively the “Services”).\n\n BY LOGGING INTO OR USING ANY PORTION OF THE SERVICES OR DOWNLOADING OUR MOBILE APPLICATION, YOU (A) ACCEPT THIS AGREEMENT AND AGREE THAT YOU ARE LEGALLY BOUND BY ITS TERMS; AND (B) REPRESENT AND WARRANT THAT (1) YOU HAVE CAREFULLY READ AND UNDERSTOOD THE TERMS OF THIS AGREEMENT, (2) YOU ARE 18 YEARS OF AGE OR OLDER OR OTHERWISE OF LEGAL AGE TO ENTER INTO A BINDING AGREEMENT; AND (3) IF END USER IS A CORPORATION, COOPERATIVE OR OTHER LEGAL ENTITY OR GROUP, YOU HAVE THE RIGHT, POWER AND AUTHORITY TO ENTER INTO THIS AGREEMENT ON BEHALF OF END USER AND BIND END USER TO ITS TERMS.\n IF YOU DO NOT ACCEPT THE TERMS OF THIS AGREEMENT, SI DOES NOT LICENSE THE SERVICES TO YOU AND YOU MUST NOT USE THE SERVICES OR DOWNLOAD OUR MOBILE APPLICATION. THIS AGREEMENT IS ENFORCEABLE AGAINST ANY PERSON OR ENTITY THAT DOWNLOADS OUR MOBILE APPLICATION OR ACCESSES OR USES THE SERVICES IN ANY MANNER.  NO LICENSE IS GRANTED (WHETHER EXPRESSLY, BY IMPLICATION OR OTHERWISE), AND THIS AGREEMENT EXPRESSLY EXCLUDES ANY RIGHT, CONCERNING THE SERVICES THAT YOU DID NOT LAWFULLY ACQUIRE THE RIGHT TO ACCESS OR USE, OR THAT IS NOT A LEGITIMATE, AUTHORIZED COPY OF THE PLATFORM OR ANY OTHER PORTION OF THE SERVICES.\n\nAccount Creation; Subscriptions\nCreation of your account will be managed with your solar developer and the term of your subscription and billing of fees for your use of the Services will be governed by the agreement between you and your solar developer.  You may need to provide certain registration details or other information to your solar developer to create an account and to otherwise access and use the Services.  It is a condition of your access and use of the Services that all the information you provide is correct, current, and complete. SI shall have responsibility or liability for termination of your subscription or account access by your solar developer and SI is under no further obligations to you upon termination or expiration of your subscription for any reason.\nAccess Rights\n\nSolely during the term of any subscription period authorized by your solar developer and subject to the terms of this Agreement and Your strict compliance thereof, SI grants You a limited, non-exclusive, non-sublicensable, nontransferable, revocable license to access and use the Services as made available by SI solely for purposes of managing and monitoring Your solar power production and billing in accordance with this Agreement and any applicable third party licenses, and access your account through SI’s websites or mobile applications.\n\nLimitations and Appropriate Use\n\nEnd Users shall not:  (a) use the Services or any materials contained within the Services beyond the scope of the license granted under the “Access Rights” section above; (b) provide any other person, including any subcontractor, independent contractor, affiliate or service provider of You, with access to or use of the Services; (c) copy, modify, translate, adapt or otherwise create derivative works or improvements of the Services or any part thereof; (d) make copies, reverse engineer, disassemble, decompile, decode or otherwise attempt to derive or gain access to the source code of the Services or any part thereof; (e) remove, delete, alter or obscure any titles, trademarks, service marks, trade names, legends, watermarks or any copyright, trademark, patent or other intellectual property or proprietary rights notices from the Services, including any copy thereof; (f) provide use of the Services to a third party, including but not limited to providing an evaluation license to the Services to any other person or entity, or otherwise permitting any other person or entity to evaluate the Services; (g) remove, disable, jailbreak, circumvent or otherwise create or implement any workaround to any copy protection, rights management or security features in or protecting the Services; (h) access or use any portion of the Services other than as expressly authorized including by accessing or using accounts of other parties; (i) access or use the Services in the development of a competing software product.\n\nEnd Users shall not engage in activities when using the Services that:  (i) violate the law or the rights of other parties; (ii) infringe any intellectual property, privacy or other rights of SI and/or a third party (including without limitation by attempting to access or view ); (iii) post or transmit any objectionable content including, but not limited to, violent or sexual expressions, expressions that lead to discrimination by race, national origin, creed, sex, social status, family origin, etc.; (iv) lead to the misrepresentation of SI and/or a third party, or intentionally spread false information; (v) interfere with the servers and/or network systems related to the Services, (vi)  abuse the Services and/or servers and/or network systems related to the Services by means of BOTs, cheat tools, or other technical measures; (vi) use the Services for sales, marketing, advertisement, soliciting or other commercial purposes (except for those approved by SI); or (viii) other activities that may be deemed by SI to be inappropriate.\n\nAny violation of the above limitations or restricted activities shall be deemed a material breach of this Agreement for which SI, in its sole discretion, may terminate this Agreement and your access to the Services.';

  static const String keyBaseUrl = "baseUrl";

  //-------------------------- PREFERENCE KEYS--------------------------//

  static const String keyCompKey = "compKey";
  static const String keyTenantLogoPath = "tenantLogoPath";
  static const String keyTokenBearer = "bearerToken";
  static const String currentUser = "currentUser";
  static const String keyUser = "user";
  static const String entityID = "entityID";
  static const String keyRememberMe = "rememberMe";
  static const String keyCompName = "compName";
  static const String keyImagesUrl = "imagesUrl";
  static const String keyAllowedSiteSelectionVal = "allowedSiteSelectionVal";
  static const String compIDRememberMe = "compIDRememberMe";

//-------------------------- SCREEN PATHS--------------------------//
  static const String dashboardScreenPath = "/dashboard";
  static const String loginTenantScreenPath = "/login_tenant";
  static const String loginScreenPath = "/login";
  static const String fullScreenGraphScreenPath = "/full_screen_graph";
  static const String userProfileScreenPath = "/user_profile";
  static const String resetPasswordScreenPath = "/reset_password";
  static const String addressListScreenPath = "/address_list";
  static const String subscriptionListScreenPath = "/subscription_list";
  static const String paymentMethodListScreenPath = "/payment_method_list";

  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  static void setEnvironment(Environment env) {
    switch (env) {
      case Environment.DEV:
        config = _Config.debugConstants;
        break;
      case Environment.STAGING:
        config = _Config.qaConstants;
        break;
      case Environment.PROD:
        config = _Config.prodConstants;
        break;
    }
  }
}

class _Config {
  static const baseUrl = "SERVER_ONE";
  static const whereAmI = "WHERE_AM_I";
  static const attatchmentUrl = "";
  static const termsOfUseURL =
      "https://platform.solarinformatics.com/#/terms-of-use";
  static const privacyPolicyURL =
      "https://platform.solarinformatics.com/#/privacy-policy";

  static Map<String, dynamic> debugConstants = {
    baseUrl: "https://sidevbe.azurewebsites.net/solarapi/",
    whereAmI: "local",
    attatchmentUrl: "https://devstoragesi.blob.core.windows.net/dev/tenant/",
    termsOfUseURL: "https://sistage.azurewebsites.net/#/terms-of-use",
    privacyPolicyURL: "https://sistage.azurewebsites.net/#/privacy-policy",
  };
  

  static Map<String, dynamic> qaConstants = {
    baseUrl: "https://bestage.azurewebsites.net/solarapi",
    whereAmI: "staging",
    attatchmentUrl: "https://devstoragesi.blob.core.windows.net/stage/tenant/",
  };

  static Map<String, dynamic> prodConstants = {
    baseUrl: "https://siprodbeapi.azurewebsites.net/solarapi/",
    whereAmI: "prod",
    attatchmentUrl: "",
  };
}
