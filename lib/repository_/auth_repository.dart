import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/model_/company_login.dart';
import 'package:solaramps/model_/get_company_name_model.dart';
import 'package:solaramps/utility/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:solaramps/utility/shared_preference.dart';

class AuthRepository {
  static Future<dynamic> getCompanyNameLike(String value) async {
    try {
      var url = '${AppUrl.baseUrl}${AppUrl.getCompanyNameLike}$value';
      if (kDebugMode) {
        print('Url :::::: $url');
      }
      var response = await BaseClientClass.getWithOutToken(url);
      if (response is http.Response) {
        List parsedList = json.decode(response.body);
        List<GetCompanyNameLikeModel> list = parsedList
            .map((val) => GetCompanyNameLikeModel.fromJson(val))
            .toList();
        if (kDebugMode) {
          print('Response::::::: Repo1 :::: $list');
          print('Response::::::: Repo2 :::: ${list.length}');
        }
        return list;
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Exception inside the Repo ::::  $e');
      }
      rethrow;
    }
  }

  static Future<dynamic> companySignIn(String companyKey) async {
    // var url = AppUrl.baseUrl + AppUrl.getLoginUrlLike + companyKey;
    var url =
        '${AppUrl.baseUrl}${AppUrl.getLoginUrlLike}$companyKey?isMobileLanding=true';
    if (kDebugMode) {
      print('Url :::::: $url');
    }
    var response = await BaseClientClass.getWithOutToken(url);
    if (response is http.Response) {
      final resp = json.decode(response.body);
      final val = resp["landingImagesUrl"];

      if (!val.isEmpty) {
        if (kDebugMode) {
          print('IFFFFFF');
        }
        List<dynamic> list = val
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',')
            .map<dynamic>((e) {
          return e;
        }).toList();
        List<String> imagesStringList = [];
        imagesStringList.clear();
        if (kDebugMode) {
          print('Before the time of set images 0:::: ${list.length}');
        }
        for (int i = 0; i < list.length; i++) {
          imagesStringList.add(list[i]);
        }

        UserPreferences.imagerUrlSet = imagesStringList;
        if (kDebugMode) {
          print(
              'At the time of set images 0:::: ${UserPreferences.imagerUrlGet.length}');
        }
      } else {
        if (kDebugMode) {
          print('Elseeeeee');
        }
        UserPreferences.imagerUrlSet = [];
        if (kDebugMode) {
          print(
              'At the time of set images 1:::: ${UserPreferences.imagerUrlGet.length}');
        }
      }

      GetCompanyKeyModel model =
          GetCompanyKeyModel.fromJson(json.decode(response.body));
      return model;
    }
    return response;
  }

  static Future<dynamic> userSignIn(String userName, password) async {
    var data = {
      "userName": userName,
      "password": password,
    };
    var url = AppUrl.baseUrl + AppUrl.signIn;
    if (kDebugMode) {
      print('Url :::::: $url');
      print('Data ::::: $data');
    }
    var response =
        await BaseClientClass.postWithoutTokenWithoutCompKey(url, data);
    if (response is http.Response) {
      if (kDebugMode) {
        print('Response::::::: Repo3 :::: ${response.body}');
      }
      return response;
    }
    return response;
  }
}
