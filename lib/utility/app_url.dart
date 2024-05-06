import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:solaramps/utility/shared_preference.dart';

import '../network/api_service.dart';

class AppUrl {
  // static const String baseUrl ="https://prodbesin1.azurewebsites.net/solarapi";// production
  //  static const String baseUrl ="https://preprodben1.azurewebsites.net/solarapi/";  ''pre production
  //
  static const String baseUrl =
      'https://prodbesin1.azurewebsites.net/solarapi'; // prod
  // static const String baseUrl =
  //     'https://sidevbe.azurewebsites.net/solarapi'; // Dev
  // static const String baseUrl =
  //     'https://bestage.azurewebsites.net/solarapi'; // Staging

  // https://sidevbe.azurewebsites.net/solarapi/user/getCompanyNameLike/so
  // https://prodben1.azurewebsites.net/solarapi/user/getCompanyNameLike/so

  static const String getCompanyKey = '/company/compkey/';
  static const String getClientUserDetail = '/user/getClientUserDetail/';
  static const String getUserProfielImage = '/entityDetail/getImageByEntityId/';
  static const String saveUserProfielImage =
      '/employeeManagement/entityDetail/updateProfilePicture/add/';
  static const String getUserProfile = '/entity/getCustomerProfile/';
  static const String getCustomerInverterAllowedSelection =
      '/getByParameter/NumberOfSitesAllowed';
  static const String getCustomerInverterSelectionExceedMsg =
      '/monitoringDashboard/validateSitesCount?count=';
  static const String getCustomerInverterList =
      '/subscription/customerInverterSubscriptionList';
  static const String getAllowFiles = '/solarapi/portalAttribute/49';
  static const String getWeatherOfSites =
      '/weather/weather-widget-data?gardenIds=';
  static const String getWeatherForeCastOfSites =
      '/weather/getWeatherDataForFiveAndSevenDays?gardenIds=';
  static const String getCustomerSubscriptionsList =
      '/subscription/customerInverterSubscriptionList';
  static const String getDailyGraphData = "/monitor/getCurrentGraphData";
  static const String getDashboardYieldWidgets =
      "/monitor/getCurrentWidgetData";
  static const String getDashboardWidgets = "/monitor/getCurrentWidgetData";
  static const String getDashboardTreeFactor =
      "/monitoringDashboard/getSitesWidgetData";
  static const String getMonthlyGraphData =
      "/monitor/getMonthlyCurrentGraphData";
  static const String getYearlyGraphData = "/monitor/getYearlyCurrentGraphData";
  static const String forgotPassword = "/forgotPassword/generateOtp/";
  static const String verifyOTP = "/forgotPassword/verifyOtp/";
  static const String resetPassword = "/forgotPassword/resetPasswordByEmail/";
  static const String getAllTickets = "/conversation/conversationHead?flag=ext";
  //solarapi/conversation/conversationHead
  static const String createTicket = "/conversation/conversationHead/DOCU";
  static const String getCategory = "/portalAttributeValue/attributeById/52";
  static const String lov = "/portalAttributeValue/attributeById/52";
  static const String getSubCategory =
      "/portalAttributeValue/attributeById/{id}";
  static const String getPriority = "/portalAttributeValue/attributeById/51";
  static String attatchment =
      "https://devstoragesi.blob.core.windows.net/stage/tenant/${UserPreferences.compKey}/customer/support/";
  static String attatchmentDev =
      "https://devstoragesi.blob.core.windows.net/dev/tenant/${UserPreferences.compKey}/customer/support/";
  static String attatchmentPro =
      "https://prsistorage.blob.core.windows.net/newprod/tenant/${UserPreferences.compKey}/customer/support/";
  // static String attatchmentPro =
  //     "https://centdevstorage.blob.core.windows.net/prod/tenant/${UserPreferences.compKey}/customer/support/";
  static const String termsOfUseURL =
      'https://www.solaramps.com/#/terms-of-use';
  // static const String termsOfUseURL =
  //     'https://platform.solarinformatics.com/#/terms-of-use';
  static const String privacyPolicyURL =
      'https://www.solaramps.com/#/privacy-policy';
  // static const String privacyPolicyURL =
  //     'https://platform.solarinformatics.com/#/privacy-policy';
  static const String attatchmentLink =
      'https://devstoragesi.blob.core.windows.net/stage/tenant/1002/customer/support/';
  static const String getSliderUrl =
      "https://devstoragesi.blob.core.windows.net/devpublic/carousel/default/";

  // New
  static const String getCompanyNameLike = '/user/getCompanyNameLike/';
  static const String getLoginUrlLike = '/user/getLoginUrlLike/';
  static const String signIn = '/signin';
  static ApiService apiService = ApiService(dio.Dio(), AppUrl.baseUrl);
  static GlobalKey<ScaffoldMessengerState> scaffoldMessangerKey =
      GlobalKey<ScaffoldMessengerState>();
}
