import 'package:flutter/material.dart';

class ResponsiveFormWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveFormWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final double maxWidth = width > 600 ? 500 : double.infinity;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: child,
        ),
      ),
    );
  }
}
