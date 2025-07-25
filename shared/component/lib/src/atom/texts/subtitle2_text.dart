import 'package:flutter/material.dart';

class SubTitle2Text extends StatelessWidget {
  const SubTitle2Text(
    this.text, {
    Key? key,
    this.style,
    this.maxLine,
    this.overflow,
    this.align,
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final int? maxLine;
  final TextOverflow? overflow;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      maxLines: maxLine,
      overflow: overflow,
      textAlign: align,
    );
  }
}
