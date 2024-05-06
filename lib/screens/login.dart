// import 'package:firebase_messaging/firebase_messaging.dart';
// ignore_for_file: unused_local_variable, deprecated_member_use

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solaramps/controllers_/auth_controller.dart';
import 'package:solaramps/gen/assets.gen.dart';
import 'package:solaramps/helper_/base_client.dart';
import 'package:solaramps/shared/const/no_internet_screen.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';
import 'package:solaramps/widget/error_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utility/app_url.dart';
import '../utility/paths.dart';
import '../utility/validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthController authController = Get.put(AuthController());
  //Duration get signupTime => Duration(milliseconds: timeDilation.ceil() * 2250);
  final formKey = GlobalKey<FormState>();
  String username = '', password = '';
  String? fcmToken = '';
  final TextEditingController _usernameController = TextEditingController();
  var loginUrl = '';
  var companyKey = '';
  bool rememberMeValueForCompanyID = false;

  RxBool isShowClearButton = false.obs;

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  /* firebaseToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    fcmToken = await messaging.getToken();
    print("firebase token is \t $fcmToken");
  }*/

  @override
  Widget build(BuildContext context) {
    // hiding because adding remember me in the  first page
    // WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
    // if (UserPreferences.rememberMe) {
    //         setState(() {
    //           _usernameController.text = UserPreferences.compName != ""
    //               ? UserPreferences.compName
    //               : '';
    //         });
    //       }
    //     }));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: returnLoginScreenWidget(authController),
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.darken),
                image: const AssetImage(assetsLogo),
                fit: BoxFit.cover)),
      ),
    );
  }

// https://bestage.azurewebsites.net/solarapi/company/compkey/Genx-nextgen
  Widget returnLoginScreenWidget(AuthController controller) {
    const double smallLogo = 90.0;
    const double bigLogo = 130.0;
    return OrientationBuilder(builder: (context, orientation) {
      return Obx(() {
        return Stack(fit: StackFit.expand, children: [
          Positioned(
              left:
                  orientation == Orientation.portrait ? 0 : (screenWidth! / 2),
              bottom: orientation == Orientation.portrait ? 50 : 25,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  assetPathCompanyWatermark,
                  width: screenWidth,
                  color: Colors.orange,
                ),
              )),
          Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              children: <Widget>[
                SizedBox(
                    height: orientation == Orientation.portrait ? 100.0 : 50.0),
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    updatedLogo,
                    height: 60,
                  ),
                ),
                const SizedBox(height: 10.0),
                Hero(
                  tag: 'logo_writing',
                  child: Image.asset(
                    solarWithoutLogo,
                    // color: Colors.orange,
                    height: 50,
                  ),
                ),
                SizedBox(
                    height: orientation == Orientation.portrait ? 100.0 : 50),
                Text("Company ID",
                    style: TextStyle(
                        color: appTheme.colorScheme.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                    height: orientation == Orientation.portrait ? 10.0 : 20),
                Obx(() {
                  return TextFormField(
                    validator: validateCompanyId,
                    controller: _usernameController,
                    onChanged: (value) async {
                      if (value.length > 1) {
                        bool _isInternetConnected =
                            await BaseClientClass.isInternetConnected();
                        if (!_isInternetConnected) {
                          await Get.to(() => const NoInternetScreen());
                          return;
                        }
                        controller.getCompanyNameLike(value);
                        controller.isHide.value = false;
                      }

                      if (value.isEmpty || value.length < 2) {
                        controller.isHide.value = true;
                      }
                    },
                    //  onSaved: (value) => _username = value!,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.1),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4)),
                        borderSide: BorderSide(width: 1, color: Colors.black87),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.only(left: 15),
                      suffixIcon: isShowClearButton.value
                          ? InkWell(
                              child: const Icon(Icons.close),
                              onTap: () {
                                _usernameController.clear();
                                isShowClearButton.value = false;
                              },
                            )
                          : const SizedBox(),
                      hintStyle: appTheme.textTheme.bodyText2,
                    ),
                    keyboardType: TextInputType.text,
                  );
                }),
                // Listview for company name like api
                controller.loadingData.value == true
                    ? Container(
                        width: Get.width * 0.92,
                        height: Get.height * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(Get.width * 0.05),
                            bottomRight: Radius.circular(Get.width * 0.05),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: Get.width * 0.5,
                              spreadRadius: Get.width * 0.1,
                              offset: Offset(
                                Get.width * 0.1,
                                Get.width * 0.1,
                              ),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SizedBox(
                            width: Get.width * 0.08,
                            height: Get.width * 0.08,
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : controller.isHide.value == true
                        ? const SizedBox()
                        : controller.getCompanyNameLikeList.isEmpty
                            ? const SizedBox()
                            : Container(
                                width: Get.width * 0.9,
                                height: Get.height * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(Get.width * 0.05),
                                    bottomRight:
                                        Radius.circular(Get.width * 0.05),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: Get.width * 0.5,
                                      spreadRadius: Get.width * 0.1,
                                      offset: Offset(
                                        Get.width * 0.1,
                                        Get.width * 0.1,
                                      ),
                                    ),
                                  ],
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.getCompanyNameLikeList.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            _usernameController.text =
                                                controller
                                                        .getCompanyNameLikeList[
                                                            index]
                                                        .companyName ??
                                                    "";
                                            isShowClearButton.value = true;
                                            setState(() {
                                              companyKey = controller
                                                  .getCompanyNameLikeList[index]
                                                  .companyKey
                                                  .toString();
                                              loginUrl = controller
                                                      .getCompanyNameLikeList[
                                                          index]
                                                      .loginUrl ??
                                                  "";
                                            });
                                            // setState(() {
                                            //   loginUrl = controller
                                            //           .getCompanyNameLikeList[
                                            //               index]
                                            //           .loginUrl ??
                                            //       "";
                                            // });
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            controller.isHide.value = true;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: Get.width * 0.05,
                                                  width: Get.width * 0.1,
                                                  child: Image.network(
                                                    controller
                                                            .getCompanyNameLikeList[
                                                                index]
                                                            .companyLogo ??
                                                        "",
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child: SizedBox(
                                                          height: 10,
                                                          width: 10,
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    errorBuilder: (context,
                                                        exception, stackTrace) {
                                                      return const Icon(
                                                        Icons.error,
                                                        size: 15,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Text(
                                                  controller
                                                          .getCompanyNameLikeList[
                                                              index]
                                                          .companyName ??
                                                      "",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),

                SizedBox(
                    height: orientation == Orientation.portrait ? 10.0 : 20),
                // !controller.loadingData.value
                //     ? const SizedBox()
                //     :
                controller.loadingData.value == true ||
                        controller.loadingDataCSignIn.value == true
                    ? const SizedBox()
                    : const Text("Enter your registered Company ID",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                SizedBox(
                    height: orientation == Orientation.portrait ? 40.0 : 2),
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: Checkbox(
                          checkColor: Colors.black,
                          activeColor: Colors.amberAccent,
                          fillColor: MaterialStateProperty.all(Colors.white),
                          value: rememberMeValueForCompanyID,
                          onChanged: (bool? value) {
                            setState(() {
                              rememberMeValueForCompanyID = value!;
                            });
                          },
                          // side: BorderSide(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(
                                  color: Colors.white, width: 10)),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Remember me',
                        style: appTheme.textTheme.bodyText2!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      padding: const EdgeInsets.all(0),
                      focusColor: appTheme.primaryColor,
                      highlightColor: appTheme.primaryColor,
                      hoverColor: appTheme.primaryColor,
                      splashRadius: 30,
                      splashColor: appTheme.primaryColor,
                      color: appTheme.primaryColor,
                      disabledColor: Colors.white,
                      icon: Image.asset(Assets.icLoginArrow.path),
                      iconSize: 60,
                      onPressed: () async {
                        if (_usernameController.text == '') {
                          showErrorDialog(
                              'Please enter your registered company ID', '');
                          return;
                        }
                        // var loginUrlSpilt =
                        //     loginUrl.split('/company/')[1]; // staggingc
                        // if (kDebugMode) {
                        //   print('loginUrl :::: $loginUrl');
                        // }
                        // // var loginUrlSpilt =
                        // //     loginUrl.split('/#/')[1]; // production
                        // var companyKey = loginUrlSpilt.replaceAll('"', '');
                        // setState(() {
                        //   UserPreferences.compIDRememberMe =
                        //       rememberMeValueForCompanyID;
                        // });
                        // if (kDebugMode) {
                        //   print('Cpmpany Key :::::: $companyKey');
                        //   print(
                        //       'compIDRememberMeGet Key :::::: ${UserPreferences.compIDRememberMeGet}');
                        // }

                        // var loginUrlSpilt =
                        //     loginUrl.split('/company/')[1]; // staggingc

                        var loginUrlSpilt =
                            loginUrl.split('/#/')[1]; // production
                        if (kDebugMode) {
                          print('loginUrl :::: $loginUrl');
                          print('loginUrlSpilt :::: $loginUrlSpilt');
                        }
                        var companyKeyTemp = loginUrlSpilt.replaceAll('"', '');

                        setState(() {
                          UserPreferences.compIDRememberMe =
                              rememberMeValueForCompanyID;
                          UserPreferences.compKey = int.parse(companyKey);
                        });

                        if (kDebugMode) {
                          print('Company Key :::::: $companyKey');
                          print('Company Key Temp:::::: $companyKeyTemp');
                          print(
                              'compIDRememberMeGet Key :::::: ${UserPreferences.compIDRememberMeGet}');
                        }
                        bool _isInternetConnected =
                            await BaseClientClass.isInternetConnected();
                        if (!_isInternetConnected) {
                          await Get.to(() => const NoInternetScreen());
                          Get.back();
                          return;
                        }
                        await controller.companySignIn(companyKeyTemp.trim());

                        controller.isHide.value = true;
                      }),
                )
                // old func
                // Container(
                //   alignment: Alignment.centerRight,
                //   child: IconButton(
                //     padding: const EdgeInsets.all(0),
                //     focusColor: appTheme.primaryColor,
                //     highlightColor: appTheme.primaryColor,
                //     hoverColor: appTheme.primaryColor,
                //     splashRadius: 30,
                //     splashColor: appTheme.primaryColor,
                //     color: appTheme.primaryColor,
                //     disabledColor: Colors.white,
                //     icon: Image.asset(Assets.icLoginArrow.path),
                //     //icon: const Icon(CupertinoIcons.arrow_right),
                //     iconSize: 60,
                //     onPressed: () {
                //       if (formKey.currentState!.validate()) {
                //         controller.companySignIn(_usernameController.text.trim());
                //         // TopVariable.apiService
                //         //     .getCompanyKey(_usernameController.text.trim())
                //         //     .then((response) {
                //         //   if (kDebugMode) {
                //         //     print('API response is\t' + response.toString());
                //         //     print('API response is\t' +
                //         //         response.toString().length.toString());
                //         //     print(response.toString() != '');
                //         //     print(response.toString().isNotEmpty);
                //         //   }
                //         //   if (response.toString().length > 2) {
                //         //     Map<String, dynamic> mappedResponse =
                //         //         response as Map<String, dynamic>;
                //         //     UserPreferences.compKey = mappedResponse['compKey'];
                //         //     UserPreferences.tenantLogoPath =
                //         //         mappedResponse['companyLogo'];
                //         //     UserPreferences.compName = _usernameController.text;
                //         //     Navigator.push(
                //         //         context,
                //         //         PageRouteBuilder(
                //         //             transitionDuration:
                //         //                 const Duration(seconds: 1),
                //         //             pageBuilder: (_, __, ___) =>
                //         //                 const LoginTenantPage()));
                //         //   } else {
                //         //     showErrorDialog('Company Not Found');
                //         //   }
                //         // }).catchError((e) {
                //         //   showErrorDialog(e.toString());
                //         // });

                //       }
                //       // controller.companySignIn('GoSolar');
                //     },
                //   ),
                // )
              ],
            ),
          ),
          Positioned(
            // top: screenHeight! - 45,
            right: 0,
            left: 0,
            bottom: Platform.isAndroid ? 15 : 50,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
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
                        style: Theme.of(context).textTheme.caption,
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
                        'Terms of Service',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 3,
                  width: screenWidth!,
                  color: appTheme.colorScheme.secondary,
                ),
              ],
            ),
          ),
          controller.loadingDataCSignIn.value
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: CustomColor.grenishColor,
                  )),
                )
              : const SizedBox()
        ]);
      });
    });
  }

  bool isSecondScreen = false;
  bool rememberMeValue = false;

  /*askPermission() async {
    // Telephony.instance.requestPhoneAndSmsPermissions;
    // // Permission.contacts.request();
    // await Permission.location.request();\
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.location,
      Permission.contacts,
      Permission.sms
    ].request();
    print(statuses[Permission.notification]);
    print(statuses[Permission.location]);
    print(statuses[Permission.contacts]);
    print(statuses[Permission.sms]);
  }*/
}
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // ignore_for_file: unused_local_variable, deprecated_member_use

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:solaramps/controllers_/auth_controller.dart';
// import 'package:solaramps/gen/assets.gen.dart';
// import 'package:solaramps/utility/shared_preference.dart';
// import 'package:solaramps/utility/top_level_variables.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../utility/app_url.dart';
// import '../utility/paths.dart';
// import '../utility/validator.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   AuthController authController = Get.put(AuthController());
//   //Duration get signupTime => Duration(milliseconds: timeDilation.ceil() * 2250);
//   final formKey = GlobalKey<FormState>();
//   String username = '', password = '';
//   String? fcmToken = '';
//   final TextEditingController _usernameController = TextEditingController();

//   @override
//   void dispose() {
//     // _controller.dispose();
//     super.dispose();
//   }

//   /* firebaseToken() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     fcmToken = await messaging.getToken();
//     print("firebase token is \t $fcmToken");
//   }*/

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
//           if (UserPreferences.rememberMe) {
//             setState(() {
//               _usernameController.text = UserPreferences.compName != ""
//                   ? UserPreferences.compName
//                   : '';
//             });
//           }
//         }));

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         child: returnLoginScreenWidget(authController),
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 colorFilter: ColorFilter.mode(
//                     Colors.black.withOpacity(0.4), BlendMode.darken),
//                 image: const AssetImage(assetsLogo),
//                 fit: BoxFit.cover)),
//       ),
//     );
//   }

// // https://bestage.azurewebsites.net/solarapi/company/compkey/Genx-nextgen
//   Widget returnLoginScreenWidget(AuthController controller) {
//     const double smallLogo = 90.0;
//     const double bigLogo = 130.0;
//     return OrientationBuilder(builder: (context, orientation) {
//       return Stack(fit: StackFit.expand, children: [
//         Positioned(
//             left: orientation == Orientation.portrait ? 0 : (screenWidth! / 2),
//             bottom: orientation == Orientation.portrait ? 50 : 25,
//             child: Align(
//               alignment: Alignment.center,
//               child: Image.asset(
//                 assetPathCompanyWatermark,
//                 width: screenWidth,
//               ),
//             )),
//         Form(
//           key: formKey,
//           child: ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             children: <Widget>[
//               SizedBox(
//                   height: orientation == Orientation.portrait ? 100.0 : 50.0),
//               Hero(
//                 tag: 'logo',
//                 child: Image.asset(
//                   assetPathCompanyLogoPng,
//                   height: 60,
//                   color: appTheme.colorScheme.secondary,
//                 ),
//               ),
//               const SizedBox(height: 10.0),
//               Hero(
//                 tag: 'logo_writing',
//                 child: Image.asset(
//                   assetPathCompanyLogoWriting,
//                   color: Colors.white,
//                   // width: 7,
//                   height: 50,
//                 ),
//               ),
//               SizedBox(
//                   height: orientation == Orientation.portrait ? 100.0 : 50),
//               Text("Company ID",
//                   style: TextStyle(
//                       color: appTheme.colorScheme.secondary,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold)),
//               SizedBox(height: orientation == Orientation.portrait ? 10.0 : 20),
//               TextFormField(
//                 validator: validateCompanyId,
//                 controller: _usernameController,
//                 // onChanged: (value) {
//                 //   if (value.length > 1) {
//                 //     controller.isHide.value = false;
//                 //     controller.getCompanyNameLike(value);
//                 //   }
//                 //   if (value.isEmpty || value.length < 2) {
//                 //     controller.isHide.value = true;
//                 //   }
//                 // },
//                 //  onSaved: (value) => _username = value!,
//                 decoration: InputDecoration(
//                     fillColor: Colors.white,
//                     filled: true,
//                     contentPadding: const EdgeInsets.only(left: 15),
//                     suffixIcon: InkWell(
//                       child: const Icon(Icons.close),
//                       onTap: () {
//                         _usernameController.clear();
//                       },
//                     ),
//                     hintStyle: appTheme.textTheme.bodyText2),
//                 keyboardType: TextInputType.text,
//               ),
//               // Listview for company name like api
//               controller.loadingData.value == true
//                   ? Container(
//                       width: Get.width * 0.92,
//                       height: Get.height * 0.1,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(Get.width * 0.05),
//                           bottomRight: Radius.circular(Get.width * 0.05),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: Get.width * 0.5,
//                             spreadRadius: Get.width * 0.1,
//                             offset: Offset(
//                               Get.width * 0.1,
//                               Get.width * 0.1,
//                             ),
//                           ),
//                         ],
//                       ),
//                       child: Center(
//                         child: SizedBox(
//                           width: Get.width * 0.08,
//                           height: Get.width * 0.08,
//                           child: const CircularProgressIndicator(),
//                         ),
//                       ),
//                     )
//                   : const SizedBox(),
//               //     // : controller.isHide.value == true
//               //     //     ? const SizedBox()
//               //     //     : Container(
//               //     //         width: Get.width * 0.9,
//               //     //         height: Get.height * 0.1,
//               //     //         decoration: BoxDecoration(
//               //     //           color: Colors.white,
//               //     //           borderRadius: BorderRadius.only(
//               //     //             bottomLeft: Radius.circular(Get.width * 0.05),
//               //     //             bottomRight: Radius.circular(Get.width * 0.05),
//               //     //           ),
//               //     //           boxShadow: [
//               //     //             BoxShadow(
//               //     //               color: Colors.black12,
//               //     //               blurRadius: Get.width * 0.5,
//               //     //               spreadRadius: Get.width * 0.1,
//               //     //               offset: Offset(
//               //     //                 Get.width * 0.1,
//               //     //                 Get.width * 0.1,
//               //     //               ),
//               //     //             ),
//               //     //           ],
//               //     //         ),
//               //     //         child: ListView.builder(
//               //     //           padding: EdgeInsets.zero,
//               //     //           shrinkWrap: true,
//               //     //           itemCount: 1,
//               //     //           itemBuilder: (context, index) {
//               //     //             return Column(
//               //     //               children: [
//               //     //                 InkWell(
//               //     //                   onTap: () {
//               //     //                     // _usernameController.text = 'GoSolar';
//               //     //                     controller.companySignIn('GoSolar');
//               //     //                     controller.isHide.value = true;
//               //     //                   },
//               //     //                   child: Padding(
//               //     //                     padding: const EdgeInsets.all(8.0),
//               //     //                     child: Row(
//               //     //                       children: [
//               //     //                         SizedBox(
//               //     //                           height: Get.width * 0.05,
//               //     //                           width: Get.width * 0.1,
//               //     //                           child: Image.network(
//               //     //                               'https://devstoragesi.blob.core.windows.net/public/CEF-Logo.png'),
//               //     //                         ),
//               //     //                         const Text(
//               //     //                           'GoSolar',
//               //     //                           textAlign: TextAlign.center,
//               //     //                           style: TextStyle(
//               //     //                             color: Colors.black,
//               //     //                           ),
//               //     //                         ),
//               //     //                       ],
//               //     //                     ),
//               //     //                   ),
//               //     //                 ),
//               //     //               ],
//               //     //             );
//               //     //           },
//               //     //         ),
//               //     //       ),

//               SizedBox(height: orientation == Orientation.portrait ? 10.0 : 20),
//               // !controller.loadingData.value
//               //     ? const SizedBox()
//               //     :
//               controller.loadingData.value == true
//                   ? const SizedBox()
//                   : const Text("Enter your registered Company ID",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold)),
//               SizedBox(height: orientation == Orientation.portrait ? 40.0 : 2),
//               Container(
//                 alignment: Alignment.centerRight,
//                 child: IconButton(
//                   padding: const EdgeInsets.all(0),
//                   focusColor: appTheme.primaryColor,
//                   highlightColor: appTheme.primaryColor,
//                   hoverColor: appTheme.primaryColor,
//                   splashRadius: 30,
//                   splashColor: appTheme.primaryColor,
//                   color: appTheme.primaryColor,
//                   disabledColor: Colors.white,
//                   icon: Image.asset(Assets.icLoginArrow.path),
//                   //icon: const Icon(CupertinoIcons.arrow_right),
//                   iconSize: 60,
//                   onPressed: () {
//                     if (formKey.currentState!.validate()) {
//                       controller.companySignIn(_usernameController.text.trim());
//                       // TopVariable.apiService
//                       //     .getCompanyKey(_usernameController.text.trim())
//                       //     .then((response) {
//                       //   if (kDebugMode) {
//                       //     print('API response is\t' + response.toString());
//                       //     print('API response is\t' +
//                       //         response.toString().length.toString());
//                       //     print(response.toString() != '');
//                       //     print(response.toString().isNotEmpty);
//                       //   }
//                       //   if (response.toString().length > 2) {
//                       //     Map<String, dynamic> mappedResponse =
//                       //         response as Map<String, dynamic>;
//                       //     UserPreferences.compKey = mappedResponse['compKey'];
//                       //     UserPreferences.tenantLogoPath =
//                       //         mappedResponse['companyLogo'];
//                       //     UserPreferences.compName = _usernameController.text;
//                       //     Navigator.push(
//                       //         context,
//                       //         PageRouteBuilder(
//                       //             transitionDuration:
//                       //                 const Duration(seconds: 1),
//                       //             pageBuilder: (_, __, ___) =>
//                       //                 const LoginTenantPage()));
//                       //   } else {
//                       //     showErrorDialog('Company Not Found');
//                       //   }
//                       // }).catchError((e) {
//                       //   showErrorDialog(e.toString());
//                       // });

//                     }
//                     // controller.companySignIn('GoSolar');
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//         Positioned(
//           // top: screenHeight! - 45,
//           right: 0,
//           left: 0,
//           bottom: 15,
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   InkWell(
//                     onTap: () async {
//                       if (await canLaunch(AppUrl.privacyPolicyURL) == true) {
//                         launch(AppUrl.privacyPolicyURL);
//                       } else {
//                         if (kDebugMode) {
//                           print("Can't launch privacy policy URL");
//                         }
//                       }
//                     },
//                     child: Text(
//                       'Privacy Policy',
//                       style: Theme.of(context).textTheme.caption,
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 15,
//                   ),
//                   const Icon(
//                     CupertinoIcons.circle_fill,
//                     size: 5,
//                     color: Colors.grey,
//                   ),
//                   // Text('.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10),),
//                   const SizedBox(
//                     width: 15,
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       if (await canLaunch(AppUrl.termsOfUseURL) == true) {
//                         launch(AppUrl.termsOfUseURL);
//                       } else {
//                         if (kDebugMode) {
//                           print("Can't launch terms of use URL");
//                         }
//                       }
//                     },
//                     child: Text(
//                       'Terms of Service',
//                       style: Theme.of(context).textTheme.caption,
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Container(
//                 height: 3,
//                 width: screenWidth!,
//                 color: appTheme.colorScheme.secondary,
//               ),
//             ],
//           ),
//         )
//       ]);
//     });
//   }

//   bool isSecondScreen = false;
//   bool rememberMeValue = false;

//   /*askPermission() async {
//     // Telephony.instance.requestPhoneAndSmsPermissions;
//     // // Permission.contacts.request();
//     // await Permission.location.request();\
//     // You can request multiple permissions at once.
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.notification,
//       Permission.location,
//       Permission.contacts,
//       Permission.sms
//     ].request();
//     print(statuses[Permission.notification]);
//     print(statuses[Permission.location]);
//     print(statuses[Permission.contacts]);
//     print(statuses[Permission.sms]);
//   }*/
// }
