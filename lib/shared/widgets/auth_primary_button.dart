import 'package:flutter/material.dart';
import '../theme.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? fontSize;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: color ?? AppColors.primaryYellow,
        ),
        child: Text(
          text,
          style: AppTextStyle.semiBold.copyWith(
            fontSize: fontSize ?? 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}