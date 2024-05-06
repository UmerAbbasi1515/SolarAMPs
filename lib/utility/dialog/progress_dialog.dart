import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../top_level_variables.dart';

class CustomProgressDialog {
  CustomProgressDialog() {
    EasyLoading.instance.backgroundColor = appTheme.colorScheme.primary;
  }

  static final ProgressDialog _progressDialog =
      ProgressDialog(context: appNavigationKey.currentContext);

  static showProDialog() async {
    if (!_progressDialog.isOpen()) {
      EasyLoading.show(
        status: "Please wait...",
        dismissOnTap: false,
      );
      // _progressDialog.show(max: 100, msg: 'Please wait...');
    }
  }

  static hideProDialog() async {
    // _progressDialog.close();
    EasyLoading.dismiss();
  }
}
