import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:solaramps/dataModel/allTicketsModal.dart';
import 'package:solaramps/dataModel/create_ticket_subscriptions_model.dart';
import 'package:solaramps/dataModel/sub_cat_model.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/screens/home/home_bottom_sheet_one.dart';
import 'package:solaramps/screens/new_dashboard.dart';
import 'package:solaramps/shared/const/no_internet_screen.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:solaramps/widget/subscription_tile_widget.dart';
import 'package:solaramps/dataModel/all_categories_modal.dart';

class TicketsProvider extends ChangeNotifier {
  List<AllCategoriesModal>? allCategories;
  RxBool isLoadingForJustObs = false.obs;
  List<AllTicketsModal> allTickets = [];
  List<AllTicketsModal> allTicketsTemp = [];
  RxBool isLoadinggetAllTickets = false.obs;
  AllTicketsModal ticketById = AllTicketsModal();
  List<Widget> subscriptionList = [
    SubscriptionTile(
      subscriptionId: '1003',
      subscriptionStatus: 'ACTIVE',
    ),
  ];

  bool? _serviceEnabled;
  Location location = Location();
  PermissionStatus? _permissionGranted;
  RxBool isloadingForWeatherBottomSheetNew = false.obs;
  void fetchLocation() async {
    // // getAllTickets
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TopVariable.ticketsProvider.getAllTickets();
    });
    // Three Planted Factor
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await TopVariable.ticketsProvider
          .getCustomerInverterListForNewBottomSheet();
    });
    if (Platform.isAndroid) {
      isloadingForWeatherBottomSheetNew.value = true;
      if (kDebugMode) {
        print('Fetching Location for Weather Data :::::::::::: ');
      }
      _serviceEnabled = await location.serviceEnabled();
      if (kDebugMode) {
        print(
            'Fetching Location for _serviceEnabled 1:::::::::::: $_serviceEnabled');
        print(
            'Fetching Location for _serviceEnabled 2:::::::::::: ${!_serviceEnabled!}');
      }
      if (!_serviceEnabled!) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled!) {
          isloadingForWeatherBottomSheetNew.value = false;
          Get.snackbar('error', 'Serive enable issue',
              backgroundColor: Colors.red);
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (kDebugMode) {
        print(
            'Fetching Location for _permissionGranted 1:::::::::::: $_permissionGranted');
        print(
            'Fetching Location for _permissionGranted 2:::::::::::: ${_permissionGranted == PermissionStatus.denied}');
      }
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          isloadingForWeatherBottomSheetNew.value = false;
          Get.snackbar('error', 'permission granted issue',
              backgroundColor: Colors.red);
          return;
        }
      }

      // _locationData = await location.getLocation();
      var position = await GeolocatorPlatform.instance
          .getCurrentPosition(locationSettings: const LocationSettings());
      isloadingForWeatherBottomSheetNew.value = false;

      if (kDebugMode) {
        print('Fetching Location for _locationData 3:::::::::::: $position');
        print(
            'Fetching Location for _locationData 4:::::::::::: ${position.latitude} ${position.longitude}');
      }

      await TopVariable.dashboardProvider.fetchWeatherData(
          position.latitude.toString(), position.longitude.toString(), 'false');
      isloadingForWeatherBottomSheetNew.value = false;
    } else {
      isloadingForWeatherBottomSheetNew.value = true;
      var position = await GeolocatorPlatform.instance
          .getCurrentPosition(locationSettings: const LocationSettings());

      if (kDebugMode) {
        print('Fetching Location for _locationData 3:::::::::::: $position');
        print(
            'Fetching Location for _locationData 4:::::::::::: ${position.latitude} ${position.longitude}');
      }

      await TopVariable.dashboardProvider.fetchWeatherData(
          position.latitude.toString(), position.longitude.toString(), 'false');
      isloadingForWeatherBottomSheetNew.value = false;
    }
  }

  List<dynamic>? customerInvertersData;
  RxList<String> selectedIdsForBottomSheet = [''].obs;
  getCustomerInverterListForNewBottomSheet() async {
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }

    TopVariable.apiService.getCustomerInverterList().then((value) {
      customerInvertersData = value as List<dynamic>;
      List<String> ids = [];
      if (customerInvertersData!.isNotEmpty) {
        subscriptionsAPIData = customerInvertersData;

        for (int i = 0; i < customerInvertersData!.length; i++) {
          if (kDebugMode) {
            print('ID $i : = > ${customerInvertersData![i]['_id'].toString()}');
          }
          ids.add(customerInvertersData![i]['_id'].toString());
        }
        if (kDebugMode) {
          print('All IDs ::::  $ids');
        }
        loadTreePlantedWidgetsForNewBottomSheet(ids);

        notifyListeners();
      }
    });
  }

  Map<String, dynamic>? mappedResponseTreePlanted;
  RxList<DashboardTreeFactorItems> listOfTreePlanted =
      [DashboardTreeFactorItems('', '')].obs;
  RxBool isLoadingForTreePlanted = false.obs;
  RxBool isShowWidget = false.obs;
  loadTreePlantedWidgetsForNewBottomSheet(List<String> selectedIds) async {
    final Map<String, dynamic> requestBody = {
      "variantIds": selectedIds,
    };
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    isLoadingForTreePlanted.value = true;
    listOfTreePlanted.clear();
    isShowWidget.value = false;
    TopVariable.apiService
        .getDashboardTreeFactorWidgets(requestBody)
        .then((response) {
      if (kDebugMode) {
        print('getDashboardTreeFactorWidgets: $requestBody');
        print('getDashboardTreeFactorWidgets Response: $response');
      }
      mappedResponseTreePlanted = response as Map<String, dynamic>;
      Map<String, dynamic>? data =
          TopVariable.ticketsProvider.mappedResponseTreePlanted;
      if (data != null) {
        data.forEach((key, val) =>
            listOfTreePlanted.add(DashboardTreeFactorItems(key, val)));
        isShowWidget.value = true;
      }

      isLoadingForTreePlanted.value = false;
      notifyListeners();
      notifyListeners();
    });
  }

  RxInt totalSupportLength = 0.obs;
  RxInt closedSupportLength = 0.obs;
  RxInt openSupportLength = 0.obs;
  RxBool isLoadingForGetTickets = false.obs;
  RxList<GridListClass> gridList = <GridListClass>[].obs;
  RxBool switchValue = true.obs;
  Future<void> getAllTickets() async {
    try {
      isLoadingForGetTickets.value = true;
      bool _isInternetConnected = await BaseClientClass.isInternetConnected();
      if (!_isInternetConnected) {
        await Get.to(() => const NoInternetScreen());
      }

      var all = await TopVariable.apiService.getAllTicket();
      totalSupportLength.value = all.length;
      TopVariable.ticketsProvider.switchValue.value = true;
      switchValue.value = true;

      notifyListeners();
      if (all.isNotEmpty) {
        var open = all
            .where((element) => element.status.toLowerCase() == 'open')
            .toList();
        openSupportLength.value = open.length;
        var closed = all
            .where((element) => element.status.toLowerCase() == 'closed')
            .toList();
        closedSupportLength.value = closed.length;
        var allt = [...open.reversed, ...closed].toList();
        allTickets = allt;
        allTicketsTemp = allt;
        if (gridList.isEmpty) {
          gridList.add(
            GridListClass(
                '${TopVariable.ticketsProvider.openSupportLength.value} / ${TopVariable.ticketsProvider.totalSupportLength.value}'
                    .obs,
                'ACTIVE SUBSCRIPTIONS'.obs),
          );
          gridList.add(
            GridListClass('5380.50'.obs, 'TOTAL BILLS'.obs),
          );
          gridList.add(
            GridListClass('9408.50'.obs, 'PAYMENTS TILL DATE'.obs),
          );
          gridList.add(
            GridListClass(
                TopVariable.ticketsProvider.totalSupportLength.value
                    .toString()
                    .obs,
                'MESSAGES'.obs),
          );
        }
        isLoadingForGetTickets.value = false;

        notifyListeners();
        notifyListeners();
        notifyListeners();
      } else {
        isLoadingForGetTickets.value = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Length : getAllTickets $e');
      }
      isLoadingForGetTickets.value = false;
    }
  }

  RxBool crealteIsLoadingForGetTickets = false.obs;
  RxBool isLoadingCreateButton = false.obs;
  late final Future<List<AllSubscriptionsModal>> getLOVFutureFunc;
  late final Future<List<AllCategoriesModal>> getCategoryFutureFunc;
  late final Future<List<AllCategoriesModal>> getSubCategoryFutureFunc;
  late final Future<List<AllCategoriesModal>> getPriorityFutureFunc;
  RxList<AllSubscriptionsModalForCreateTicket> subscriptionListForCreateTicket =
      [AllSubscriptionsModalForCreateTicket()].obs;
  Future<void> getSubscriptionsForCreateTicket() async {
    try {
      crealteIsLoadingForGetTickets.value = true;
      bool _isInternetConnected = await BaseClientClass.isInternetConnected();
      if (!_isInternetConnected) {
        await Get.to(() => const NoInternetScreen());
      }

      var response = await TopVariable.apiService.getLov();
      if (kDebugMode) {
        print(
            'Response of getSubscriptions For Create Ticket :::::: $response');
      }
      subscriptionListForCreateTicket.value = response;
      crealteIsLoadingForGetTickets.value = false;
      getCategoryFutureFunc = TopVariable.apiService.getCategory();
      // getSubCategoryFutureFunc = TopVariable.apiService.getSubCategory(56);
      getPriorityFutureFunc = TopVariable.apiService.getPriority();
      notifyListeners();
      // if (all.isNotEmpty) {
      //   crealteIsLoadingForGetTickets.value = false;

      //   notifyListeners();
      //   notifyListeners();
      //   notifyListeners();
      // } else {
      //   crealteIsLoadingForGetTickets.value = false;
      // }
      crealteIsLoadingForGetTickets.value = false;
    } catch (e) {
      if (kDebugMode) {
        print('Length : getAllTickets $e');
      }
      crealteIsLoadingForGetTickets.value = false;
    }
  }

  RxList<PortalAttributeValuesTenant> allowFiles =
      [PortalAttributeValuesTenant()].obs;
  Future<void> getAllowFiles() async {
    try {
      crealteIsLoadingForGetTickets.value = true;
      bool _isInternetConnected = await BaseClientClass.isInternetConnected();
      if (!_isInternetConnected) {
        await Get.to(() => const NoInternetScreen());
      }
      allowFiles.clear();
      var response = await TopVariable.apiService.getAllowFiles();
      if (kDebugMode) {
        print('Response of getAllowFiles For Create Ticket :::::: $response');
      }
      allowFiles.value = response;
      if (allowFiles.isNotEmpty) {
        if (kDebugMode) {
          print(
              'Response of getAllowFiles For Create Ticket :::::: ${allowFiles[0].description}');
        }
      }
      crealteIsLoadingForGetTickets.value = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Length : getAllTickets $e');
      }
      crealteIsLoadingForGetTickets.value = false;
    }
  }

  List<dynamic>? subscriptionsAPIData;
  searchSubscriptions(String searchText) {
    subscriptionList.clear();
    subscriptionsAPIData?.forEach((subscription) {
      if (subscription['id'].toString().contains(searchText.toString())) {
        subscriptionList.add(SubscriptionTile(
          subscriptionId: subscription["id"].toString(),
          subscriptionStatus: subscription["subscriptionStatus"].toString(),
          garden: subscription["subscriptionTemplate"].toString(),
        ));
      }
    });
    notifyListeners();
  }

  getCustomerSubscription() async {
    subscriptionList.clear();
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    var all = await TopVariable.apiService
        .getCustomerSubscription(UserPreferences.user.acctId!);
    all as List<dynamic>;
    if (kDebugMode) {
      print(jsonEncode(all));
    }
    subscriptionsAPIData = all;
    subscriptionList.clear();
    List<Widget> temp = [];
    for (int i = 0; i < all.length; i++) {
      var sid = all[i]["id"].toString();
      var status = all[i]["subscriptionStatus"].toString();
      try {
        temp.add(SubscriptionTile(
          subscriptionId: sid,
          subscriptionStatus: status,
          garden: all[i]["subscriptionTemplate"].toString(),
        ));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    if (temp.isNotEmpty) {
      subscriptionList.addAll(temp);
      notifyListeners();
    }
    notifyListeners();
  }

  filterList(String text) {
    if (text.isEmpty) {
      allTickets = allTicketsTemp;
    } else {
      allTickets = allTicketsTemp
          .where((ticket) =>
              ticket.summary.toLowerCase().contains(text.toLowerCase()) ||
              ticket.id.toString().startsWith(text))
          .toList();
    }
    notifyListeners();
  }

  showOnlyOpenTickets() {
    allTickets = allTicketsTemp
        .where((ticket) => ticket.status.toLowerCase() == "open")
        .toList();
    notifyListeners();
  }

  getTicketById(int id) async {
    ticketById = await TopVariable.apiService.getConversationHead(id);
    notifyListeners();
  }
}
