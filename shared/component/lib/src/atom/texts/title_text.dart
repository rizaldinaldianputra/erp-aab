import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText(
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

  TextStyle? _getStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getStyle(context)?.merge(style),
      maxLines: maxLine,
      overflow: overflow,
      textAlign: align,
    );
  }
}
