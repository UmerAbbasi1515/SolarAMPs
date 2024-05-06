import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:solaramps/dataModel/client_user_detail_model.dart';
import 'package:solaramps/dataModel/user_profile_get_image_model.dart';
import 'package:solaramps/dataModel/user_profile_set_image_model.dart';
import 'package:solaramps/dataModel/user_profile_um_model.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/utility/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:solaramps/utility/shared_preference.dart';

class UserProfileScreenRepository {
  static Future<dynamic> getClientUserDetail(String value) async {
    try {
      var url = AppUrl.baseUrl + AppUrl.getClientUserDetail + value;
      if (kDebugMode) {
        print('Url :::getClientUserDetail::: $url');
      }
      var response = await BaseClientClass.getWithToken(url);
      if (response is http.Response) {
        var res =
            UserProfileGetUserDetailModel.fromJson(jsonDecode(response.body));

        return res;
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Exception inside the Repo ::::  $e');
      }
      rethrow;
    }
  }

  static Future<dynamic> getUserProfileImage(String value) async {
    try {
      var url = AppUrl.baseUrl + AppUrl.getUserProfielImage + value;
      if (kDebugMode) {
        print('Url :::getUserProfielImage::: $url');
      }
      var response = await BaseClientClass.getWithToken(url);
      if (kDebugMode) {
        print('Response :::getUserProfielImage:::Before $response');
        print('Response is http.Response ${(response is http.Response)}');
      }
      if (response is http.Response) {
        var res = UserProfileImageModel.fromJson(jsonDecode(response.body));

        if (kDebugMode) {
          print('Response :::getUserProfielImage:::After $res');
        }
        return res;
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Exception inside the Repo ::::  $e');
      }
      rethrow;
    }
  }

  static Future<dynamic> saveUserProfileImage(String value, imagePath) async {
    try {
      var url = AppUrl.baseUrl + AppUrl.saveUserProfielImage + value;
      var compKey = UserPreferences.compKey;
      var response = await BaseClientClass.getWithTokenAndCompKeyMultiPart(
          url, compKey!, imagePath);

      if (response is http.Response) {
        var res = SaveProfileImageModel.fromJson(jsonDecode(response.body));
        if (kDebugMode) {
          print('Response Repo :::getUserProfielImage:::After   ${res.data}');
        }
        return res;
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Exception inside the Repo ::::  $e');
      }
      rethrow;
    }
  }

  static Future<dynamic> getUserProfileDetail(String value) async {
    try {
      var url = AppUrl.baseUrl + AppUrl.getUserProfile + value;
      if (kDebugMode) {
        print('Url ::getUserProfile::: $url');
      }
      var response = await BaseClientClass.getWithToken(url);
      if (response is http.Response) {
        var res =
            UserProfileGetUserProfileModel.fromJson(jsonDecode(response.body));
        return res;
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Exception inside the Repo ::::  $e');
      }
      rethrow;
    }
  }
}
