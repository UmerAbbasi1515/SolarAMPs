// import 'package:firebase_messaging/firebase_messaging.dart';
// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:solaramps/controllers_/auth_controller.dart';
import 'package:solaramps/dataModel/user_model.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/screens/home/home.dart';
import 'package:solaramps/shared/const/no_internet_screen.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/app_url.dart';
import 'package:solaramps/utility/constants.dart';
import 'package:solaramps/utility/paths.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:solaramps/utility/validator.dart';
import 'package:solaramps/widget/error_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginTenantPage extends StatefulWidget {
  const LoginTenantPage({
    Key? key,
  }) : super(key: key);

  @override
  _LoginTenantPage createState() => _LoginTenantPage();
}

class _LoginTenantPage extends State<LoginTenantPage>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  AuthController authController = Get.put(AuthController());
  @override
  void initState() {
    if (UserPreferences.rememberMe) {
      UserModel user = UserPreferences.user;
      setState(() {
        authController.username.value = user.userName ?? '';
        authController.password.value = user.password ?? '';
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          authController.username.value = '';
          authController.password.value = '';
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: returnLoginScreenWidget(authController),
    );
  }

  bool passwordVisible = false;
  bool isSecondScreen = true;
  bool rememberMeValue = UserPreferences.rememberMe;

  Widget returnLoginScreenWidget(AuthController controller) {
    return OrientationBuilder(builder: (context, orientation) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Obx(() {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(children: [
                Positioned(
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
                            : screenWidth!,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: orientation == Orientation.portrait
                              ? (screenHeight! / 5.5)
                              : (screenHeight! / 4),
                        ),
                        UserPreferences.tenantLogoPath!.contains("svg")
                            ? SvgPicture.network(
                                UserPreferences.tenantLogoPath != null
                                    ? UserPreferences.tenantLogoPath!
                                    : '',
                                width: orientation == Orientation.portrait
                                    ? screenWidth! / 7
                                    : screenWidth! / 4,
                                semanticsLabel: '')
                            : Image.network(
                                UserPreferences.tenantLogoPath!,
                                height: orientation == Orientation.portrait
                                    ? screenWidth! / 7
                                    : screenWidth! / 4,
                              ),
                        Text(
                          UserPreferences.compName.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height: orientation == Orientation.portrait
                                ? 25.0
                                : 10.0),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("User Name",
                              style: TextStyle(
                                  fontSize: orientation == Orientation.portrait
                                      ? 14.0
                                      : 15.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          validator: validateEmail,
                          initialValue: authController.username.value,
                          onChanged: (value) {
                            if (value == '') {
                              authController.username.value = '';
                              return;
                            }
                            authController.username.value = value;
                          },
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
                              contentPadding: const EdgeInsets.only(left: 15),
                              hintStyle: appTheme.textTheme.bodyText2),
                          //   keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12.0),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Password",
                              style: TextStyle(
                                  fontSize: orientation == Orientation.portrait
                                      ? 14.0
                                      : 15.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          obscureText: !passwordVisible,
                          initialValue: authController.password.value,
                          validator: validatePassword,
                          onChanged: (value) {
                            if (value == '') {
                              authController.password.value = '';
                              return;
                            }
                            authController.password.value = value;
                          },
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
                              contentPadding: const EdgeInsets.only(left: 15),
                              hintStyle: appTheme.textTheme.bodyText2),
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        SizedBox(
                            height:
                                orientation == Orientation.portrait ? 14.0 : 2),
                        // Container(
                        //   padding: EdgeInsets.zero,
                        //   margin: EdgeInsets.zero,
                        //   alignment: Alignment.centerLeft,
                        //   child: Row(
                        //     children: [
                        //       SizedBox(
                        //         height: 24.0,
                        //         width: 24.0,
                        //         child: Checkbox(
                        //           value: rememberMeValue,
                        //           onChanged: (bool? value) {
                        //             setState(() {
                        //               rememberMeValue = value!;
                        //             });
                        //           },
                        //           // side: BorderSide(),
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(5),
                        //           ),
                        //         ),
                        //       ),
                        //       const SizedBox(
                        //         width: 5,
                        //       ),
                        //       const Text('Remember me'),
                        //     ],
                        //   ),
                        // ),

                        SizedBox(
                            height: orientation == Orientation.portrait
                                ? 22.0
                                : 10.0),
                        Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              //scrollDirection: Axis.horizontal,
                              children: [
                                GestureDetector(
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        color: CustomColor.grenishColor,
                                        // color: appTheme.primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    TopVariable.switchScreen(
                                        Constants.resetPasswordScreenPath);
                                  },
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          authController.username.value == '' ||
                                                  authController
                                                          .password.value ==
                                                      ''
                                              ? Colors.grey.shade300
                                              : CustomColor.grenishColor),
                                  child: const Text('    LOGIN    '),
                                  onPressed: authController.username.value
                                                  .trim() ==
                                              '' ||
                                          authController.password.value
                                                  .trim() ==
                                              ''
                                      ? null
                                      : () async {
                                          if (authController.username.value
                                                      .trim() ==
                                                  '' &&
                                              authController.password.value
                                                      .trim() ==
                                                  '') {
                                            showErrorDialog(
                                                'Please enter Username and Password first',
                                                '');
                                            return;
                                          }
                                          if (authController.username.value
                                                  .trim() ==
                                              '') {
                                            showErrorDialog(
                                                'Please enter Username first',
                                                '');
                                            return;
                                          }
                                          if (authController.password.value
                                                  .trim() ==
                                              '') {
                                            showErrorDialog(
                                                'Please enter Password first',
                                                '');
                                            return;
                                          }
                                          final Map<String, dynamic>
                                              signInData = {
                                            'userName': authController
                                                .username.value
                                                .trim(),
                                            'password':
                                                authController.password.value,
                                            "userType": "CUSTOMER",
                                            // "isMobileLogin": true
                                          };
                                          if (kDebugMode) {
                                            print('Sign In API Payload: \t\t' +
                                                signInData.toString());
                                          }
                                          bool _isInternetConnected =
                                              await BaseClientClass
                                                  .isInternetConnected();
                                          if (!_isInternetConnected) {
                                            await Get.to(
                                                () => const NoInternetScreen());
                                            return;
                                          }
                                          //    CustomProgressDialog.showProDialog();
                                          TopVariable.apiService
                                              .signIn(UserPreferences.compKey!,
                                                  signInData)
                                              .then((response) {
                                            if (kDebugMode) {
                                              print(
                                                  'Response ::: User Model ::: $response');
                                            }
                                            Map<String, dynamic>
                                                mappedResponse = response
                                                    as Map<String, dynamic>;
                                            UserPreferences.token =
                                                (mappedResponse['jwtToken']);
                                            UserModel user =
                                                UserModel.fromJson(response);
                                            user.password =
                                                authController.password.value;
                                            UserPreferences.user = user;
                                            UserPreferences.setString(
                                                'UserName',
                                                user.firstName.toString() +
                                                    ' ' +
                                                    user.lastName.toString());
                                            UserPreferences.rememberMe =
                                                rememberMeValue;
                                            // TopVariable.switchScreenAndRemoveAll(
                                            //     '/new_dashboard');
                                            setState(() {
                                              authController.username.value =
                                                  '';
                                              authController.password.value =
                                                  '';
                                            });
                                            Get.off(
                                                () => const HomeScreenTabs());
                                          });
                                        },
                                ),
                              ],
                            )),
                      ],
                    ),
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
              ]),
            );
          }),
          Positioned(
            bottom: Platform.isAndroid ? 40 : 100,
            right: 0,
            left: 0,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      UserPreferences.compIDRememberMe = false;
                    });
                    setState(() {
                      authController.username.value = '';
                      authController.password.value = '';
                    });
                    TopVariable.switchScreen("/login");
                  },
                  child: const Text(
                    "Switch Company?",
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
            bottom: Platform.isAndroid ? 2 : 70,
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
        ],
      );
    });
  }
}
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // ignore_for_file: deprecated_member_use

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:solaramps/controllers_/auth_controller.dart';
// import 'package:solaramps/dataModel/user_model.dart';
// import 'package:solaramps/screens/home/home.dart';
// // import 'package:solaramps/domain/user.dart';
// import 'package:solaramps/screens/login.dart';
// import 'package:solaramps/theme/color.dart';
// import 'package:solaramps/utility/app_url.dart';
// import 'package:solaramps/utility/constants.dart';
// import 'package:solaramps/utility/shared_preference.dart';
// import 'package:solaramps/utility/top_level_variables.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../utility/paths.dart';
// import '../utility/validator.dart';

// class LoginTenantPage extends StatefulWidget {
//   const LoginTenantPage({Key? key}) : super(key: key);

//   @override
//   _LoginTenantPage createState() => _LoginTenantPage();
// }

// class _LoginTenantPage extends State<LoginTenantPage>
//     with TickerProviderStateMixin {
//   final formKey = GlobalKey<FormState>();
//   String _username = '', authController.password.value = '';

//   @override
//   void dispose() {
//     // _controller.dispose();
//     super.dispose();
//   }

//   AuthController authController = Get.put(AuthController());
//   @override
//   void initState() {
//     if (UserPreferences.rememberMe) {
//       UserModel user = UserPreferences.user;
//       setState(() {
//         _username = user.userName ?? '';
//         authController.password.value = user.password ?? '';
//       });
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: returnLoginScreenWidget(authController),
//     );
//   }

//   bool passwordVisible = false;
//   bool isSecondScreen = true;
//   bool rememberMeValue = UserPreferences.rememberMe;

//   Widget returnLoginScreenWidget(AuthController controller) {
//     return OrientationBuilder(builder: (context, orientation) {
//       return Stack(
//         fit: StackFit.expand,
//         children: [
//           SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Stack(children: [
//               Positioned(
//                 right: 0,
//                 left: 0,
//                 top: 0,
//                 child: Container(
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                       colorFilter: ColorFilter.mode(
//                           Colors.black.withOpacity(0.4), BlendMode.darken),
//                       image: const AssetImage(assetsLogo),
//                       fit: BoxFit.fill,
//                     )),
//                     child: SizedBox(
//                       height: screenHeight! / 6,
//                       width: orientation == Orientation.portrait
//                           ? screenWidth
//                           : screenWidth!,
//                     )),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Form(
//                   key: formKey,
//                   child: Column(
//                     children: <Widget>[
//                       SizedBox(
//                           height: orientation == Orientation.portrait
//                               ? (screenHeight! / 4)
//                               : (screenHeight! / 4)),
//                       UserPreferences.tenantLogoPath!.contains("svg")
//                           ? SvgPicture.network(
//                               UserPreferences.tenantLogoPath != null
//                                   ? UserPreferences.tenantLogoPath!
//                                   : '',
//                               width: orientation == Orientation.portrait
//                                   ? screenWidth! / 6
//                                   : screenWidth! / 4,
//                               semanticsLabel: '')
//                           : Image.network(
//                               UserPreferences.tenantLogoPath!,
//                               height: orientation == Orientation.portrait
//                                   ? screenWidth! / 6
//                                   : screenWidth! / 4,
//                             ),
//                       Text(
//                         UserPreferences.compName.toUpperCase(),
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(
//                           height: orientation == Orientation.portrait
//                               ? 30.0
//                               : 10.0),
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Text("Username",
//                             style: TextStyle(
//                                 fontSize: orientation == Orientation.portrait
//                                     ? 14.0
//                                     : 15.0,
//                                 fontWeight: FontWeight.bold)),
//                       ),
//                       const SizedBox(
//                         height: 8,
//                       ),
//                       TextFormField(
//                         validator: validateEmail,
//                         initialValue: _username,
//                         //      onSaved: (value) => _username = value!,
//                         onChanged: (value) => _username = value,
//                         // onSaved: (value) => _username = value!,
//                         decoration: InputDecoration(
//                             contentPadding: const EdgeInsets.only(left: 15),
//                             hintStyle: appTheme.textTheme.bodyText2),
//                         //   keyboardType: TextInputType.emailAddress,
//                       ),
//                       const SizedBox(height: 15.0),
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Text("Password",
//                             style: TextStyle(
//                                 fontSize: orientation == Orientation.portrait
//                                     ? 14.0
//                                     : 15.0,
//                                 fontWeight: FontWeight.bold)),
//                       ),
//                       const SizedBox(
//                         height: 8,
//                       ),
//                       TextFormField(
//                         obscureText: !passwordVisible,
//                         initialValue: authController.password.value,
//                         validator: validatePassword,
//                         //  onSaved: (value) => authController.password.value = value!,
//                         onChanged: (value) => authController.password.value = value,
//                         decoration: InputDecoration(
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 // Based on passwordVisible state choose the icon
//                                 passwordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: Theme.of(context).primaryColorDark,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   passwordVisible = !passwordVisible;
//                                 });
//                               },
//                             ),
//                             contentPadding: const EdgeInsets.only(left: 15),
//                             hintStyle: appTheme.textTheme.bodyText2),
//                         keyboardType: TextInputType.visiblePassword,
//                       ),
//                       SizedBox(
//                           height:
//                               orientation == Orientation.portrait ? 20.0 : 2),
//                       Container(
//                         padding: EdgeInsets.zero,
//                         margin: EdgeInsets.zero,
//                         alignment: Alignment.centerLeft,
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               height: 24.0,
//                               width: 24.0,
//                               child: Checkbox(
//                                 value: rememberMeValue,
//                                 onChanged: (bool? value) {
//                                   setState(() {
//                                     rememberMeValue = value!;
//                                   });
//                                 },
//                                 // side: BorderSide(),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 5,
//                             ),
//                             const Text('Remember me'),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                           alignment: Alignment.centerRight,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             //scrollDirection: Axis.horizontal,
//                             children: [
//                               GestureDetector(
//                                 child: const Text(
//                                   'Forgot Password?',
//                                   style: TextStyle(
//                                       color: CustomColor.grenishColor,
//                                       // color: appTheme.primaryColor,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 onTap: () {
//                                   TopVariable.switchScreen(
//                                       Constants.resetPasswordScreenPath);
//                                 },
//                               ),
//                               const SizedBox(
//                                 width: 20,
//                               ),
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: CustomColor.grenishColor),
//                                 child: const Text('    LOGIN    '),
//                                 onPressed: () async {
//                                   final Map<String, dynamic> signInData = {
//                                     'userName': _username.trim(),
//                                     'password': authController.password.value
//                                   };
//                                   if (kDebugMode) {
//                                     print('Sign In API Payload: \t\t' +
//                                         signInData.toString());
//                                   }
//                                   //    CustomProgressDialog.showProDialog();
//                                   TopVariable.apiService
//                                       .signIn(
//                                           UserPreferences.compKey!, signInData)
//                                       .then((response) {
//                                     Map<String, dynamic> mappedResponse =
//                                         response as Map<String, dynamic>;
//                                     UserPreferences.token =
//                                         (mappedResponse['jwtToken']);
//                                     UserModel user =
//                                         UserModel.fromJson(response);
//                                     user.password = authController.password.value;
//                                     UserPreferences.user = user;
//                                     UserPreferences.rememberMe =
//                                         rememberMeValue;
//                                     // TopVariable.switchScreenAndRemoveAll(
//                                     //     '/new_dashboard');
//                                     Get.off(() => const HomeScreenTabs());
//                                   });
//                                 },
//                               ),
//                             ],
//                           )),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 45,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const SizedBox(
//                       width: 20,
//                     ),
//                     Hero(
//                       tag: 'logo',
//                       child: Image.asset(
//                         assetPathCompanyLogoOrangePng,
//                         color: Colors.orange,
//                         height: 35,
//                       ),
//                     ),
//                     const SizedBox(width: 10.0),
//                     Hero(
//                       tag: 'logo_writing',
//                       child: Image.asset(
//                         assetPathCompanyLogoWriting,
//                         color: Colors.orange,
//                         height: 40,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ]),
//           ),
//           Positioned(
//             bottom: 55,
//             right: 0,
//             left: 0,
//             child: Column(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       UserPreferences.compIDRememberMe = false;
//                     });
//                     TopVariable.switchScreen("/login");
//                   },
//                   child: const Text(
//                     "Switch Company",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: CustomColor.grenishColor,
//                     ),
//                     // color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             right: 0,
//             left: 0,
//             bottom: 15,
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     InkWell(
//                       // onTap: () => TopVariable.switchScreen('/privacy'),
//                       onTap: () async {
//                         if (await canLaunch(AppUrl.privacyPolicyURL) == true) {
//                           launch(AppUrl.privacyPolicyURL);
//                         } else {
//                           if (kDebugMode) {
//                             print("Can't launch privacy policy URL");
//                           }
//                         }
//                       },
//                       child: Text(
//                         'Privacy Policy',
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     const Icon(
//                       CupertinoIcons.circle_fill,
//                       size: 5,
//                       color: Colors.grey,
//                     ),
//                     // Text('.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10),),
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     InkWell(
//                       //   onTap: () => TopVariable.switchScreen('/termsOfUse'),
//                       onTap: () async {
//                         if (await canLaunch(AppUrl.termsOfUseURL) == true) {
//                           launch(AppUrl.termsOfUseURL);
//                         } else {
//                           if (kDebugMode) {
//                             print("Can't launch terms of use URL");
//                           }
//                         }
//                       },
//                       child: Text(
//                         'Terms of Use',
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                     )
//                   ],
//                 ),
//                 Container(
//                   height: 5,
//                 ),
//                 Container(
//                   height: 3,
//                   width: screenWidth,
//                   color: appTheme.colorScheme.secondary,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
