import 'package:component/component.dart';
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

class ForgotPasswordSection extends StatelessWidget {
  const ForgotPasswordSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).question_forget_pass,
            style: TextStyle(color: Colors.black),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/forgot-password');
            },
            child: SubTitle2Text(
              ' ${S.of(context).click_here}',
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
