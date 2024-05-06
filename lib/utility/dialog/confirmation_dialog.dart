import 'package:flutter/material.dart';

class ConfirmationDialog extends StatefulWidget {
  final String? title;
  final String? description;
  final String? confirmedText;
  final VoidCallback? onConfirmed;

  const ConfirmationDialog(
      {Key? key, this.title, this.description, this.onConfirmed, this.confirmedText}) : super(key: key);

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title!,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headline6!.fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          )),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(widget.description!,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                )),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        widget.confirmedText != null
            ? TextButton(
                child: Text(widget.confirmedText!),
                onPressed: widget.onConfirmed,
              )
            : Container(),
      ],
    );
  }
}
