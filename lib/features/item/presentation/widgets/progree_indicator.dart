import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // ✅ CENTER ENTIRE BAR
      children: List.generate(totalSteps, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber <= currentStep;

        return Row(
          children: [
            // Circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isActive ? Colors.teal : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                "$stepNumber",
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Line (except last)
            if (stepNumber != totalSteps)
              Container(
                width: 40, // 👈 controls spacing between steps
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: isActive ? Colors.teal : Colors.grey.shade300,
              ),
          ],
        );
      }),
    );
  }
}
