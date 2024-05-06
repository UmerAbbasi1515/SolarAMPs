import 'package:flutter/material.dart';
import 'package:solaramps/gen/assets.gen.dart';
import 'package:solaramps/utility/constants.dart';
import 'package:solaramps/utility/dialog/confirmation_dialog.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class BottomNaviBar extends StatelessWidget {
  const BottomNaviBar({Key? key}) : super(key: key);

  _logoutConfirmationDialog() async {
    return showDialog<void>(
      context: appNavigationKey.currentContext!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: ConfirmationDialog(
            title: 'Logout Confirmation',
            description: 'Are you sure you want to logout?',
            onConfirmed: () async {
              bool rememberMe = UserPreferences.rememberMe;
              // UserModel user = UserPreferences.user;
              // String compName = UserPreferences.compName;
              if (!rememberMe) {
                UserPreferences.removeV("userImage");
                UserPreferences.clear();
              }

              if (rememberMe) {
                UserPreferences.token = null;
              }

              await TopVariable.dashboardProvider.resetAppData();
              TopVariable.switchScreenAndRemoveAll(Constants.loginScreenPath);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(width: 0.9),
              IconButton(
                  icon: Icon(
                    Icons.contact_support,
                    color: appTheme.colorScheme.primary,
                    size: 32,
                  ),
                  onPressed: () {
                    if (route != null) {
                      if (route.settings.name != '/customer_support') {
                        TopVariable.switchScreen('/customer_support');
                      }
                    }
                  }),
              IconButton(
                  icon: Icon(
                    Icons.solar_power,
                    color: appTheme.colorScheme.primary,
                    size: 32,
                  ),
                  onPressed: () {
                    if (route != null) {
                      if (route.settings.name != '/dashboard') {
                        TopVariable.switchScreen('/dashboard');
                      }
                    }
                  }),
              const SizedBox(width: 40), // The dummy child
              IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: appTheme.colorScheme.primary,
                    size: 32,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title:const Text('Notifications'),
                              content:const Text('No new notification available.'),
                              actions: [
                                TextButton(
                                  child:const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  }),
              IconButton(
                  icon: Image.asset(
                    Assets.logoPng.path,
                    width: 50,
                    color: appTheme.colorScheme.primary,
                  ),
                  onPressed: () {
                    _logoutConfirmationDialog();
                  }),
              const SizedBox(width: .9),
            ],
          )),
    );
  }
}
