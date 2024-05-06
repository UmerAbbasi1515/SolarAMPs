import 'dart:async';
import 'dart:convert';
// import 'package:connectivity/connectivity.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/shared/const/no_internet_screen.dart';
import 'package:solaramps/utility/app_url.dart';
import 'package:solaramps/utility/dialog/progress_dialog.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:solaramps/widget/error_dialog.dart';
import '../../dataModel/user_model.dart';

class Logging extends Interceptor {
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  // Platform messages are asynchronous, so we initialize in an async method.
  /*Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Could not check connectivity status error: $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }*/

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
  }

  // new
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          'Url ::::::::::: onRequest ::: => ${options.baseUrl}${options.path}');
    }
    if (options.path != AppUrl.signIn &&
        !options.path.contains(AppUrl.getCompanyKey) &&
        !options.path.contains(AppUrl.forgotPassword) &&
        !options.path.contains('/user/forgotPassword') &&
        !options.path.contains(AppUrl.verifyOTP) &&
        !options.path.contains(AppUrl.resetPassword)) {
      if (UserPreferences.token != "") {
        bool isToken = JwtDecoder.isExpired(UserPreferences.token ?? '');
        if (isToken) {
          _tokenExpiredDialog();
        }
      } else {
        if (kDebugMode) {
          print('Inside 4th Condition ::: 4');
        }
        if (kDebugMode) {
          print('Token is not available now ::: ');
        }
      }
    }

    CustomProgressDialog.showProDialog();

    if (options.path != AppUrl.signIn &&
        !options.path.contains(AppUrl.getCompanyKey) &&
        !options.path.contains(AppUrl.forgotPassword) &&
        !options.path.contains('/user/forgotPassword') &&
        !options.path.contains(AppUrl.verifyOTP) &&
        !options.path.contains(AppUrl.resetPassword)) {
      String token = UserPreferences.token!;
      options.headers
          .addEntries([MapEntry("Authorization", "Bearer " + token)]);
    }

    return super.onRequest(options, handler);
  }
  // void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  //   /*CheckConnectivity.isConnected().then((statusConnected) {
  //     if(statusConnected){*/
  //   if (kDebugMode) {
  //     print(
  //         'TOKEN: ${UserPreferences.token ?? ''} => REQUEST: ${options.method} => PATH: ${options.baseUrl}${options.path}  parms: ${options.queryParameters}');
  //   }
  //   if (UserPreferences.token != "") {
  //     bool isToken = JwtDecoder.isExpired(UserPreferences.token ?? '');
  //     if (isToken) {
  //       _tokenExpiredDialog();
  //     }
  //   }
  //   CustomProgressDialog.showProDialog();

  //   if (options.path != AppUrl.signIn &&
  //       !options.path.contains(AppUrl.getCompanyKey) &&
  //       !options.path.contains(AppUrl.forgotPassword) &&
  //       !options.path.contains(AppUrl.verifyOTP) &&
  //       !options.path.contains(AppUrl.resetPassword)) {
  //     String token = UserPreferences.token!;
  //     options.headers
  //         .addEntries([MapEntry("Authorization", "Bearer " + token)]);
  //   }
  //   /*} else{
  //       showErrorDialog('Please check your Internet connection');
  //     }
  //   });*/
  //   return super.onRequest(options, handler);
  // }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    CustomProgressDialog.hideProDialog();
    if (kDebugMode) {
      print(
        'RESPONSE[${response.statusCode}] => DATA: ${response.data}',
      );
      print(
        'RESPONSE[${response.realUri}] => DATA: ${response.statusMessage}',
      );
    }
    /*if(response.statusCode!.isOdd){
      showErrorDialog('API status message...\n'+response.statusMessage.toString()+'\n'+response.data.toString());
    }*/
    /*if(response.data['message'] == 'Invalid Token or Token Expired') {
    //  _tokenExpiredDialog(SosController.appNavigationKey.currentContext!);
    } else if(response.data['error'] == 1){
        showErrorDialog(response.data['message']);
      }*/
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    CustomProgressDialog.hideProDialog();
    Map<String, dynamic> errMsg =
        json.decode((err.response ?? '{}').toString());

    /*if(err.response==null){
      showErrorDialog(err.toString());
    }*/

    if (kDebugMode) {
      print('Error :: 0 ==> $err');
      print('Error :: 1 ==> ${errMsg['message'].toString()}');
      print('Error :: 2 ==> ${errMsg['status'].toString()}');
    }

    // Map<String, dynamic> url =
    //     json.decode((err.requestOptions.baseUrl).toString());
    // if (kDebugMode) {
    //   print('BaseUrl:::::: $url');
    // }

    if (errMsg['message'].toString() == 'Invalid UserName or Password' &&
        errMsg['status'].toString() == '401') {
      showErrorDialog('Invalid UserName or Password', 'Error');
      return;
    }
    if (errMsg['message'].toString() ==
            'You do not have permission to login on mobile' &&
        errMsg['status'].toString() == '403') {
      showErrorDialog('You do not have permission to login on mobile', 'Error');
      return;
    }

    if (errMsg['status'] == 101) {
      showErrorDialog('Please check your internet connection', 'Error');
    } else if (errMsg['message'].toString().isNotEmpty &&
        errMsg['message'].toString() != 'null') {
      showErrorDialog(
          errMsg['error'].toString() == 'null'
              ? 'Something went wrong'
              : errMsg['message'].toString(),
          '');
    } else if (errMsg['status'] == 500) {
      showErrorDialog(
          errMsg['error'].toString() == 'null'
              ? 'Something went wrong'
              : errMsg['error'].toString(),
          'Error');
    } else if (errMsg['status'].toString() == '404') {
      showErrorDialog(
          errMsg['error'].toString() == 'null'
              ? 'Somethinf went wrong'
              : errMsg['message'].toString(),
          'Error');
    } else if (errMsg['error'].toString().isNotEmpty &&
        errMsg['error'].toString() != 'null') {
      showErrorDialog(
          errMsg['error'].toString() == 'null'
              ? 'Somethinf went wrong'
              : errMsg['error'].toString(),
          '');
    } else if (errMsg['status'] == 401) {
      _tokenExpiredDialog();
    } else if (err.type == DioErrorType.connectTimeout ||
        err.type == DioErrorType.receiveTimeout) {
      if (err.toString().contains('Receiving data timeout[7000ms]') ||
          err.toString().contains('Connecting timed out [70000ms]')) {
        bool _isInternetConnected = await BaseClientClass.isInternetConnected();
        if (!_isInternetConnected) {
          await http.Get.to(() => const NoInternetScreen());
          return;
        }
      }
      showErrorDialog(
          err.toString().contains('Receiving data timeout[7000ms]')
              ? 'Connection time out,Please check your internet connection'
              : err.toString().split(':')[1],
          'Error');
    } else if (err.toString().contains('No address associated with hostname')) {
      showErrorDialog('Something went wrong', 'Error');
      // showErrorDialog('Please check your internet connection');
      // connectivitySubscription = Connectivity()
      //     .onConnectivityChanged
      //     .listen((ConnectivityResult result) {
      //   if (result == ConnectivityResult.mobile ||
      //       result == ConnectivityResult.wifi) {
      //     TopVariable.dashboardProvider.getCustomerInverterList();
      // }
      // });
    } else {
      showErrorDialog('Something went wrong', 'Error');
    }
    if (kDebugMode) {
      print(
        'Interceptor Error:\t ${err.toString()} => PATH: ${err.requestOptions.path} \t\t status code: ${err.response?.statusCode}',
      );
    }
    /*if(err.response?.statusCode==101){
      //showErrorDialog('Network is unreachable');
    } else{
     // showErrorDialog(err.error.message);
    }*/

    return super.onError(err, handler);
  }

  _tokenExpiredDialog() async {
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
