import 'package:flutter/material.dart';

class QuestionDesignWidget extends StatelessWidget {
  final String question;
  final Widget child;

  const QuestionDesignWidget({
    super.key,
    required this.question,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        child,
        const SizedBox(height: 16),
      ],
    );
  }
}
