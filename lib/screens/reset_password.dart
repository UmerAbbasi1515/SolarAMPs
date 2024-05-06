// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/shared/const/no_internet_screen.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/app_url.dart';
import 'package:solaramps/utility/constants.dart';
import 'package:solaramps/widget/error_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utility/paths.dart';
import '../utility/shared_preference.dart';
import '../utility/top_level_variables.dart';
import '../utility/validator.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
              Obx(() {
                return Visibility(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 0),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              // color: appTheme.primaryColor,
                              color: CustomColor.grenishColor),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email Address',
                          style: TextStyle(
                            fontSize: orientation == Orientation.portrait
                                ? 14.0
                                : 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: validateEmail,
                        initialValue: emailAddress.value,
                        // controller: _forgotEmailController,
                        onSaved: (value) => emailAddress.value = value!,
                        onChanged: (value) => emailAddress.value = value,
                        // onSaved: (value) => _username = value!,
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.1),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black87),
                            ),
                            contentPadding: const EdgeInsets.only(left: 10),
                            hintStyle: appTheme.textTheme.bodyText2),
                        //   keyboardType: TextInputType.emailAddress,
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
                              isLoading.value
                                  ? Center(
                                    child: Container(
                                        width: Get.width * 0.6,
                                        margin:
                                            const EdgeInsets.only(left: 10, right: 40),
                                        height: Get.width * 0.2,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: CustomColor.grenishColor,
                                          ),
                                        ),
                                      ),
                                  )
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                emailAddress.value == ''
                                                    ? Colors.grey.shade300
                                                    : CustomColor.grenishColor),
                                      ),
                                      child: const Text('   RESET   '),
                                      onPressed: emailAddress.value == ''
                                          ? null
                                          : () async {
                                              if (emailAddress.value == '') {
                                                showErrorDialog(
                                                    'Please enter your valid email address',
                                                    '');
                                                return;
                                              }
                                              var val = validateEmailbool(
                                                  emailAddress.value.trim());
                                              if (val == false) {
                                                showErrorDialog(
                                                    Constants.EMAIL_VALID, '');
                                                return;
                                              }
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              bool _isInternetConnected =
                                                  await BaseClientClass
                                                      .isInternetConnected();
                                              if (!_isInternetConnected) {
                                                await Get.to(() =>
                                                    const NoInternetScreen());
                                                return;
                                              }
                                              var data = {
                                                "compKey":
                                                    UserPreferences.compKey,
                                                "emailAddress":
                                                    emailAddress.value,
                                                "userType": "CUSTOMER"
                                              };

                                              //  forgotpass(data);
                                              //  return;
                                              // TopVariable.apiService
                                              //     .forgotPassword(
                                              //         emailAddress.value,
                                              //         UserPreferences.compKey!,
                                              //         "Generate")
                                              isLoading.value = true;
                                              TopVariable.apiService
                                                  .forgotPassword(
                                                      UserPreferences.compKey!,
                                                      data)
                                                  .then((response) {
                                                isLoading.value = false;
                                                if (kDebugMode) {
                                                  print(
                                                      'Response :::::After then:::::: $response');
                                                }

                                                if (response is String) {
                                                  if (response.contains(
                                                      'Could not connect to the server')) {
                                                    showErrorDialog(
                                                        'Could not connect to the server',
                                                        '');
                                                    return;
                                                  }
                                                  if (response.contains(
                                                      'EmailAddress does not exists')) {
                                                    showErrorDialog(
                                                        'EmailAddress does not exists',
                                                        '');
                                                    return;
                                                  }
                                                  showErrorDialog(response, '');
                                                  return;
                                                }
                                                Map<String, dynamic>
                                                    mappedResponse = response
                                                        as Map<String, dynamic>;
                                                if (!mappedResponse
                                                    .containsKey('error')) {
                                                  showErrorDialog(
                                                      mappedResponse['message']
                                                              .toString()
                                                              .replaceAll(
                                                                  '.', ' ') +
                                                          'on ' +
                                                          emailAddress.value,
                                                      '');
                                                  // setState(() {
                                                  //   emailEntered = true;
                                                  //   showOTPSegment = true;
                                                  // });
                                                } else {
                                                  if (mappedResponse['error']
                                                          .toString()
                                                          .contains(
                                                              'Invalid email :') ==
                                                      true) {
                                                    showErrorDialog(
                                                        '$emailAddress is not associated with any company',
                                                        '');
                                                  } else {
                                                    showErrorDialog(
                                                        mappedResponse['error']
                                                            .toString(),
                                                        '');
                                                  }
                                                }
                                              });
                                            },
                                    ),
                            ],
                          )),
                    ],
                  ),
                  visible: !emailEntered,
                );
              }),
              // Visibility(
              //   child: Obx(() {
              //     return Column(
              //       children: [
              //         SizedBox(
              //             height: orientation == Orientation.portrait
              //                 ? 25.0
              //                 : 10.0),
              //         Container(
              //           padding: const EdgeInsets.only(bottom: 15),
              //           alignment: Alignment.centerLeft,
              //           child: const Text(
              //             'Check Email',
              //             style: TextStyle(
              //                 fontSize: 17,
              //                 fontWeight: FontWeight.bold,
              //                 // color: appTheme.primaryColor,
              //                 color: CustomColor.grenishColor),
              //           ),
              //         ),
              //         Container(
              //           padding: const EdgeInsets.only(bottom: 6),
              //           alignment: Alignment.centerLeft,
              //           child: Text(
              //             'Enter the OTP sent on your email',
              //             style: TextStyle(
              //               fontSize: orientation == Orientation.portrait
              //                   ? 14.0
              //                   : 15.0,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //         TextFormField(
              //           // validator: validateEmail,
              //           inputFormatters: <TextInputFormatter>[
              //             FilteringTextInputFormatter.digitsOnly
              //           ],
              //           initialValue: otp.value,
              //           keyboardType: TextInputType.number,
              //           // onSaved: (value) => _username = value!,
              //           onChanged: (value) => otp.value = value,
              //           // onSaved: (value) => _username = value!,
              //           decoration: InputDecoration(
              //               contentPadding: const EdgeInsets.only(left: 10),
              //               labelText: '',
              //               //  prefixIcon: Icon(Icons.corporate_fare),
              //               hintText: '',
              //               hintStyle: appTheme.textTheme.bodyText2),
              //           //   keyboardType: TextInputType.emailAddress,
              //         ),
              //         const SizedBox(
              //           height: 2,
              //         ),
              //         Container(
              //           alignment: Alignment.centerLeft,
              //           child: const Text(
              //             'Check your spam folder',
              //             style: TextStyle(
              //               fontSize: 12,
              //               color: Colors.blueGrey,
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //             height:
              //                 orientation == Orientation.portrait ? 20.0 : 2),
              //         Container(
              //             alignment: Alignment.centerRight,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               //scrollDirection: Axis.horizontal,
              //               children: [
              //                 ElevatedButton(
              //                   style: ButtonStyle(
              //                     backgroundColor: MaterialStateProperty.all(
              //                         // const Color(0xFF2E3850)
              //                         otp.value == ''
              //                             ? Colors.grey.shade300
              //                             : CustomColor.grenishColor),
              //                   ),
              //                   child: const Text('   SUBMIT   '),
              //                   onPressed: otp.value == ''
              //                       ? null
              //                       : () async {
              //                           if (otp.value == '') {
              //                             showErrorDialog(
              //                                 'Please enter the otp that sent to $emailAddress',
              //                                 '');
              //                             return;
              //                           }
              //                           bool _isInternetConnected =
              //                               await BaseClientClass
              //                                   .isInternetConnected();
              //                           if (!_isInternetConnected) {
              //                             await Get.to(
              //                                 () => const NoInternetScreen());
              //                             return;
              //                           }
              //                           TopVariable.apiService
              //                               .verifyOTP(
              //                                   emailAddress.trim(),
              //                                   otp.value,
              //                                   UserPreferences.compKey!)
              //                               .then((response) {
              //                             Map<String, dynamic> mappedResponse =
              //                                 response as Map<String, dynamic>;
              //                             if (!mappedResponse
              //                                 .containsKey('error')) {
              //                               //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mappedResponse['message'].toString())));
              //                               setState(() {
              //                                 showOTPSegment = false;
              //                                 showPasswordConfirmationSegment =
              //                                     true;
              //                               });
              //                             } else {
              //                               showErrorDialog(
              //                                   mappedResponse['error']
              //                                       .toString(),
              //                                   '');
              //                             }
              //                           });
              //                         },
              //                 ),
              //               ],
              //             )),
              //       ],
              //     );
              //   }),
              //   visible: showOTPSegment,
              // ),

              // Visibility(
              //   child: Obx(() {
              //     return Column(
              //       children: [
              //         Container(
              //           padding: const EdgeInsets.only(bottom: 0, top: 20),
              //           alignment: Alignment.centerLeft,
              //           child: const Text(
              //             'Create New Password',
              //             style: TextStyle(
              //               fontSize: 17,
              //               fontWeight: FontWeight.bold,
              //               color: CustomColor.grenishColor,
              //             ),
              //           ),
              //         ),
              //         Container(
              //           padding: const EdgeInsets.only(bottom: 6, top: 15),
              //           alignment: Alignment.centerLeft,
              //           child: Text(
              //             'Your new password must be different from the previous password',
              //             style: TextStyle(
              //               fontSize: orientation == Orientation.portrait
              //                   ? 14.0
              //                   : 15.0,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //         TextFormField(
              //           obscureText: !passwordVisible,
              //           initialValue: password.value,
              //           validator: validatePassword,
              //           onSaved: (value) => password.value = value!,
              //           onChanged: (value) => password.value = value,
              //           decoration: InputDecoration(
              //             suffixIcon: IconButton(
              //               icon: Icon(
              //                 // Based on passwordVisible state choose the icon
              //                 passwordVisible
              //                     ? Icons.visibility
              //                     : Icons.visibility_off,
              //                 color: Theme.of(context).primaryColorDark,
              //               ),
              //               onPressed: () {
              //                 setState(() {
              //                   passwordVisible = !passwordVisible;
              //                 });
              //               },
              //             ),
              //             contentPadding: const EdgeInsets.only(left: 10),
              //             labelText: 'Password',
              //             //  prefixIcon: Icon(Icons.corporate_fare),
              //             hintText: 'Password',
              //           ),
              //           keyboardType: TextInputType.visiblePassword,
              //         ),
              //         const SizedBox(
              //           height: 2,
              //         ),
              //         Container(
              //           alignment: Alignment.centerLeft,
              //           child: const Text(
              //             'Must be at least 8 characters long',
              //             style: TextStyle(
              //               fontSize: 12,
              //               color: Colors.blueGrey,
              //             ),
              //           ),
              //         ),
              //         const SizedBox(height: 20.0),
              //         TextFormField(
              //           obscureText: !confirmPasswordVisible,
              //           initialValue: confirmPassword.value,
              //           validator: validatePassword,
              //           onSaved: (value) => confirmPassword.value = value!,
              //           onChanged: (value) => confirmPassword.value = value,
              //           decoration: InputDecoration(
              //             suffixIcon: IconButton(
              //               icon: Icon(
              //                 // Based on passwordVisible state choose the icon
              //                 confirmPasswordVisible
              //                     ? Icons.visibility
              //                     : Icons.visibility_off,
              //                 color: Theme.of(context).primaryColorDark,
              //               ),
              //               onPressed: () {
              //                 setState(() {
              //                   confirmPasswordVisible =
              //                       !confirmPasswordVisible;
              //                 });
              //               },
              //             ),
              //             contentPadding: const EdgeInsets.only(left: 10),
              //             labelText: 'Confirm Password',
              //             //  prefixIcon: Icon(Icons.corporate_fare),
              //             hintText: 'Confirm Password',
              //           ),
              //           keyboardType: TextInputType.visiblePassword,
              //         ),
              //         const SizedBox(
              //           height: 2,
              //         ),
              //         Container(
              //           alignment: Alignment.centerLeft,
              //           child: const Text(
              //             'Both passwords must match with each other',
              //             style: TextStyle(
              //               fontSize: 12,
              //               color: Colors.blueGrey,
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //             height:
              //                 orientation == Orientation.portrait ? 20.0 : 2),
              //         Container(
              //             alignment: Alignment.centerRight,
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               //scrollDirection: Axis.horizontal,
              //               children: [
              //                 ElevatedButton(
              //                   style: ButtonStyle(
              //                     backgroundColor: MaterialStateProperty.all(
              //                         // const Color(0xFF2E3850)
              //                         password.value == '' ||
              //                                 confirmPassword.value == ''
              //                             ? Colors.grey.shade300
              //                             : CustomColor.grenishColor),
              //                   ),
              //                   child: const Text('   CONFIRM   '),
              //                   onPressed: password.value == '' ||
              //                           confirmPassword.value == ''
              //                       ? null
              //                       : () async {
              //                           if (password.value == '' &&
              //                               confirmPassword.value == '') {
              //                             showErrorDialog(
              //                                 'Please enter passwords first',
              //                                 '');
              //                             return;
              //                           }
              //                           if (password.value == '') {
              //                             showErrorDialog(
              //                                 'Please enter password first',
              //                                 '');
              //                             return;
              //                           }
              //                           if (confirmPassword.value == '') {
              //                             showErrorDialog(
              //                                 'Please enter confirm password first',
              //                                 '');
              //                             return;
              //                           }
              //                           if (password.value !=
              //                               confirmPassword.value) {
              //                             showErrorDialog(
              //                                 'Password and Confirm Password should same',
              //                                 '');
              //                             return;
              //                           }
              //                           if (password.value ==
              //                               confirmPassword.value) {
              //                             final Map<String, dynamic>
              //                                 passwordResetData = {
              //                               'newPassword': password.value,
              //                               'emailId': emailAddress.value
              //                             };
              //                             bool _isInternetConnected =
              //                                 await BaseClientClass
              //                                     .isInternetConnected();
              //                             if (!_isInternetConnected) {
              //                               await Get.to(
              //                                   () => const NoInternetScreen());
              //                               return;
              //                             }
              //                             TopVariable.apiService
              //                                 .resetPassword(passwordResetData)
              //                                 .then((response) {
              //                               Map<String, dynamic>
              //                                   mappedResponse = response
              //                                       as Map<String, dynamic>;
              //                               if (!mappedResponse
              //                                   .containsKey('error')) {
              //                                 ScaffoldMessenger.of(context)
              //                                     .showSnackBar(const SnackBar(
              //                                         content: Text(
              //                                             'Password successfully reset!')));
              //                                 Navigator.pop(context);
              //                                 Navigator.pop(context);
              //                               } else {
              //                                 showErrorDialog(
              //                                     mappedResponse['error']
              //                                         .toString(),
              //                                     '');
              //                               }
              //                             });
              //                           } else {
              //                             ScaffoldMessenger.of(context)
              //                                 .showSnackBar(const SnackBar(
              //                                     content: Text(
              //                                         'Please enter same password in both fields')));
              //                           }
              //                         },
              //                 ),
              //               ],
              //             )),
              //       ],
              //     );
              //   }),
              //   visible: showPasswordConfirmationSegment,
              // ),


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
          bottom: 40,
          right: 0,
          left: 0,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Login?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.grenishColor,
                  ),
                  // color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          left: 0,
          bottom: 2,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    // onTap: () => TopVariable.switchScreen('/privacy'),
                    onTap: () async {
                      if (await canLaunch(AppUrl.privacyPolicyURL) == true) {
                        launch(AppUrl.privacyPolicyURL);
                      } else {
                        if (kDebugMode) {
                          print("Can't launch privacy policy URL");
                        }
                      }
                    },
                    child: Text(
                      'Privacy Policy',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Icon(
                    CupertinoIcons.circle_fill,
                    size: 5,
                    color: Colors.grey,
                  ),
                  // Text('.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10),),
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    //   onTap: () => TopVariable.switchScreen('/termsOfUse'),
                    onTap: () async {
                      if (await canLaunch(AppUrl.termsOfUseURL) == true) {
                        launch(AppUrl.termsOfUseURL);
                      } else {
                        if (kDebugMode) {
                          print("Can't launch terms of use URL");
                        }
                      }
                    },
                    child: Text(
                      'Terms of Use',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
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
        Positioned(
          top: 45,
          left: 0,
          right: 0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
              ),
              const SizedBox(width: 10.0),
              Hero(
                tag: 'logo_writing',
                child: Image.asset(
                  solarWithLogo,
                  height: 40,
                ),
              ),
            ],
          ),
        )
      ]);
    });
  }
}
