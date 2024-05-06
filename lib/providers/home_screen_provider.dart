import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:solaramps/dataModel/slider_images_modal.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/shared/const/no_internet_screen.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class HomeScreenProvider extends ChangeNotifier {
  List<SliderImageList>? sliderImages;

  Future<void> getSliderImages() async {
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    TopVariable.apiService.getSliderResources().then((value) {
      SliderImagesModal image =
          SliderImagesModal.fromJson(value as Map<String, dynamic>);
      sliderImages = image.attributeValue;
      notifyListeners();
    });
  }
}
