import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegularTextInput extends StatelessWidget {
  const RegularTextInput({
    Key? key,
    this.obscureText = false,
    this.focusNode,
    this.hintText,
    this.suffix,
    this.prefixIcon,
    this.controller,
    this.background,
    this.radius,
    this.errorText,
    this.minLine = 1,
    this.maxLine = 1,
    this.onChange,
    this.onSubmit,
    this.inputAction,
    this.style,
    this.inputType,
    this.border,
    this.enable = true,
    this.onTap,
    this.readOnly,
    this.inputFormatters,
    this.maxLength,
    this.autoFocus,
    this.label,
    this.isRequired,
  }) : super(key: key);

  final Widget? prefixIcon;
  final bool? obscureText, enable, readOnly;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText, errorText;
  final Widget? suffix;
  final Color? background;
  final double? radius;
  final int? minLine, maxLine;
  final ValueChanged<String>? onChange, onSubmit;
  final TextInputAction? inputAction;
  final TextStyle? style;
  final TextInputType? inputType;
  final InputBorder? border;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool? autoFocus;
  final String? label;
  final bool? isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: TextSpan(
                text: label,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                children: [
                  if (isRequired == true)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        TextFormField(
          focusNode: focusNode,
          controller: controller,
          obscureText: obscureText ?? false,
          minLines: minLine,
          maxLines: maxLine,
          maxLength: maxLength,
          onChanged: onChange,
          onFieldSubmitted: onSubmit,
          textInputAction: inputAction ?? TextInputAction.done,
          style: style ?? const TextStyle(color: Colors.black),
          keyboardType: inputType,
          enabled: enable,
          onTap: onTap,
          readOnly: readOnly ?? false,
          inputFormatters: inputFormatters,
          autofocus: autoFocus ?? false,
          decoration: InputDecoration(
            errorText: errorText,
            hintText: hintText ?? '',
            prefixIcon: prefixIcon,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            filled: background != null,
            fillColor: background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
