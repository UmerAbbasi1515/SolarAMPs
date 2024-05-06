import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:retrofit/retrofit.dart';
import 'package:solaramps/dataModel/allTicketsModal.dart';
import 'package:solaramps/dataModel/create_ticket_subscriptions_model.dart';
import 'package:solaramps/dataModel/sub_cat_model.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/shared/const/no_internet_screen.dart';
import 'package:solaramps/utility/shared_preference.dart';
import '../dataModel/all_categories_modal.dart';
import '../utility/app_url.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: AppUrl.baseUrl) // Enter you base URL
abstract class ApiService {
  factory ApiService(Dio dio, baseUrl) {
    return _ApiService(dio, baseUrl: AppUrl.baseUrl);
  }

  @POST(AppUrl.signIn)
  Future<dynamic> signIn(
      @Header("Comp-Key") int compKey, @Body() Map<String, dynamic> body);

  @GET(AppUrl.getCompanyKey + "{identifier}")
  Future<dynamic> getCompanyKey(@Path("identifier") String identifier);

  @GET(AppUrl.getCustomerInverterAllowedSelection)
  Future<dynamic> getCustomerInverterAllowedSelection(
      @Header("Comp-Key") int compKey);

  @GET(AppUrl.getCustomerInverterSelectionExceedMsg + "{identifier}")
  Future<dynamic> getCustomerInverterSelectionExceedMsg(
      @Path("identifier") String identifier);

  @GET(AppUrl.getWeatherOfSites)
  Future<dynamic> getWeatherOfSites(@Path("identifier") String identifier);

  @GET(AppUrl.getWeatherForeCastOfSites)
  Future<dynamic> getWeatherFoerCastOfSites(
      @Path("identifier") List identifier);

  @GET(AppUrl.getCustomerInverterList)
  Future<dynamic> getCustomerInverterList();

  @GET(AppUrl.getCustomerSubscriptionsList)
  Future<dynamic> getCustomerSubscriptionsList();

  @POST(AppUrl.getDashboardTreeFactor)
  Future<dynamic> getDashboardTreeFactorWidgets(
      @Body() Map<String, dynamic> body);
  // => V1
  @POST(AppUrl.getDashboardWidgets)
  Future<dynamic> getDashboardYieldWidgets(@Body() Map<String, dynamic> body);
  // => V0
  // @POST(AppUrl.getDashboardWidgets)
  // Future<dynamic> getDashboardWidgets(@Body() Map<String, dynamic> body);

// Commutative
  @POST(AppUrl.getDailyGraphData)
  Future<dynamic> getDailyGraphDataCommulative(
      @Queries() Map<String, dynamic> queries,
      @Body() Map<String, dynamic> body);

  @POST(AppUrl.getMonthlyGraphData)
  Future<dynamic> getMonthlyGraphDataCommulative(
      @Queries() Map<String, dynamic> queries,
      @Body() Map<String, dynamic> body);

  @POST(AppUrl.getYearlyGraphData)
  Future<dynamic> getYearlyGraphDataCommulative(
      @Queries() Map<String, dynamic> queries,
      @Body() Map<String, dynamic> body);

  // Comparitive
  @POST(AppUrl.getDailyGraphData)
  Future<dynamic> getDailyGraphDataComparative(
      @Queries() Map<String, dynamic> queries,
      @Body() Map<String, dynamic> body);

  @POST(AppUrl.getMonthlyGraphData)
  Future<dynamic> getMonthlyGraphDataComparative(
      @Queries() Map<String, dynamic> queries,
      @Body() Map<String, dynamic> body);

  @POST(AppUrl.getYearlyGraphData)
  Future<dynamic> getYearlyGraphDataComparative(
      @Queries() Map<String, dynamic> queries,
      @Body() Map<String, dynamic> body);

  @GET(AppUrl.getAllTickets)
  Future<List<AllTicketsModal>> getAllTicket();

  @GET(AppUrl.getAllTickets)
  Future<dynamic> getAllTickets();

  @GET(AppUrl.getCategory)
  Future<List<AllCategoriesModal>> getCategory();

  @GET(AppUrl.getCustomerInverterList)
  Future<List<AllSubscriptionsModalForCreateTicket>> getLov();
  // @GET(AppUrl.getCustomerInverterList)
  // Future<List<AllSubscriptionsModal>> getLov();

  @GET("/portalAttribute/name/{id}")
  Future<List<PortalAttributeValuesTenant>> getSubCategory(
      @Path("id") String id);
  // @GET("/portalAttributeValue/attributeById/{id}")
  // Future<List<AllCategoriesModal>> getSubCategory(@Path("id") int id);

  @GET(AppUrl.getAllowFiles)
  Future<List<PortalAttributeValuesTenant>> getAllowFiles();

  @PUT("/conversation/conversationHead")
  Future<dynamic> closeTickets(@Body() Map<String, dynamic> body);

  @GET(AppUrl.getPriority)
  Future<List<AllCategoriesModal>> getPriority();

  @POST(AppUrl.forgotPassword)
  Future<dynamic> forgotPassword(
    @Header("Comp-Key") int compKey,
    @Body() Map<String, dynamic> body,
  );

  // @GET(AppUrl.forgotPassword + "{email}/{requestType}")
  // Future<dynamic> forgotPassword(@Path("email") String email,
  //     @Header("Comp-Key") int compKey, @Path("requestType") String requestType);

  @GET(AppUrl.verifyOTP + "{email}/" + "{otp}")
  Future<dynamic> verifyOTP(@Path("email") String email,
      @Path("otp") String otp, @Header("Comp-Key") int compKey);

  @POST(AppUrl.resetPassword)
  Future<dynamic> resetPassword(@Body() Map<String, dynamic> body);

  @GET("/conversation/conversationHead/{id}")
  Future<AllTicketsModal> getConversationHead(@Path("id") int id);

  // @GET("/address/getUser/{userId}")
  @GET("physicalLocation/getAllPhysicalLocationByEntityId/entityId/")
  Future<dynamic> getCustomerAddresses(@Path("userId") int id);

  @GET("/paymentInfo/user/{userId}")
  Future<dynamic> getCustomerPaymentInfo(@Path("userId") int id);

  @GET("/paymentInfo/decode/{paymentMethodId}")
  Future<dynamic> getDecodedPaymentInfo(@Path("paymentMethodId") int id);

  @GET("/subscription/customerSubscription/user/{userId}")
  Future<dynamic> getCustomerSubscription(@Path("userId") int id);

  @GET("/systemAttribute/carousel/channel/mobile")
  Future<dynamic> getSliderResources();
}
