import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double height;
  final String imageUrl;

  const LogoWidget({
    this.height = 100,
    this.imageUrl = "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height,
    );
  }
}
