import 'package:flutter/material.dart';
import 'package:coaching_ai_new/core/utils/form_decorators.dart';

class SearchConversationsInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchConversationsInput({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: inputDecoration('Search conversations...').copyWith(
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}
