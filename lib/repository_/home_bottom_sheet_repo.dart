import 'package:flutter/foundation.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/utility/app_url.dart';
import 'package:http/http.dart' as http;

class HomeBottomSheetRepository {
  static Future<dynamic> getCompanyImagesLike(String value) async {
    try {
      var url =
          '${AppUrl.baseUrl + AppUrl.getLoginUrlLike + value.toLowerCase()}?isMobileLanding=true';
      if (kDebugMode) {
        print('Url :::::: $url');
      }
      var response = await BaseClientClass.getWithToken(url);
      if (kDebugMode) {
        print('Url :::::: $response');
      }
      if (response is http.Response) {
        // List parsedList = json.decode(response.body);
        // List<GetCompanyNameLikeModel> list = parsedList
        //     .map((val) => GetCompanyNameLikeModel.fromJson(val))
        // .toList();
        if (kDebugMode) {
          print('Response::::::: Repo1 :::: $response');
          print('Response::::::: Repo2 :::: ${response.body}');
        }
        return [];
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
