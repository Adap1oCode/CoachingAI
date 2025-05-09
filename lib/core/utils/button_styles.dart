import 'package:flutter/material.dart';

ButtonStyle elevatedButtonStyle() {
  return ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: const Color(0xFF00BF6D),
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 48),
    shape: const StadiumBorder(),
  );
}

ButtonStyle outlinedButtonStyle() {
  return OutlinedButton.styleFrom(
    foregroundColor: const Color(0xFF00BF6D),
    minimumSize: const Size(double.infinity, 48),
    side: const BorderSide(color: Color(0xFF00BF6D), width: 2),
    shape: const StadiumBorder(),
  );
}
