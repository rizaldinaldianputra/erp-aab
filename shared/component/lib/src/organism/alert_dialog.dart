import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

class AppAlertDialog extends StatelessWidget {
  final Widget body;
  final List<Widget>? actions;
  const AppAlertDialog({
    Key? key,
    required this.body,
    this.actions,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: TextTheme(),
      ),
      child: AlertDialog(
        content: body,
        actions: actions,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.dp10)),
      ),
    );
  }
}
