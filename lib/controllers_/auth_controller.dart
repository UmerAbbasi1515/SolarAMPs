import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:solaramps/model_/company_login.dart';
import 'package:solaramps/model_/get_company_name_model.dart';
import 'package:solaramps/repository_/auth_repository.dart';
import 'package:solaramps/screens/login_tenant.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/widget/error_dialog.dart';

class AuthController extends GetxController {
  RxString username = ''.obs, password = ''.obs;

  RxBool loadingData = false.obs;
  RxBool loadingDataCSignIn = false.obs;
  RxBool isHide = false.obs;
  List<GetCompanyNameLikeModel> getCompanyNameLikeList = [];
  @override
  void onInit() {
    if (kDebugMode) {
      print('Looking');
      username.value = '';
      password.value = '';
      update();
    }
    super.onInit();
  }

  void getCompanyNameLike(String value) async {
    try {
      loadingData.value = true;
      var result = await AuthRepository.getCompanyNameLike(value);
      loadingData.value = false;
      getCompanyNameLikeList = result;
      if (getCompanyNameLikeList.isEmpty) {
        await showErrorDialog('No Company Found', '');
        isHide.value = true;
        update();
        return;
      }
    } catch (e) {
      loadingData.value = false;
      if (kDebugMode) {
        print('Exception in Controller :::: getCompanyNameLike $e');
        print(
            'Exception in Controller ::::  getCompanyNameLike ${e.toString()}');
      }
    }
  }

  GetCompanyKeyModel getCompanyKeyModel = GetCompanyKeyModel();
  companySignIn(String value) async {
    try {
      loadingDataCSignIn.value = true;
      var result = await AuthRepository.companySignIn(value.trim());
      loadingDataCSignIn.value = false;
      getCompanyKeyModel = result;
      if (result == 'No internet connection') {
        showErrorDialog("No internet connection", 'Error');
        return;
      }
      if (getCompanyKeyModel.compKey != null) {
        UserPreferences.compKey = getCompanyKeyModel.compKey;
        UserPreferences.tenantLogoPath = getCompanyKeyModel.companyLogo;
        UserPreferences.compName = getCompanyKeyModel.companyName;
        isHide.value = false;
        Get.to(() => const LoginTenantPage());
      } else {
        showErrorDialog("Company Not found", '');
        loadingDataCSignIn.value = false;
      }
    } catch (e) {
      loadingDataCSignIn.value = false;
      if (kDebugMode) {
        print('Exception in Controller :::: $e');
        print('Exception in Controller :::: ${e.toString()}');
      }
    }
  }

  void userSignIn(String userName, password) async {
    try {
      loadingData.value = true;
      var result = await AuthRepository.userSignIn(userName, password);
      loadingData.value = false;
      if (kDebugMode) {
        print('Result userSignIn:::: $result');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception in Controller :::: $e');
        print('Exception in Controller :::: ${e.toString()}');
      }
    }
  }
}
