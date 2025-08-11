import 'package:flutter/material.dart';
import '../theme.dart';

class OnboardingButton extends StatelessWidget {
  final bool previous;
  final String text;
  final VoidCallback? onClick;
  final bool isActive;
  final double? height;
  final double? width;

  const OnboardingButton({
    super.key,
    required this.previous,
    required this.text,
    this.onClick,
    this.height,
    this.isActive = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color disabledColor = Colors.grey.shade300;
    Color disabledTextColor = Colors.grey.shade500;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Gunakan lebar yang tersedia di LayoutBuilder
        double maxWidth = constraints.maxWidth;

        // Responsif: padding horizontal dan fontSize berdasarkan maxWidth
        double horizontalPadding = (maxWidth * 0.08).clamp(16.0, 46.0);
        double verticalPadding = (maxWidth * 0.035).clamp(10.0, 18.0);
        double fontSize = (maxWidth * 0.045).clamp(12.0, 16.0);

        BoxDecoration decoration;
        TextStyle textStyle;

        if (!isActive) {
          decoration = BoxDecoration(
            color: disabledColor,
            borderRadius: BorderRadius.circular(10),
          );
          textStyle = AppTextStyle.medium.copyWith(
            color: disabledTextColor,
            fontSize: fontSize,
          );
        } else if (previous) {
          decoration = BoxDecoration(
            color: AppColors.transparent,
            border: Border.all(color: AppColors.green01),
            borderRadius: BorderRadius.circular(10),
          );
          textStyle = AppTextStyle.medium.copyWith(
            color: AppColors.green01,
            fontSize: fontSize,
          );
        } else {
          decoration = BoxDecoration(
            gradient: AppColors.gradasi01,
            borderRadius: BorderRadius.circular(10),
          );
          textStyle = AppTextStyle.medium.copyWith(
            color: AppColors.white100,
            fontSize: fontSize,
          );
        }

        return GestureDetector(
          onTap: isActive ? onClick : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 50, // maksimal tinggi tombol
            ),
            child: Container(
              width: width ?? double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: decoration,
              child: Center(
                child: Text(
                  text,
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
