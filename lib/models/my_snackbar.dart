import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontFamily: "Montserrat-Regular"),
      ),
      backgroundColor: isError ? Colors.red : const Color(0xFF0B7C7C),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}
