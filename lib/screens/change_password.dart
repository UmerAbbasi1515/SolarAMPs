// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/shared/const/no_internet_screen.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/widget/error_dialog.dart';
import '../utility/paths.dart';
import '../utility/shared_preference.dart';
import '../utility/top_level_variables.dart';
import '../utility/validator.dart';

class ChangePassword extends StatefulWidget {
  final String email;
  const ChangePassword({Key? key, required this.email}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController forgotEmailController = TextEditingController();
  String username = '';
  RxString emailAddress = ''.obs;
  RxBool isLoading = false.obs;
  RxString otp = ''.obs;
  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;
  bool passwordVisible = false,
      confirmPasswordVisible = false,
      showPasswordConfirmationSegment = false,
      showOTPSegment = false,
      emailEntered = false;

  @override
  Widget build(BuildContext context) {
    double? screenWidth =
        MediaQuery.of(appNavigationKey.currentContext!).size.width;
    return OrientationBuilder(builder: (context, orientation) {
      return Stack(fit: StackFit.expand, children: [
        Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: <Widget>[
              SizedBox(
                height: orientation == Orientation.portrait
                    ? (screenHeight! / 6)
                    : (screenHeight! / 4),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: CustomColor.grenishColor,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              UserPreferences.tenantLogoPath!.contains("svg")
                  ? SvgPicture.network(
                      UserPreferences.tenantLogoPath != null
                          ? UserPreferences.tenantLogoPath!
                          : '',
                      height: orientation == Orientation.portrait
                          ? (screenHeight! / 14)
                          : (screenHeight! / 4),
                      width: orientation == Orientation.portrait
                          ? screenWidth / 7
                          : screenWidth / 4,
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      UserPreferences.tenantLogoPath!,
                      height: orientation == Orientation.portrait
                          ? (screenHeight! / 14)
                          : (screenHeight! / 4),
                      width: orientation == Orientation.portrait
                          ? screenWidth / 7
                          : screenWidth / 4,
                      fit: BoxFit.contain,
                    ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  UserPreferences.compName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                  height: orientation == Orientation.portrait ? 25.0 : 10.0),
              Visibility(
                child: Obx(() {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 0, top: 20),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Create New Password',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: CustomColor.grenishColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 6, top: 15),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your new password must be different from the previous password',
                          style: TextStyle(
                            fontSize: orientation == Orientation.portrait
                                ? 14.0
                                : 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextFormField(
                        obscureText: !passwordVisible,
                        initialValue: password.value,
                        validator: validatePassword,
                        onSaved: (value) => password.value = value!,
                        onChanged: (value) => password.value = value,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          contentPadding: const EdgeInsets.only(left: 10),
                          labelText: 'Password',
                          //  prefixIcon: Icon(Icons.corporate_fare),
                          hintText: 'Password',
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Must be at least 8 characters long',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: !confirmPasswordVisible,
                        initialValue: confirmPassword.value,
                        validator: validatePassword,
                        onSaved: (value) => confirmPassword.value = value!,
                        onChanged: (value) => confirmPassword.value = value,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                confirmPasswordVisible =
                                    !confirmPasswordVisible;
                              });
                            },
                          ),
                          contentPadding: const EdgeInsets.only(left: 10),
                          labelText: 'Confirm Password',
                          //  prefixIcon: Icon(Icons.corporate_fare),
                          hintText: 'Confirm Password',
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Both passwords must match with each other',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              orientation == Orientation.portrait ? 20.0 : 2),
                      Container(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            //scrollDirection: Axis.horizontal,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      // const Color(0xFF2E3850)
                                      password.value == '' ||
                                              confirmPassword.value == ''
                                          ? Colors.grey.shade300
                                          : CustomColor.grenishColor),
                                ),
                                child: const Text('   CONFIRM   '),
                                onPressed: password.value == '' ||
                                        confirmPassword.value == ''
                                    ? null
                                    : () async {
                                        if (password.value == '' &&
                                            confirmPassword.value == '') {
                                          showErrorDialog(
                                              'Please enter passwords first',
                                              '');
                                          return;
                                        }
                                        if (password.value == '') {
                                          showErrorDialog(
                                              'Please enter password first',
                                              '');
                                          return;
                                        }
                                        if (confirmPassword.value == '') {
                                          showErrorDialog(
                                              'Please enter confirm password first',
                                              '');
                                          return;
                                        }
                                        if (password.value !=
                                            confirmPassword.value) {
                                          showErrorDialog(
                                              'Password and Confirm Password should same',
                                              '');
                                          return;
                                        }
                                        if (password.value ==
                                            confirmPassword.value) {
                                          var token = UserPreferences.token;
                                          final Map<String, dynamic>
                                              passwordResetData = {
                                            'newPassword': password.value,
                                            'emailId': widget.email,
                                            'token': token
                                          };
                                          if (kDebugMode) {
                                            print(
                                                'Password Reset Payload :::::: $passwordResetData');
                                          }
                                          bool _isInternetConnected =
                                              await BaseClientClass
                                                  .isInternetConnected();
                                          if (!_isInternetConnected) {
                                            await Get.to(
                                                () => const NoInternetScreen());
                                            return;
                                          }
                                          TopVariable.apiService
                                              .resetPassword(passwordResetData)
                                              .then((response) {
                                            Map<String, dynamic>
                                                mappedResponse = response
                                                    as Map<String, dynamic>;
                                            if (kDebugMode) {
                                              print(
                                                  'Response of Reset password from profile ::: $mappedResponse');
                                              print(
                                                  'Response of  ::: ${mappedResponse['message']}');
                                            }
                                            if (mappedResponse['message']
                                                    .toString() ==
                                                'Password changed successfully!') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Password successfully reset!')));
                                              Get.back();
                                            } else {
                                              showErrorDialog(
                                                  mappedResponse['error']
                                                      .toString(),
                                                  '');
                                            }
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'Please enter same password in both fields')));
                                        }
                                      },
                              ),
                            ],
                          )),
                    ],
                  );
                }),
                visible: true,
              ),
              SizedBox(height: orientation == Orientation.portrait ? 0 : 30.0),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4), BlendMode.darken),
              image: const AssetImage(assetsLogo),
              fit: BoxFit.fill,
            )),
            child: SizedBox(
              height: screenHeight! / 7,
              width: orientation == Orientation.portrait
                  ? screenWidth
                  : screenWidth,
            ),
          ),
        ),
        Positioned(
          right: 0,
          left: 0,
          bottom: 2,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 5,
              ),
              Container(
                height: 3,
                width: screenWidth,
                color: appTheme.colorScheme.secondary,
              ),
            ],
          ),
        ),
      ]);
    });
  }
}
