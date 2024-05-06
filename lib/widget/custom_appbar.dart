import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solaramps/theme/color.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key, required this.title, this.actions, this.route})
      : super(key: key);

  final String title;
  final List<Widget>? actions;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: () {
                  route == null
                      ? Navigator.pop(context)
                      : Navigator.pushNamedAndRemoveUntil(
                    context,
                    route!,
                        (Route<dynamic> route) => false,
                  );
                },
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.openSans().fontFamily),
              ),
            ],
          ),
          actions != null
              ? Row(
            children: actions!,
          )
              : Container(),
        ],
      ),
      // color: appTheme.primaryColor,
      color: CustomColor.grenishColor,
    );
  }
}
