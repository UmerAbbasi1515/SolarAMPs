import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:solaramps/dataModel/client_user_detail_model.dart';
import 'package:solaramps/dataModel/user_profile_set_image_model.dart';
import 'package:solaramps/dataModel/user_profile_um_model.dart';
import 'package:solaramps/repository_/user_profile_screen_repository.dart';
import 'package:solaramps/utility/shared_preference.dart';

class UserProfileScreenController extends GetxController {
  UserProfileGetUserDetailModel getClientUserDetailModel =
      UserProfileGetUserDetailModel();
  UserProfileGetUserProfileModel getUserProfileModel =
      UserProfileGetUserProfileModel();
  RxBool loadingData = false.obs;
  String entityId = '';
  void getClientUserDetail() async {
    try {
      loadingData.value = true;
      getUserProfileDetail();
      var id = UserPreferences.user.acctId;
      var result =
          await UserProfileScreenRepository.getClientUserDetail(id.toString());

      loadingData.value = false;
      getClientUserDetailModel = result;
      if (kDebugMode) {
        print('Client ID :::::: ${getClientUserDetailModel.entityId}');
      }
      UserPreferences.setEntityID =
          getClientUserDetailModel.entityId.toString();
      entityId = getClientUserDetailModel.entityId.toString();
      getUserProfileImage(getClientUserDetailModel.entityId.toString());
    } catch (e) {
      loadingData.value = false;
      if (kDebugMode) {
        print('Exception in Controller :::: $e');
        print('Exception in Controller :::: ${e.toString()}');
      }
    }
  }

  RxBool loadingDataForProfileImage = false.obs;
  RxString profileImagePath = ''.obs;
  void getUserProfileImage(String id) async {
    try {
      loadingDataForProfileImage.value = true;
      if (kDebugMode) {
        print('Entity ID :::::: in Profile Image func ::::::: $id');
      }
      var result =
          await UserProfileScreenRepository.getUserProfileImage(id.toString());
      if (result.uri.isEmpty) {
        profileImagePath.value = '';
        // 'https://cdn.britannica.com/85/162485-050-7670426D/Solar-panel-array-rooftop.jpg';
      } else {
        profileImagePath.value = result.uri;
      }

      if (kDebugMode) {
        print('Image Path ::::::: ${profileImagePath.value}');
      }
      loadingDataForProfileImage.value = false;
    } catch (e) {
      loadingData.value = false;
      if (kDebugMode) {
        print('Exception in Controller :::: $e');
        print('Exception in Controller :::: ${e.toString()}');
      }
      loadingDataForProfileImage.value = false;
    }
  }

  Future<void> saveUserProfileImage(String id, imagePath) async {
    try {
      loadingDataForProfileImage.value = true;
      if (kDebugMode) {
        print('Image Path ::::::: $imagePath');
        print('ID ::::::: $id');
      }
      SaveProfileImageModel result =
          await UserProfileScreenRepository.saveUserProfileImage(
              id.toString(), imagePath);

      // ignore: unnecessary_type_check
      if (result is SaveProfileImageModel) {
        if (kDebugMode) {
          print(
              'saveUser ProfileImage:::Image Path:::: ${result.data!.uri ?? ""}');
        }
        profileImagePath.value = result.data!.uri ?? "";
      } else {
        getUserProfileImage(id);
      }

      loadingDataForProfileImage.value = false;
    } catch (e) {
      loadingData.value = false;
      if (kDebugMode) {
        print('Exception in Controller saveUserProfileImage:::: $e');
        print(
            'Exception in Controller saveUserProfileImage:::: ${e.toString()}');
      }
      loadingDataForProfileImage.value = false;
    }
  }

  getUserProfileDetail() async {
    try {
      loadingData.value = true;
      var id = UserPreferences.user.acctId;
      var result =
          await UserProfileScreenRepository.getUserProfileDetail(id.toString());

      loadingData.value = false;
      getUserProfileModel = result;
      UserPreferences.setString('userName',
          '${getUserProfileModel.data!.firstName ?? ""} ${getUserProfileModel.data!.lastName ?? ""}');
      if (kDebugMode) {
        print('User Name :::: ${UserPreferences.getString('userName')}');
      }
      update();
    } catch (e) {
      loadingData.value = false;
      if (kDebugMode) {
        print('Exception in Controller :::: $e');
        print('Exception in Controller :::: ${e.toString()}');
      }
    }
  }
}
