import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solaramps/utility/paths.dart';
import 'package:solaramps/utility/shared_preference.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final List<String> _list = [
    "Are you worried about smartly \ncoping with your Solar\nManagement?",
    "Welcome !\nTo the most comprehensive\nand optimized\n\nSolar Cloud  Platform ",
    "A SAAS enabled platform for\nend to end solar energy\n management."
  ];

  int stepCount = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assetsLogo),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 50,
            ),
            SvgPicture.asset(
              assetPathCompanyLogo,
              height: 80,
              width: 80,
              color: appTheme.colorScheme.secondary,
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              assetPathCompanyLogoWriting,
              color: Colors.white,
              // width: 7,
              height: 50,
            ),
            const SizedBox(
              height: 50,
            ),
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                height: 300.0,
                reverse: false,
                onPageChanged: (i, s) {
                  setState(() {
                    stepCount = i;
                  });
                },
              ),
              items: _list.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: screenWidth,
                        padding:const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            i,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ));
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: screenHeight! / 7,
            ),
            stepCount == 2
                ? InkWell(
                    onTap: () {
                      UserPreferences.firstInstall = false;
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      "Finish",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        backgroundColor: appTheme.colorScheme.secondary,
                      ),
                    ),
                  )
                : const Text(
                    "Skip",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _carouselController.previousPage(
                          duration:const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: stepCount == 0
                            ? appTheme.colorScheme.secondary
                            : Colors.white,
                        size: 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.circle,
                        color: stepCount == 1
                            ? appTheme.colorScheme.secondary
                            : Colors.white,
                        size: 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.circle,
                        color: stepCount == 2
                            ? appTheme.colorScheme.secondary
                            : Colors.white,
                        size: 10,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _carouselController.nextPage(
                          duration:const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight! / 14,
            ),
            const Text(
              "www.solarinformatics.com",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
           const SizedBox(
              height: 10,
            ),
            Container(
              height: 3,
              width: screenWidth,
              color: appTheme.colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
