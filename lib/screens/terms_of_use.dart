import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solaramps/utility/constants.dart';

class TermsOfUse extends StatefulWidget {
  const TermsOfUse({Key? key}) : super(key: key);

  @override
  State<TermsOfUse> createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Terms Of Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.5),
        child: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: GoogleFonts.notoSans().fontFamily,
                  color: Colors.black),
              children: const [
                TextSpan(text: Constants.TermsOfService),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
