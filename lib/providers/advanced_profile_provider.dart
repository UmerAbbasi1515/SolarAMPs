import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/shared/const/no_internet_screen.dart';
import 'package:solaramps/utility/shared_preference.dart';
import '../utility/top_level_variables.dart';
import '../widget/address_tile_widget.dart';
import '../widget/payment_method_tile_widget.dart';

class AdvancedProfileProvider extends ChangeNotifier {
  List<dynamic>? subscriptionsAddressesAPIData, customerPaymentInfoAPIData;
  bool isLoading = false;
  List<Widget> subscriptionsAddressesTilesList = [
    const AddressTile(
      addressTitle: '',
      addressDescription: '',
    ),
  ];
  List<Widget> customerPaymentMethodTilesList = [
    const PaymentMethodTileWidget(paymentMethodName: ''),
    const PaymentMethodTileWidget(paymentMethodName: ''),
  ];
  String addressTitle = '', addressDescription = '';
  String paymentMethodName = '',
      accountNo = '',
      routingNo = '',
      paymentSource = '',
      accountType = '',
      bankName = '',
      accountTitle = '';

  searchAddress(String searchText) {
    subscriptionsAddressesTilesList.clear();
    subscriptionsAddressesAPIData?.forEach((address) {
      if (address['add1'].toLowerCase().contains(searchText.toLowerCase())) {
        subscriptionsAddressesTilesList.add(AddressTile(
          addressTitle: address['add2'] ?? "",
          addressDescription:
              "${address['add1']}, ${address['add2']}, ${address['add3']} \n ZipCode: ${address['zipCode']}",
        ));
      }
    });
    notifyListeners();
  }

  getSubscriptionAddressesList() async {
    isLoading = true;
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    var entityID = await UserPreferences.getEntityID();
    if (kDebugMode) {
      print('Entity ID :::: $entityID');
    }
    TopVariable.apiService
        .getCustomerAddresses(int.parse(entityID.toString()))
        .then((value) {
      isLoading = false;
      List list = value['data'];
      subscriptionsAddressesAPIData = value['data'];
      subscriptionsAddressesTilesList.clear();
      for (int i = 0; i < list.length; i++) {
        subscriptionsAddressesTilesList.add(AddressTile(
          addressTitle: list[i]['add2'] ?? "",
          addressDescription:
              "${list[i]['add1']}, ${list[i]['add2']}, ${list[i]['add3']} \n ZipCode: ${list[i]['zipCode']}",
        ));
      }
      // subscriptionsAddressesTilesList = [];
      // subscriptionsAddressesAPIData = value ;//as List<dynamic>;
      // if (subscriptionsAddressesAPIData != null) {
      //   if (subscriptionsAddressesAPIData!.isNotEmpty) {
      //     isLoading = false;
      //     for (Map<String, dynamic> address in subscriptionsAddressesAPIData!) {
      //       subscriptionsAddressesTilesList.add(AddressTile(
      //         addressTitle: address['alias'],
      //         addressDescription:
      //             "${address['address1']}, ${address['city']}, ${address['state']}, ${address['countryCode']}, ${address['postalCode']}",
      //       ));
      //     }
      //   }
      // }
      notifyListeners();
    });
  }

  searchPaymentMethod(String searchText) {
    customerPaymentMethodTilesList.clear();
    customerPaymentInfoAPIData?.forEach((paymentMethod) {
      if (paymentMethod['accountType']
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        customerPaymentMethodTilesList.add(PaymentMethodTileWidget(
          paymentMethodName: paymentMethod['paymentSrcAlias'] ?? "",
          paymentSource: paymentMethod['paymentSource'] ?? "",
          accountType: paymentMethod['accountType'] ?? "",
          bankName: paymentMethod['bankName'] ?? "",
          accountTitle: paymentMethod['accountTitle'] ?? "",
          accountNo: paymentMethod['accountNo'] ?? "",
          routingNo: paymentMethod['routingNo'] ?? "",
        ));
      }
    });
    notifyListeners();
  }

  getPaymentMethodsList() async {
    customerPaymentMethodTilesList.clear();
    bool _isInternetConnected = await BaseClientClass.isInternetConnected();
    if (!_isInternetConnected) {
      await Get.to(() => const NoInternetScreen());
      return;
    }
    TopVariable.apiService
        .getCustomerPaymentInfo(UserPreferences.user.acctId!)
        .then((value) {
      customerPaymentMethodTilesList = [];
      customerPaymentInfoAPIData = value as List<dynamic>;
      if (customerPaymentInfoAPIData != null) {
        if (customerPaymentInfoAPIData!.isNotEmpty) {
          for (Map<String, dynamic> paymentMethod
              in customerPaymentInfoAPIData!) {
            customerPaymentMethodTilesList.add(PaymentMethodTileWidget(
                paymentMethodName: paymentMethod['paymentSource'] ?? ' ',
                paymentSource: paymentMethod['paymentSource'] ?? "",
                accountType: paymentMethod['accountType'] ?? "",
                accountTitle: paymentMethod['accountTitle'] ?? "",
                bankName: paymentMethod['bankName'] ?? "",
                accountNo: paymentMethod['accountNo'] ?? "",
                routingNo: paymentMethod['routingNo'] ?? ""));
          }
        }
      }
      notifyListeners();
    });
  }
}
