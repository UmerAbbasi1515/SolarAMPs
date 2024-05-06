import 'dart:async';
//import 'package:fbroadcast/fbroadcast.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:solaramps/screens/app.dart';
import 'package:solaramps/theme/color.dart';
import 'package:solaramps/utility/shared_preference.dart';

import '../shared/controllers/theme_controller.dart';
import '../shared/services/theme_service.dart';
import '../shared/services/theme_service_prefs.dart';

// import 'firebase_options.dart';
Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: CustomColor.grenishColor,
  ));
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true,
      ignoreSsl:
          true // optional: set to false to disable printing logs to console (default: true)
      // ignoreSsl:
      //     true // option: set to false to disable working with http links (default: false)
      );

  final ThemeService themeService = ThemeServicePrefs();
  await themeService.init();
  final ThemeController controller = ThemeController(themeService);
  await controller.loadAll();
  await initializePreferences();

  runApp(SoloApp(themeController: controller));
}
