// ignore_for_file: unnecessary_null_comparison, constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solaramps/dataModel/user_model.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class BaseClientClass {
  static const int TIME_OUT_DURATION = 60;
  //////
  static Future<dynamic> postWithoutTokenWithCompKey(
      String url, Map data, String compKey) async {
    http.Response response;
    Map<String, String>? headers = {
      r'Comp-Key': compKey,
      "Content-Type": "application/json", //UserPreferences.compKey.toString()
    };
    try {
      response = await http
          .post(
            Uri.parse(url),
            body: json.encode(data),
            headers: headers,
          )
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      if (kDebugMode) {
        print('response:: ${response.statusCode}');
        print('response:: ${response.body}');
      }
      return _getResponse(response, url);
    } on SocketException {
      if (kDebugMode) {
        print('Response ::SocketException:: No internet connection');
      }
      return 'No internet connection';
    } on TimeoutException {
      return 'No internet connection';
    } catch (e) {
      if (kDebugMode) print(e);
      return 'Something went wrong';
    }
  }

  static Future<dynamic> postWithoutTokenWithoutCompKey(
      String url, Map data) async {
    http.Response response;
    Map<String, String>? headers = {
      "Content-Type": "application/json", //UserPreferences.compKey.toString()
    };
    try {
      response = await http
          .post(
            Uri.parse(url),
            body: json.encode(data),
            headers: headers,
          )
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      if (kDebugMode) {
        print('response:: ${response.statusCode}');
        print('response:: ${response.body}');
      }
      return _getResponse(response, url);
    } on SocketException {
      if (kDebugMode) {
        print('Response ::SocketException:: No internet connection');
      }
      return 'No internet connection';
    } on TimeoutException {
      return 'No internet connection';
    } catch (e) {
      if (kDebugMode) print(e);
      return 'Something went wrong';
    }
  }

  static Future<dynamic> getWithOutToken(String url) async {
    http.Response response;
    try {
      response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: TIME_OUT_DURATION));
      if (kDebugMode) {
        print('response:: $url :: ${response.statusCode}');
      }
      return _getResponse(response, url);
    } on SocketException {
      if (kDebugMode) {
        print('Response ::SocketException:: No internet connection');
      }
      return 'No internet connection';
    } on TimeoutException {
      return 'No internet connection';
    } catch (e) {
      if (kDebugMode) print(e);
      return 'Something went wrong';
    }
  }

  static Future<dynamic> getWithToken(String url) async {
    http.Response response;
    try {
      var token = UserPreferences.token;
      // var token =
      //    'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImF1ZCI6IjEwMjAiLCJ0aWVyIjoxLCJwcGsiOiJMUzB0TFMxQ1JVZEpUZz09IiwiZXhwIjoxNjg3Mzg5OTU0LCJ1c2VyIjp7ImlkIjoxLCJ1c2VybmFtZSI6ImFkbWluIiwiZW1haWwiOiJwb3N0MUBzb2xhcmluZm9ybWF0aWNzLmNvbSIsImF1dGhvcml0aWVzIjpbeyJhdXRob3JpdHkiOiJST0xFX0FETUlOIn0seyJhdXRob3JpdHkiOiJST0xFX0dMT0JBTF9BRE1JTiJ9XSwiYWNjb3VudE5vbkxvY2tlZCI6dHJ1ZSwiYWNjb3VudE5vbkV4cGlyZWQiOnRydWUsImNyZWRlbnRpYWxzTm9uRXhwaXJlZCI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZX0sImlhdCI6MTY4NzM2MTE1NH0.hCxS7z-TU4rEpuVUOh61UgJs8U1CmYoPfSttATO4pagn1_UhyRWiV5MYLPT9MWHFW2zVrbpm2ApbjRRB5FbRjg';
      if (kDebugMode) {
        print('token :::: $token');
      }
      response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token'
        },
      ).timeout(const Duration(seconds: TIME_OUT_DURATION));
      if (kDebugMode) {
        print('response:: ${response.statusCode}');
      }
      return _getResponse(response, url);
    } on SocketException {
      if (kDebugMode) {
        print('Response ::SocketException:: No internet connection');
      }
      return 'No internet connection';
    } on TimeoutException {
      return 'No internet connection';
    } catch (e) {
      if (kDebugMode) print(e);
      return 'Something went wrong';
    }
  }

  static Future<dynamic> getWithTokenAndCompKey(String url, compKey) async {
    http.Response response;
    try {
      var token = UserPreferences.token;
      // var token =
      //    'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImF1ZCI6IjEwMjAiLCJ0aWVyIjoxLCJwcGsiOiJMUzB0TFMxQ1JVZEpUZz09IiwiZXhwIjoxNjg3Mzg5OTU0LCJ1c2VyIjp7ImlkIjoxLCJ1c2VybmFtZSI6ImFkbWluIiwiZW1haWwiOiJwb3N0MUBzb2xhcmluZm9ybWF0aWNzLmNvbSIsImF1dGhvcml0aWVzIjpbeyJhdXRob3JpdHkiOiJST0xFX0FETUlOIn0seyJhdXRob3JpdHkiOiJST0xFX0dMT0JBTF9BRE1JTiJ9XSwiYWNjb3VudE5vbkxvY2tlZCI6dHJ1ZSwiYWNjb3VudE5vbkV4cGlyZWQiOnRydWUsImNyZWRlbnRpYWxzTm9uRXhwaXJlZCI6dHJ1ZSwiZW5hYmxlZCI6dHJ1ZX0sImlhdCI6MTY4NzM2MTE1NH0.hCxS7z-TU4rEpuVUOh61UgJs8U1CmYoPfSttATO4pagn1_UhyRWiV5MYLPT9MWHFW2zVrbpm2ApbjRRB5FbRjg';
      if (kDebugMode) {
        print('token :::: $token');
      }
      response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
          'Comp-Key': compKey
        },
      ).timeout(const Duration(seconds: TIME_OUT_DURATION));
      if (kDebugMode) {
        print('response:: ${response.statusCode}');
      }
      return _getResponse(response, url);
    } on SocketException {
      if (kDebugMode) {
        print('Response ::SocketException:: No internet connection');
      }
      return 'No internet connection';
    } on TimeoutException {
      return 'No internet connection';
    } catch (e) {
      if (kDebugMode) print(e);
      return 'Something went wrong';
    }
  }

  static Future<dynamic> getWithTokenAndCompKeyMultiPart(
    String url,
    int compKey,
    String filePath,
  ) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest("POST", Uri.parse(url));
      if (filePath != null) {
        http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath('file', filePath);
        request.files.add(multipartFile);
      }
      var token = UserPreferences.token;
      request.headers.addAll({
        "Content-Type": "multipart/form-data",
        'Authorization': 'Bearer $token',
        'Comp-Key': compKey.toString()
      });
      http.StreamedResponse response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (kDebugMode) {
        print('******** Responsse of Upload File ********');
        print(responseBody.statusCode);
        print(responseBody.body);
        print(responseBody.body);
        print('******** ******** ********');
      }
      switch (response.statusCode) {
        case 200:
          return responseBody;
        case 400:
          return 'Bad Request';
        case 401:
          return _tokenExpiredDialog();
        case 403:
          return 'Unauthorized';
        case 404:
          return 'Not Found';
        case 500:
          if (url.contains('/user/forgetPassword')) {
            return 'EmailAddress does not exists';
          }
          return 'Internal Server Error';
        case 501:
          return 'Not Found';
        default:
          return 'Could not connect to the server';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
        print(e.toString());
      }
      return 0;
    }
  }

////////
  static Future<dynamic> postwithheader(String url, data, String token) async {
    if (kDebugMode) {
      print('Url :::: => $url');
      print('Data :::: => $data');
    }
    http.Response response;
    try {
      response = await http
          .post(
            Uri.parse(url),
            body: json.encode(data),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
              'ApiKey': 'UZ5QdWg2dLm1sop09082AccIa03DxupsIWDt9rqfeM',
              "raw": "datawithoutfile"
            },
            encoding: Encoding.getByName('utf-8'),
          )
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      if (kDebugMode) {
        print('response:: ${response.statusCode}');
      }
      return _getResponse(response, url);
    } on SocketException {
      if (kDebugMode) {
        print('Response ::SocketException:: No internet connection');
      }
      return 'No internet connection';
    } on TimeoutException {
      return 'No internet connection';
    } catch (e) {
      if (kDebugMode) print(e);
      return 'Something went wrong';
    }
  }

///////
  static Future<dynamic> uploadFile(String url, Map<String, String> fields,
      String fileField, String filePath, String token) async {
    if (kDebugMode) {
      print('Url :::: => $url');
    }
    String bearerToken = '';
    try {
      http.MultipartRequest request =
          http.MultipartRequest("POST", Uri.parse(url));
      if (filePath != null) {
        http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath(fileField, filePath);
        request.files.add(multipartFile);
      }
      request.fields.addAll(fields);
      request.headers.addAll({
        "Content-Type": "application/json",
        'Authorization': 'Bearer $bearerToken',
      });
      http.StreamedResponse response = await request.send();
      return response;
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static dynamic _getResponse(http.Response response, String url) async {
    // print('Response :::: inside getResponse::::: $response');
    if (kDebugMode) {
      print('Response Body :::: inside getResponse::$url::: ${response.body}');
    }
    log(response.body);
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        return 'Bad Request';
      case 401:
        return _tokenExpiredDialog();
      case 403:
        return 'Unauthorized';
      case 404:
        return 'Not Found';
      case 500:
        if (url.contains('/user/forgetPassword')) {
          return 'EmailAddress does not exists';
        }
        return 'Internal Server Error';
      case 501:
        return 'Not Found';
      default:
        return 'Could not connect to the server';
    }
  }

  static _tokenExpiredDialog() async {
    return showDialog<void>(
      context: appNavigationKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text('Session Expired'),
              content: SingleChildScrollView(
                child: Column(
                  children: const <Widget>[
                    Text('Your token has been expired.'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    try {
                      bool rememberMe = UserPreferences.rememberMe;
                      UserModel user = UserPreferences.user;
                      String compName = UserPreferences.compName;
                      await SharedPreferences.getInstance().then((value) {
                        value.clear();
                      });
                      if (rememberMe) {
                        UserPreferences.user = user;
                        UserPreferences.compName = compName;
                        UserPreferences.rememberMe = rememberMe;
                      }
                      await TopVariable.dashboardProvider.resetAppData();
                      Navigator.pop(context);
                      Navigator.of(appNavigationKey.currentContext!)
                          .popAndPushNamed(
                              '/login' /*, (Route<dynamic> route) => false*/);
                    } catch (e) {
                      if (kDebugMode) {
                        print('Exception ::: $e');
                      }
                    }
                  },
                )
              ],
            ));
      },
    );
  }
}
