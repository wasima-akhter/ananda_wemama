import 'package:flutter/material.dart';
import 'package:mama_app/app/helper_widgets_export.dart';
import 'package:mama_app/core/helpers/string_helper.dart';

class BounceSingleChildScrollView extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final ScrollController? scrollController;
  const BounceSingleChildScrollView({
    super.key,
    required this.child,
    this.padding,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      child: child,
    );
  }
}

class UnderlinedTxt extends StatelessWidget {
  final Text text;
  const UnderlinedTxt({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        spacing: 0,
        children: [
          text,
          Container(
            height: 1,
            color: text.style?.color,
            width: findTextWidth(text.data ?? '', fs: text.style?.fontSize),
          ),
        ],
      ),
    );
  }
}
