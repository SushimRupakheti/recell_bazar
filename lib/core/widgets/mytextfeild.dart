import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    required this.validator,
    required this.onChanged,
    required this.isFocused,
    this.controller,
  });

  final String label;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?) validator;
  final void Function(String) onChanged;
  final bool isFocused;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: isFocused?null:prefixIcon != null ? Icon(prefixIcon) : null,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
