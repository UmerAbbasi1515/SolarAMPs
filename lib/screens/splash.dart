import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:solaramps/utility/top_level_variables.dart';

import '../providers/auth_provider.dart';
// import '../providers/user_provider.dart';
import '../utility/paths.dart';

class SignUpMenuPage extends StatefulWidget {
  const SignUpMenuPage({Key? key}) : super(key: key);

  @override
  _SignUpMenuPageState createState() => _SignUpMenuPageState();
}

class _SignUpMenuPageState extends State<SignUpMenuPage> {
  // static const color = Color(0xff002d74);
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
        () => {Navigator.pushNamed(context, '/login')});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          // ChangeNotifierProvider(create: (_)=>UserProvider()),
        ],
        child: Scaffold(
          body: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  assetPathCompanyLogo,
                  color: appTheme.colorScheme.primary,
                )
              ],
            ),
          ),
        ));
  }
}
