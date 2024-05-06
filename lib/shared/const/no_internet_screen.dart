import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solaramps/utility/paths.dart';
import 'package:solaramps/widget/button_widget.dart';

// ignore: must_be_immutable
class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double? screenWidth = MediaQuery.of(context).size.width;
    double? screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
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
                  height: screenHeight,
                  width: screenWidth,
                )),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: Get.height / 3),
                      child: Image.asset(
                        solarWithLogo,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Icon(
                        Icons.signal_wifi_statusbar_connected_no_internet_4,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'No internet Connection',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: ButtonWidget(
                          text: 'Retry',
                          onClicked: () async {
                            bool _isInternetConnected =
                                await isInternetConnected();
                            if (_isInternetConnected) {
                              Get.back(result: true);
                            } else {
                              Get.snackbar('Alert',
                                  'Please check your internet connection',
                                  backgroundColor: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme
                                      ?.primary,
                                  colorText: Colors.white);
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
