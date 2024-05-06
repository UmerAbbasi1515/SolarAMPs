// ignore_for_file: unused_element

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/controllers_/user_profile_screen_controller.dart';
import 'package:solaramps/dataModel/user_model.dart';
import 'package:solaramps/gen/assets.gen.dart';
import 'package:solaramps/providers/general_provider.dart';
import 'package:solaramps/screens/change_password.dart';
import 'package:solaramps/screens/create_ticket_screen.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/constants.dart';
import 'package:solaramps/utility/dialog/confirmation_dialog.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/widget/attatchment_widget.dart';
import 'package:solaramps/widget/error_dialog.dart';
import 'package:solaramps/widget/profile_pic_widget.dart';
import '../utility/top_level_variables.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    UserModel user = UserPreferences.user;
    UserProfileScreenController controller = Get.find();

    void initState() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getClientUserDetail();
      });
      super.initState();
    }

    const style =
        TextStyle(fontFamily: "open-medium", fontSize: 16, color: Colors.black);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              return controller.loadingData.value
                  ? const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            // back button
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Spacer(),
                                  IconButton(
                                    padding: const EdgeInsets.all(15),
                                    icon: const Icon(
                                      Icons.logout,
                                      size: 20,
                                    ),
                                    color: Colors.white,
                                    onPressed: () {
                                      showDialog<void>(
                                        context:
                                            appNavigationKey.currentContext!,
                                        barrierDismissible:
                                            false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return WillPopScope(
                                            onWillPop: () async => false,
                                            child: ConfirmationDialog(
                                              title: 'Logout',
                                              description:
                                                  'Are you sure you want to logout?',
                                              confirmedText: "Logout",
                                              onConfirmed: () async {
                                                bool rememberMe =
                                                    UserPreferences.rememberMe;
                                                // UserModel user = UserPreferences.user;
                                                // String compName =
                                                //     UserPreferences.compName;
                                                if (!rememberMe) {
                                                  UserPreferences.removeV(
                                                      "userImage");
                                                }
                                                TopVariable.dashboardProvider
                                                    .mappedResponse = Map.from({
                                                  "sytemSize": 0,
                                                  "currentValue": 0.0,
                                                  "peakValue": 0.0,
                                                  "dailyYield": 0,
                                                  "monthlyYield": 0.0,
                                                  "annualYield": 0,
                                                  "grossYield": 0,
                                                  "treesPlanted": 0,
                                                  "co2Reduction": 0
                                                });

                                                if (rememberMe) {
                                                  UserPreferences.token = null;
                                                }
                                                UserPreferences.token = null;

                                                setState(() {
                                                  AttachmentModel(
                                                    path: '',
                                                    type: '',
                                                    name: '',
                                                  );
                                                });

                                                bool rememberMeCompanyID =
                                                    UserPreferences
                                                        .compIDRememberMeGet;
                                                if (rememberMeCompanyID ==
                                                    true) {
                                                  // new
                                                  await TopVariable
                                                      .dashboardProvider
                                                      .resetAppData();
                                                  TopVariable
                                                      .switchScreenAndRemoveAll(
                                                          Constants
                                                              .loginTenantScreenPath);
                                                } else {
                                                  // old
                                                  await TopVariable
                                                      .dashboardProvider
                                                      .resetAppData();

                                                  TopVariable
                                                      .switchScreenAndRemoveAll(
                                                          Constants
                                                              .loginScreenPath);
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              color: CustomColor.grenishColor,
                            ),

                            // profile
                            Obx(() {
                              return controller
                                          .loadingDataForProfileImage.value &&
                                      !controller.loadingData.value
                                  ? Container(
                                      height: 300,
                                      color: CustomColor.grenishColor,
                                      child: const Center(
                                          child: SizedBox(
                                              height: 200,
                                              width: 200,
                                              child:
                                                  ProfilePicWidgetForLoading())),
                                    )
                                  : Container(
                                      height: 300,
                                      // color: appTheme.primaryColor,
                                      color: CustomColor.grenishColor,
                                      child: Column(
                                        children: [
                                          Consumer(builder: (context,
                                              GeneralProvider
                                                  advancedProfileProvider,
                                              _) {
                                            return ProfilePicWidget(
                                              avatar: advancedProfileProvider
                                                  .profilePicture,
                                              imagePath: controller
                                                          .profileImagePath
                                                          .value ==
                                                      ''
                                                  ? null
                                                  : controller
                                                      .profileImagePath.value,
                                              onClicked: () async {
                                                showModalBottomSheet<void>(
                                                    context: context,
                                                    builder: (c) {
                                                      return AttatchmentWidget(
                                                        showFiles: false,
                                                        onPressed: (e) async {
                                                          setState(() {
                                                            advancedProfileProvider
                                                                .updateProfilePicture(
                                                                    e[0].path);
                                                            if (kDebugMode) {
                                                              print(
                                                                  'E. Path :::::: ${e[0].path}');
                                                            }
                                                          });
                                                          await controller
                                                              .saveUserProfileImage(
                                                                  controller
                                                                      .entityId,
                                                                  e[0]
                                                                      .path
                                                                      .toString());
                                                          setState(() {});
                                                        },
                                                      );
                                                    });
                                              },
                                            );
                                          }),
                                          // Consumer(builder: (context,
                                          //     GeneralProvider advancedProfileProvider,
                                          //     _) {
                                          //   return ProfilePicWidget(
                                          //     avatar: advancedProfileProvider
                                          //         .profilePicture,
                                          //     imagePath: advancedProfileProvider
                                          //         .profilePicture,
                                          //     onClicked: () async {
                                          //       showModalBottomSheet<void>(
                                          //           context: context,
                                          //           builder: (c) {
                                          //             return AttatchmentWidget(
                                          //               showFiles: false,
                                          //               onPressed: (e) {
                                          //                 setState(() {
                                          //                   advancedProfileProvider
                                          //                       .updateProfilePicture(
                                          //                           e[0].path);
                                          //                 });
                                          //               },
                                          //             );
                                          //           });
                                          //     },
                                          //   );
                                          // }),
                                          const SizedBox(height: 25),
                                          // Name
                                          // Type
                                          controller.loadingData.value
                                              ? const SizedBox()
                                              : Align(
                                                  child: Hero(
                                                    tag: "userimage",
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Text(
                                                        '${controller.getUserProfileModel.data?.firstName ?? ''} ${controller.getUserProfileModel.data?.lastName ?? ""}',
                                                        style: const TextStyle(
                                                            fontSize: 22,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                "open-medium",
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  alignment: Alignment.center,
                                                ),
                                          const SizedBox(height: 5),
                                          controller.loadingData.value
                                              ? const SizedBox()
                                              : Align(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    child: Text(
                                                      controller
                                                              .getUserProfileModel
                                                              .data
                                                              ?.customerType ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              "open-medium",
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  alignment: Alignment.center,
                                                ),
                                          const SizedBox(height: 25),
                                        ],
                                      ),
                                    );
                            }),
                            const SizedBox(
                              height: 40,
                            ),
                            Obx(() {
                              return controller.loadingData.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    )
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                Assets.mail,
                                                // color: appTheme.colorScheme.primary,
                                                color: CustomColor.grenishColor,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.7,
                                                child: Text(
                                                  controller.getUserProfileModel
                                                          .data?.emailAddress ??
                                                      "",
                                                  style: style,
                                                  maxLines: 2,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.phone,
                                                // color: appTheme.primaryColor,
                                                color: CustomColor.grenishColor,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                controller.getUserProfileModel
                                                        .data?.phone ??
                                                    "",
                                                style: style,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.domain,
                                                color: CustomColor.grenishColor,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                UserPreferences.compName,
                                                style: style,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            color: const Color(0xFFDCDCDC),
                                            height: 1,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                // SvgPicture.asset(
                                                //   Assets.placeholder,
                                                //   color: appTheme.colorScheme.primary,
                                                // ),
                                                const Icon(
                                                  Icons.location_on_outlined,
                                                  // color: appTheme.colorScheme.primary,
                                                  color:
                                                      CustomColor.grenishColor,
                                                  size: 22,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  'Addresses',
                                                  style: style.copyWith(
                                                      color: const Color(
                                                          0xff505050)),
                                                ),
                                                const Spacer(),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  // color: appTheme.colorScheme.primary,
                                                  color:
                                                      CustomColor.grenishColor,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              TopVariable.switchScreen(Constants
                                                  .addressListScreenPath);
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                // SvgPicture.asset(
                                                //   Assets.subscription,
                                                //   color: appTheme.colorScheme.primary,
                                                // ),
                                                const Icon(
                                                  Icons.payment_outlined,
                                                  // color: appTheme.colorScheme.primary,
                                                  color:
                                                      CustomColor.grenishColor,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  'Subscriptions',
                                                  style: style.copyWith(
                                                      color: const Color(
                                                          0xff505050)),
                                                ),
                                                const Spacer(),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  // color: appTheme.colorScheme.primary,
                                                  color:
                                                      CustomColor.grenishColor,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              TopVariable.switchScreen(Constants
                                                  .subscriptionListScreenPath);
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                // SvgPicture.asset(
                                                //   Assets.creditCard,
                                                //   color: appTheme.colorScheme.primary,
                                                // ),
                                                const Icon(
                                                  Icons.payment_outlined,
                                                  // color: appTheme.colorScheme.primary,
                                                  color:
                                                      CustomColor.grenishColor,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  'Payment Methods',
                                                  style: style.copyWith(
                                                      color: const Color(
                                                          0xff505050)),
                                                ),
                                                const Spacer(),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  // color: appTheme.colorScheme.primary,
                                                  color:
                                                      CustomColor.grenishColor,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              TopVariable.switchScreen(Constants
                                                  .paymentMethodListScreenPath);
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            color: const Color(0xFFDCDCDC),
                                            height: 1,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .key, // color: appTheme.primaryColor,
                                                  color:
                                                      CustomColor.grenishColor,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  'Change Password',
                                                  style: style.copyWith(
                                                      color: const Color(
                                                          0xff505050)),
                                                ),
                                                const Spacer(),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  // color: appTheme.colorScheme.primary,
                                                  color:
                                                      CustomColor.grenishColor,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              // TopVariable.switchScreen(Constants
                                              //     .resetPasswordScreenPath);
                                              if (controller.getUserProfileModel
                                                          .data?.emailAddress ==
                                                      '' ||
                                                  controller.getUserProfileModel
                                                          .data?.emailAddress ==
                                                      null) {
                                                showErrorDialog(
                                                    'Your email is not found',
                                                    '');
                                              } else {
                                                Get.to(() => ChangePassword(
                                                      email: controller
                                                              .getUserProfileModel
                                                              .data
                                                              ?.emailAddress ??
                                                          "",
                                                    ));
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Icon(
                                                  Icons.exit_to_app,
                                                  // color: appTheme.primaryColor,
                                                  color:
                                                      CustomColor.grenishColor,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  'Logout',
                                                  style: style.copyWith(
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              showDialog<void>(
                                                context: appNavigationKey
                                                    .currentContext!,
                                                barrierDismissible:
                                                    false, // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return WillPopScope(
                                                    onWillPop: () async =>
                                                        false,
                                                    child: ConfirmationDialog(
                                                      title: 'Logout',
                                                      description:
                                                          'Are you sure you want to logout?',
                                                      confirmedText: "Logout",
                                                      onConfirmed: () async {
                                                        bool rememberMe =
                                                            UserPreferences
                                                                .rememberMe;
                                                        // UserModel user = UserPreferences.user;
                                                        // String compName =
                                                        //     UserPreferences.compName;
                                                        if (!rememberMe) {
                                                          UserPreferences
                                                              .removeV(
                                                                  "userImage");
                                                        }
                                                        TopVariable
                                                                .dashboardProvider
                                                                .mappedResponse =
                                                            Map.from({
                                                          "sytemSize": 0,
                                                          "currentValue": 0.0,
                                                          "peakValue": 0.0,
                                                          "dailyYield": 0,
                                                          "monthlyYield": 0.0,
                                                          "annualYield": 0,
                                                          "grossYield": 0,
                                                          "treesPlanted": 0,
                                                          "co2Reduction": 0
                                                        });

                                                        if (rememberMe) {
                                                          UserPreferences
                                                              .token = null;
                                                        }
                                                        UserPreferences.token =
                                                            null;

                                                        setState(() {
                                                          AttachmentModel(
                                                            path: '',
                                                            type: '',
                                                            name: '',
                                                          );
                                                        });
                                                        // await TopVariable.dashboardProvider
                                                        //     .resetAppData();

                                                        // TopVariable.switchScreenAndRemoveAll(
                                                        //     Constants.loginScreenPath);
                                                        bool
                                                            rememberMeCompanyID =
                                                            UserPreferences
                                                                .compIDRememberMeGet;
                                                        if (rememberMeCompanyID ==
                                                            true) {
                                                          // new
                                                          await TopVariable
                                                              .dashboardProvider
                                                              .resetAppData();
                                                          TopVariable
                                                              .switchScreenAndRemoveAll(
                                                                  Constants
                                                                      .loginTenantScreenPath);
                                                        } else {
                                                          // old
                                                          await TopVariable
                                                              .dashboardProvider
                                                              .resetAppData();

                                                          TopVariable
                                                              .switchScreenAndRemoveAll(
                                                                  Constants
                                                                      .loginScreenPath);
                                                        }
                                                      },
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                            }),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ],
                    );
            })
          ],
        ),
      ),
    );
  }
}
