import 'package:shared_preferences/shared_preferences.dart';
import 'package:solaramps/dataModel/user_model.dart';
import 'package:solaramps/utility/constants.dart';
import 'dart:convert';
// import '../domain/data/wallet.dart';
// import '../domain/user.dart';

late SharedPreferences prefs;
initializePreferences() async {
  prefs = await SharedPreferences.getInstance();
}

class UserPreferences {
  static int? get compKey => prefs.getInt(Constants.keyCompKey);
  static set compKey(int? compKey) {
    prefs.setInt(Constants.keyCompKey, compKey!);
  }

  static String? getString(String name) => prefs.getString(name);
  static setString(String name, String value) {
    prefs.setString(name, value);
  }

  static Future<bool> removeV(String name) async => await prefs.remove(name);

  static void clear() async {
    await prefs.clear();
  }

  static String get getAllowedSiteSelectionVal =>
      prefs.getString(
        Constants.keyAllowedSiteSelectionVal,
      ) ??
      '';
  static set setAllowedSiteSelectionVal(String? val) {
    prefs.setString(Constants.keyAllowedSiteSelectionVal, val!);
  }

  static String get compName =>
      prefs.getString(
        Constants.keyCompName,
      ) ??
      '';
  static set compName(String? compName) {
    prefs.setString(Constants.keyCompName, compName!);
  }

  static List get imagerUrlGet =>
      prefs.getStringList(
        Constants.keyImagesUrl,
      ) ??
      [''];
  static set imagerUrlSet(List<String> images) {
    prefs.setStringList(Constants.keyImagesUrl, images);
  }

  static set compIDRememberMe(bool compIDRememberMe) {
    prefs.setBool(Constants.compIDRememberMe, compIDRememberMe);
  }

  static bool get compIDRememberMeGet =>
      prefs.getBool(Constants.compIDRememberMe) ?? false;

  static bool get rememberMe => prefs.getBool(Constants.keyRememberMe) ?? false;
  static set rememberMe(bool? rememberMe) {
    prefs.setBool(Constants.keyRememberMe, rememberMe!);
  }

  static String? get tenantLogoPath => prefs.getString(
        Constants.keyTenantLogoPath,
      );
  static set tenantLogoPath(String? tenantLogoPath) {
    prefs.setString(Constants.keyTenantLogoPath, tenantLogoPath!);
  }

  static String? get token => prefs.getString(
        Constants.keyTokenBearer,
      );
  static set token(String? token) {
    prefs.setString(Constants.keyTokenBearer, token ?? "");
  }

  static bool get firstInstall =>
      prefs.getBool(Constants.FIRST_INSTALL) ?? false;
  static set firstInstall(bool firstInstall) {
    prefs.setBool(Constants.FIRST_INSTALL, firstInstall);
  }

  /*setCompKey(String compKey){
    prefs.setString(keyCompKey,compKey);
  }*/

  static UserModel get user {
    return UserModel.fromJson(
        json.decode(prefs.getString(Constants.keyUser) ?? '{}'));
  }

  static set user(UserModel user) {
    prefs.setString(Constants.keyUser, json.encode(user.toJson()));
  }

  static set setEntityID(String entityID) {
    prefs.setString(Constants.entityID, entityID);
  }

  static Future<String?> getEntityID() async {
    return prefs.getString(Constants.entityID);
  }

  static void removeUser() async {
    //  final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('phone');
    prefs.remove('type');
    prefs.remove('token');
    prefs.remove('client_id');
    prefs.remove('site_id');
  }

  static String getToken() {
    return prefs.getString("token") ?? '';
  }

  static Future<void> sessionCount() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('completed_job', prefs.getInt("completed_job")! + 1);
  }

  static Future<int?> getSessionCount() async {
    //  final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? sessionCount = prefs.getInt("completed_job");
    return sessionCount;
  }

  static void removeSessionData() async {
    //  final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('session_data');
  }

  static Future<bool> sessionDataAvailable() async {
    //  final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('session_data');
  }

  static Future<void> setBalance(balance) async {
    //  final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('balance', balance);
  }

  static Future<String?> getBalance() async {
    //  final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('balance');
  }

  static Future<void> setMissedBookOffSessionId(sessionId) async {
    //  final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('missed_book_off_session_id', sessionId);
  }

  static Future<bool> isMissedBookOffSOSAlreadyRaised(
      String sessionIdToCheck) async {
    //  final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("missed_book_off_session_id");
    if (sessionId != null) {
      if (sessionIdToCheck == sessionId) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
