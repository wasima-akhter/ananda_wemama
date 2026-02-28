import 'package:flutter/material.dart';

class CusGestureDetector extends StatelessWidget {
  final void Function()? onTap;
  final HitTestBehavior? behavior;
  final Widget child;
  const CusGestureDetector({Key? key, this.onTap, this.behavior, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: child);
  }
}
