// Widget slider indikator onboarding
import 'package:flutter/material.dart';

import '../theme.dart';

class OnboardingSliderIndicator extends StatelessWidget {
  final int total;
  final int current;

  const OnboardingSliderIndicator({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        if (index == current) {
          return Container(
            width: 40,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: AppColors.gradasi01,
            ),
          );
        } else {
          return Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
          );
        }
      }),
    );
  }
}