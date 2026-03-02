import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSortDropdownController extends GetxController {
  OverlayEntry? _overlayEntry;
  final LayerLink layerLink = LayerLink();

  bool get isShowing => _overlayEntry != null;

  void show(BuildContext context, Widget dropdownContent) {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Transparent barrier
          Positioned.fill(
            child: GestureDetector(
              onTap: hide,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),

          // Dropdown content
          CompositedTransformFollower(
            link: layerLink,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: Offset(0, size.height - 25),
            child: dropdownContent,
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void onClose() {
    hide();
    super.onClose();
  }
}
