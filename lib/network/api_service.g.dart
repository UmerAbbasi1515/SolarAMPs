// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://bestage.azurewebsites.net/solarapi';
  }

  final Dio _dio;

  String? baseUrl;
  // get company name api
  @override
  Future<dynamic> signIn(compKey, body) async {
    if (kDebugMode) {
      print('Company Key For Testing inside Sign in Func :: $compKey');
    }
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Comp-Key': compKey};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/signin',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    if (kDebugMode) {
      print('Value :::::: $value');
    }
    return value;
  }

  // get company name api
  @override
  Future<dynamic> getCompanyKey(identifier) async {
    if (kDebugMode) {
      print(':::::::: getCompanyKey');
    }
    Dio _dio1 = Dio();
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'GET', headers: {}, extra: _extra)
            .compose(_dio1.options, '/user/getLoginUrlLike/${identifier}',
                // .compose(_dio.options, '/company/compkey/${identifier}',
                queryParameters: queryParameters,
                data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));

    final value = _result.data;
    if (kDebugMode) {
      print('Value :::::: $value');
    }
    return value;
  }

  @override
  Future<dynamic> getCustomerInverterAllowedSelection(compKey) async {
    if (kDebugMode) {
      print(
          'Comp Key ::::: inside getCustomerInverterAllowedSelection :::: ${UserPreferences.compKey}');
    }
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    // final _headers = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Comp-Key': compKey};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(
            _dio.options, '/tenantConfig/getByParameter/NumberOfSitesAllowed',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    if (kDebugMode) {
      print('Value of getCustomerInverterAllowedSelection :::::::: $_result');
    }
    final value = _result.data;
    if (kDebugMode) {
      // print(
      //     'Value of getCustomerInverterAllowedSelection 1:::::::: ${value["text"]}');
    }
    return value;
  }

  @override
  Future<dynamic> getCustomerInverterSelectionExceedMsg(identifier) async {
    if (kDebugMode) {
      print(':::::::: identifier ::::::::: $identifier');
    }
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options,
                '/monitoringDashboard/validateSitesCount?count=${identifier}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    if (kDebugMode) {
      print('Value of getCustomerInverterSelectionExceedMsg :::::::: $_result');
    }
    final value = _result.data;
    if (kDebugMode) {
      print('Value of getCustomerInverterSelectionExceedMsg :::::::: $value');
    }
    return value;
  }

  @override
  Future<dynamic> getWeatherOfSites(identifier) async {
    if (kDebugMode) {
      print('URL ::::::::: /weather/weather-widget-data?gardenIds=$identifier');
    }
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options,
                '/weather/weather-widget-data?gardenIds=${identifier}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    if (kDebugMode) {
      print('Value :::: Iside Repo :::::: $value');
    }
    return value;
  }

  @override
  Future<dynamic> getWeatherFoerCastOfSites(identifier) async {
    if (kDebugMode) {
      print(
          'URL ::::::::: /weather/getWeatherDataForFiveAndSevenDays?gardenIds=${identifier[0]}&numberOfDays=${identifier[1]}');
      print('Comp Key ::::::::: ${identifier[2]}');
    }
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    // final _headers = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Comp-Key': identifier[2]};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/weather/getWeatherDataForFiveAndSevenDays?gardenIds=${identifier[0]}&numberOfDays=${identifier[1]}',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;

    if (kDebugMode) {
      print('Value :1::::: $value');
    }
    List parsedList = value.toList();
    if (kDebugMode) {
      print('Value :2::::: $parsedList');
      print('Value :2::::: ${parsedList.length}');
    }
    return parsedList;
  }

  @override
  Future<dynamic> getCustomerInverterList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/subscription/customerInverterVariantSubscriptions/v2',
            // => v1
            // .compose(_dio.options, '/subscription/getSubscriptionsByUserId/$userID',
            // => v0
            // _dio.options,
            // '/subscription/customerInverterSubscriptionList',
            queryParameters: queryParameters,
            data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    if (kDebugMode) {
      print('Value of getCustomerInverterList :::::::: $_result');
    }
    final value = _result.data;
    if (kDebugMode) {
      print('Value of getCustomerInverterList :::::::: $value');
    }
    return value;
  }

  @override
  Future<dynamic> getCustomerSubscriptionsList() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    var userID = UserPreferences.user.acctId ?? 0;
    if (kDebugMode) {
      print(
          'URl :::::: ====> ${'/subscription/getSubscriptionsByUserId/$userID'}');
    }
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(
                _dio.options, '/subscription/getSubscriptionsByUserId/$userID',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    if (kDebugMode) {
      print('Value of getCustomerSubscriptionsList :::::::: $_result');
    }
    final value = _result.data;
    if (kDebugMode) {
      print('Value of getCustomerSubscriptionsList :::::::: $value');
    }
    return value;
  }

  @override
  Future<dynamic> getDashboardTreeFactorWidgets(body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);

    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/monitoringDashboard/getSitesWidgetData',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

// => v1
  @override
  Future<dynamic> getDashboardYieldWidgets(body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);

    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/monitoringDashboard/getYieldWidgetData',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  // => v0
  // @override
  // Future<dynamic> getDashboardWidgets(body) async {
  //   const _extra = <String, dynamic>{};
  //   final queryParameters = <String, dynamic>{};
  //   final _headers = <String, dynamic>{};
  //   final _data = <String, dynamic>{};
  //   _data.addAll(body);
  //   final _result = await _dio.fetch(_setStreamType<dynamic>(
  //       Options(method: 'POST', headers: _headers, extra: _extra)
  //           .compose(_dio.options, '/monitor/getCurrentWidgetData',
  //               queryParameters: queryParameters, data: _data)
  //           .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  //   final value = _result.data;
  //   return value;
  // }

  @override
  Future<dynamic> getDailyGraphDataCommulative(queries, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                '/monitoringDashboard/getCumulativeGraphData?graphType=daily',
                // .compose(_dio.options, '/monitor/getCurrentGraphData',
                queryParameters: queryParameters,
                data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getMonthlyGraphDataCommulative(queries, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                '/monitoringDashboard/getCumulativeGraphData?graphType=monthly',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getYearlyGraphDataCommulative(queries, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options,
                '/monitoringDashboard/getCumulativeGraphData?graphType=yearly',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getDailyGraphDataComparative(queries, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
            method: 'POST', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/monitoringDashboard/getSiteComparativeGraphData?graphType=daily',
            // .compose(_dio.options, '/monitor/getCurrentGraphData',
            queryParameters: queryParameters,
            data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getMonthlyGraphDataComparative(queries, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
            method: 'POST', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/monitoringDashboard/getSiteComparativeGraphData?graphType=monthly',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getYearlyGraphDataComparative(queries, body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
            method: 'POST', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/monitoringDashboard/getSiteComparativeGraphData?graphType=yearly',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<AllTicketsModal>> getAllTicket() async {
    try {
      var _result = await BaseClientClass.getWithToken(
          AppUrl.baseUrl + '/conversation/conversationHead?flag=ext');
      // ignore: prefer_typing_uninitialized_variables
      List parsedList = json.decode(_result.body);
      List<AllTicketsModal> list =
          parsedList.map((val) => AllTicketsModal.fromJson(val)).toList();

      return list;
    } catch (e) {
      if (kDebugMode) {
        print('getTicket calling :::: $e');
      }
      return <AllTicketsModal>[];
    }
  }

  // support get tickets
  @override
  Future<dynamic> getAllTickets() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/conversation/conversationHead?flag=ext',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<AllCategoriesModal>> getCategory() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return [];
    }
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<AllCategoriesModal>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/portalAttributeValue/attributeById/52',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            AllCategoriesModal.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<AllSubscriptionsModalForCreateTicket>> getLov() async {
    // const _extra = <String, dynamic>{};
    // final queryParameters = <String, dynamic>{};
    // final _headers = <String, dynamic>{};
    // final _data = <String, dynamic>{};
    var userID = UserPreferences.user.acctId ?? 0;
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return [];
    }
    // final _result = await _dio.fetch(
    //     _setStreamType<List<AllSubscriptionsModal>>(Options(
    //             method: 'GET', headers: _headers, extra: _extra)
    //         .compose(
    //             _dio.options, '/subscription/getSubscriptionsByUserId/$userID',
    //             queryParameters: queryParameters, data: _data)
    //         .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    // var value = _result.data!['data']
    //     .map((dynamic i) =>
    //         AllSubscriptionsModal.fromJson(i as Map<String, dynamic>))
    //     .toList();

    // if (kDebugMode) {
    //   print('Result of AllSubscriptionsModal value inside Repo :::: $value');
    //   print(
    //       'Result of AllSubscriptionsModal value inside Repo :::: ${value.first.variantName}');
    // }
    // return value as List<AllSubscriptionsModal>;

    var _result = await BaseClientClass.getWithToken(
        AppUrl.baseUrl + '/subscription/customerSubscription/user/$userID');
    // var _result = await BaseClientClass.getWithToken(
    //     AppUrl.baseUrl + '/subscription/getSubscriptionsByUserId/$userID');

    var jsonData = json.decode(_result.body);
    if (kDebugMode) {
      print('jsonData :::::: $jsonData');
      print(
          'URL :::LOV::: ${AppUrl.baseUrl + '/subscription/customerSubscription/user/$userID'}');
    }
    List parsedList = jsonData;
    if (kDebugMode) {
      print('parsedList ::::of LOV :: $parsedList');
    }
    List<AllSubscriptionsModalForCreateTicket> list = parsedList
        .map((val) => AllSubscriptionsModalForCreateTicket.fromJson(val))
        .toList();
    if (kDebugMode) {
      print('list :::LOV::: $list');
    }
    return list;
    // List parsedList = jsonData["data"];
    // if (kDebugMode) {
    //   print('parsedList ::::of LOV :: $parsedList');
    // }
    // List<AllSubscriptionsModal> list =
    //     parsedList.map((val) => AllSubscriptionsModal.fromJson(val)).toList();
    // if (kDebugMode) {
    //   print('list :::LOV::: $list');
    // }
    // return list;
  }

  @override
  Future<List<PortalAttributeValuesTenant>> getAllowFiles() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return [];
    }

    final _result = await _dio.fetch<dynamic>(_setStreamType<SubCategoryModel>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/portalAttribute/49',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var portalAttributeValuesTenantList =
        _result.data['portalAttributeValuesTenant'];
    List parsedList = portalAttributeValuesTenantList;
    List<PortalAttributeValuesTenant> list = parsedList
        .map((val) => PortalAttributeValuesTenant.fromJson(val))
        .toList();
    if (kDebugMode) {
      print('list :::portalAttributeValuesTenant:::=>getAllowFiles $list');
    }
    return list;
  }

  @override
  Future<List<PortalAttributeValuesTenant>> getSubCategory(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return [];
    }
    if (kDebugMode) {
      print('Category ID after Selection of Cat :::: $id');
    }
    //SubCategoryModel
    final _result = await _dio.fetch<dynamic>(
      _setStreamType<SubCategoryModel?>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/portalAttribute/name/${id}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl),
      ),
    );
    var portalAttributeValuesTenantList =
        _result.data['portalAttributeValuesTenant'];
    List parsedList = portalAttributeValuesTenantList;
    List<PortalAttributeValuesTenant> list = parsedList
        .map((val) => PortalAttributeValuesTenant.fromJson(val))
        .toList();
    if (kDebugMode) {
      print('list :::portalAttributeValuesTenant:::=> getSubCategory $list');
    }
    return list;
  }
  // @override
  // Future<List<AllCategoriesModal>> getSubCategory(id) async {
  //   const _extra = <String, dynamic>{};
  //   final queryParameters = <String, dynamic>{};
  //   final _headers = <String, dynamic>{};
  //   final _data = <String, dynamic>{};
  //   bool _isInternetConnected = await BaseClientClass.isInternetConnected();
  //   if (!_isInternetConnected) {
  //     await Get.to(() => const NoInternetScreen());
  //     return [];
  //   }
  //   if (kDebugMode) {
  //     print('Category ID after Selection of Cat :::: $id');
  //   }
  //   final _result = await _dio.fetch<List<dynamic>>(
  //       _setStreamType<List<AllCategoriesModal>>(
  //           Options(method: 'GET', headers: _headers, extra: _extra)
  //               .compose(
  //                   _dio.options, '/portalAttributeValue/attributeById/${id}',
  //                   queryParameters: queryParameters, data: _data)
  //               .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  //   var value = _result.data!
  //       .map((dynamic i) =>
  //           AllCategoriesModal.fromJson(i as Map<String, dynamic>))
  //       .toList();
  //   return value;
  // }

  @override
  Future<dynamic> closeTickets(body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'PUT', headers: _headers, extra: _extra)
            .compose(_dio.options, '/conversation/conversationHead',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<AllCategoriesModal>> getPriority() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return [];
    }
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<AllCategoriesModal>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/portalAttributeValue/attributeById/51',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            AllCategoriesModal.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> forgotPassword(compKey, body) async {
    // const _extra = <String, dynamic>{};
    // final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Comp-Key': compKey,
      "Content-Type": "application/json",
    };
    final _data = <String, dynamic>{};
    _data.addAll(body);
    if (kDebugMode) {
      print('Headers::::  $_headers');
      print('Data::::  $_data');
    }
    // final _result = await _dio.fetch(_setStreamType<dynamic>(
    //     Options(method: 'POST', headers: _headers, extra: _extra)
    //         .compose(_dio.options, '/user/forgotPassword',
    //             queryParameters: queryParameters, data: _data)
    //         .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));

    var _result = await BaseClientClass.postWithoutTokenWithCompKey(
        AppUrl.baseUrl + '/user/forgetPassword', _data, compKey.toString());
    if (_result is String) {
      if (kDebugMode) {
        print('Inside :::: IF');
        print('URL :::::: ${AppUrl.baseUrl + '/user/forgetPassword'}');
        print('RESULT :::::: $_result');
      }
      return _result;
    }
    var res = jsonDecode(_result.body);
    if (kDebugMode) {
      print('OutSIde :::: IF');
      print('URL :::::: ${AppUrl.baseUrl + '/user/forgetPassword'}');
      print('RESULT :::::: $res');
    }
    return res;
  }
  // @override
  // Future<dynamic> forgotPassword(email, compKey, requestType) async {
  //   const _extra = <String, dynamic>{};
  //   final queryParameters = <String, dynamic>{};
  //   final _headers = <String, dynamic>{r'Comp-Key': compKey};
  //   _headers.removeWhere((k, v) => v == null);
  //   final _data = <String, dynamic>{};
  //   final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
  //           method: 'GET', headers: _headers, extra: _extra)
  //       .compose(
  //           _dio.options, '/forgotPassword/generateOtp/${email}/${requestType}',
  //           queryParameters: queryParameters, data: _data)
  //       .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  //   final value = _result.data;
  //   return value;
  // }

  @override
  Future<dynamic> verifyOTP(email, otp, compKey) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Comp-Key': compKey};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/forgotPassword/verifyOtp/${email}/${otp}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> resetPassword(body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/forgotPassword/resetPasswordByEmail',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<AllTicketsModal> getConversationHead(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AllTicketsModal>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/conversation/conversationHead/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AllTicketsModal.fromJson(_result.data!);
    return value;
  }

  @override
  Future<dynamic> getCustomerAddresses(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/physicalLocation/getAllPhysicalLocationByEntityId/entityId/${id}',
            // .compose(_dio.options, '/address/getUser/${id}',
            queryParameters: queryParameters,
            data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getCustomerPaymentInfo(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/paymentInfo/user/${id}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;

    return value;
  }

  @override
  Future<dynamic> getDecodedPaymentInfo(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/paymentInfo/decode/${id}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getCustomerSubscription(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(
                _dio.options, '/subscription/customerSubscription/user/${id}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getSliderResources() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(
        Options(method: 'GET', headers: _headers, extra: _extra)
            .compose(_dio.options, '/systemAttribute/carousel/channel/mobile',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
