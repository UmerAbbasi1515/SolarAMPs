// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import '../network/api_service.dart';
import '../utility/app_url.dart';

enum Status {
  notLoggedIn,
  notRegistered,
  loggedIn,
  registered,
  authenticating,
  registering,
  loggedOut
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.notLoggedIn;
  Status _registeredInStatus = Status.notRegistered;

  // ignore: unnecessary_getters_setters
  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
  }

  // ignore: unnecessary_getters_setters
  Status get registeredInStatus => _registeredInStatus;

  set registeredInStatus(Status value) {
    _registeredInStatus = value;
  }

  notify() {
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(
      String email, String password, String firebaseToken) async {
    var result;

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
      "device_type": Platform.isAndroid ? 'android' : 'iphone',
      "device_token": firebaseToken,
      //  "device_token" : "faF7l-p5vjA:APA91bFQdf_FjROq_Hkwzk7rYRX7cCJfCeEiJJU6A0jd-OpgRKLBalZbkp2eLze3N5YMCRmnyXnSUO1jcwOfC9p2wEmCPBgMvFdQ6rNn8y3YgoBrxYXv62rFQr0BahpqnomcAXj-B0xF",
    };
    if (kDebugMode) {
      print('Login Data : $loginData');
    }

    _registeredInStatus = Status.registered;
    notifyListeners();

    // done , now run app
    ApiService apiService = ApiService(dio.Dio(), AppUrl.baseUrl);
    if (kDebugMode) {
      print(apiService);
    }

    return result;
  }
}
