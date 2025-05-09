import 'package:flutter/material.dart';

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF5FCF9),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
    border: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );
}
