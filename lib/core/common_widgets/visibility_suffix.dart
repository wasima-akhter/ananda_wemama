import 'package:flutter/material.dart';

import '../utils/extension/context_extension.dart';
import 'gesture_detector_cus.dart';

class VisibilitySuffix extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  const VisibilitySuffix({Key? key, this.onTap, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CusGestureDetector(
      onTap: onTap,
      child: Icon(icon, color: c.primary),
    );
  }
}
