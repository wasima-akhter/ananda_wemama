import 'package:flutter/material.dart';

class ImageErrorBuilder extends StatelessWidget {
  final double? width;
  final double? height;
  const ImageErrorBuilder({Key? key, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}
