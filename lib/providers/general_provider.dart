import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:solaramps/utility/shared_preference.dart';

class GeneralProvider extends ChangeNotifier {
  String? profilePicture;
  Map<String, dynamic> imgData =
      jsonDecode(UserPreferences.getString("userImageData") ?? "{}");

  GeneralProvider() {
    UserPreferences.user.acctId.toString() == imgData['acctId']
        ? profilePicture = imgData["userImage"]
        : profilePicture = null;
  }

  void updateProfilePicture(String? imagePath) {
    profilePicture = imagePath;
    Map<String, String> imgData = <String, String>{
      "userImage": imagePath!,
      "acctId": UserPreferences.user.acctId.toString()
    };
    UserPreferences.setString("userImageData", jsonEncode(imgData));
    notifyListeners();
  }
}
