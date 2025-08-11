
import 'package:flutter/material.dart';

import '../theme.dart';

class LoginAppTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool error;
  final TextInputType? keyboardType;
  final void Function(bool)? onFocusChange;

  const LoginAppTextfield({
    super.key,
    required this.controller,
    this.focusNode,
    required this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.error = false,
    this.keyboardType,
    this.onFocusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: onFocusChange,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: AppTextStyle.regular.copyWith(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xFFF8F8F8),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: error ? AppColors.primaryRed : Colors.transparent,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: error ? AppColors.primaryRed : AppColors.primaryBlue,
              width: 2,
            ),
          ),
        ),
        style: AppTextStyle.regular.copyWith(
          fontSize: 14,
          color: AppColors.black100,
        ),
      ),
    );
  }
}