import 'package:flutter/material.dart';

class TextFit extends StatelessWidget {
  final String data;

  // Common Text properties
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final TextScaler? textScaler;
  final String? semanticsLabel;

  const TextFit(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines = 1, // default for ellipsis use-case
    this.overflow = TextOverflow.ellipsis,
    this.softWrap = true,
    this.textDirection,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.textScaler,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      textScaler: textScaler,
      semanticsLabel: semanticsLabel,
    );
  }
}
