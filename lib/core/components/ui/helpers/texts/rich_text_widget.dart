import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichTextPart {
  final String text;
  final TextStyle? style;
  final VoidCallback? onTap;

  const RichTextPart({required this.text, this.style, this.onTap});
}

class AppRichText extends StatelessWidget {
  final List<RichTextPart> parts;
  final TextStyle? defaultStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppRichText({
    super.key,
    required this.parts,
    this.defaultStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: defaultStyle,
        children: parts.map((part) {
          return TextSpan(
            text: part.text,
            style: part.style,
            recognizer: part.onTap != null
                ? (TapGestureRecognizer()..onTap = part.onTap)
                : null,
          );
        }).toList(),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
