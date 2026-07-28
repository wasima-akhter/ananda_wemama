import 'package:flutter/material.dart';
import 'package:we_mama/app/helper_widgets_export.dart';

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
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: child,
    );
  }
}
