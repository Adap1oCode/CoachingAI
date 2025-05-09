import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackButtonWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
      onPressed: onPressed ?? () => Navigator.pop(context),
    );
  }
}
