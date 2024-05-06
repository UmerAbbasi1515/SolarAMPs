import 'package:flutter/material.dart';
import 'package:solaramps/utility/dialog/progress_dialog.dart';
import 'package:solaramps/utility/top_level_variables.dart';

class ErrorDialog extends StatefulWidget {
  final String description;
  final String errorTitle;
  const ErrorDialog(
      {Key? key, required this.description, required this.errorTitle})
      : super(key: key);
  @override
  _ErrorDialog createState() => _ErrorDialog();
}

class _ErrorDialog extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          widget.errorTitle == '' ? const SizedBox() : Text(widget.errorTitle),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              widget.description,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () async {
            isErrorDialogShowing = false;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

bool isErrorDialogShowing = false;
showErrorDialog(String errorDetail, String errorTitle) {
  CustomProgressDialog.hideProDialog();
  if (!isErrorDialogShowing) {
    isErrorDialogShowing = true;
    showDialog(
        barrierDismissible: false,
        context: appNavigationKey.currentContext!,
        builder: (BuildContext context) {
          return Center(
            child: ErrorDialog(
              description: errorDetail,
              errorTitle: errorTitle,
            ),
          );
        });
  }
}
