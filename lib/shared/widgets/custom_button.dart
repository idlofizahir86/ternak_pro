import 'package:flutter/material.dart';

import '../theme.dart';
import './custom_image_view.dart';

/// CustomButton - A flexible button component that supports multiple variants
/// 
/// @param iconPath - Path to the icon image (SVG, PNG, or network URL)
/// @param text - Optional text to display below the icon
/// @param onTap - Callback function when button is tapped
/// @param backgroundColor - Background color of the button
/// @param iconSize - Size of the icon
/// @param buttonSize - Overall size of the button
/// @param borderRadius - Border radius for rounded corners
/// @param elevation - Shadow elevation for the button
/// @param textColor - Color of the text label
/// @param isCircular - Whether the button should be circular
/// @param padding - Internal padding of the button
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.iconPath,
    this.text,
    this.onTap,
    this.backgroundColor,
    this.iconSize,
    this.buttonSize,
    this.borderRadius,
    this.elevation,
    this.textColor,
    this.isCircular,
    this.padding,
  });

  /// Path to the icon image (SVG, PNG, or network URL)
  final String iconPath;

  /// Optional text to display below the icon
  final String? text;

  /// Callback function when button is tapped
  final VoidCallback? onTap;

  /// Background color of the button
  final Color? backgroundColor;

  /// Size of the icon
  final double? iconSize;

  /// Overall size of the button (width and height)
  final double? buttonSize;

  /// Border radius for rounded corners
  final double? borderRadius;

  /// Shadow elevation for the button
  final double? elevation;

  /// Color of the text label
  final Color? textColor;

  /// Whether the button should be circular
  final bool? isCircular;

  /// Internal padding of the button
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final bool hasText = text != null && text!.isNotEmpty;
    final bool isCircularButton = isCircular ?? false;
    final double finalButtonSize = buttonSize ?? (hasText ? 56 : 36);
    final double finalIconSize = iconSize ?? (hasText ? 28 : 24);
    final Color finalBackgroundColor =
        backgroundColor ?? AppColors.transparent;
    final double finalElevation =
        elevation ?? (backgroundColor != null ? 2.0 : 0.0);
    final double finalBorderRadius =
        borderRadius ?? (isCircularButton ? finalButtonSize / 2 : 16);
    final EdgeInsets finalPadding = padding ?? EdgeInsets.all(8);
    final Color finalTextColor = textColor ?? AppColors.grey2;

    if (hasText) {
      return _buildButtonWithText(
        finalIconSize,
        finalTextColor,
        finalBackgroundColor,
        finalElevation,
        finalBorderRadius,
        finalPadding,
      );
    } else {
      return _buildIconOnlyButton(
        finalButtonSize,
        finalIconSize,
        finalBackgroundColor,
        finalElevation,
        finalBorderRadius,
        finalPadding,
        isCircularButton,
      );
    }
  }

  Widget _buildIconOnlyButton(
    double size,
    double iconSize,
    Color backgroundColor,
    double elevation,
    double borderRadius,
    EdgeInsets padding,
    bool isCircular,
  ) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: size,
          height: size,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: CustomImageView(
            imagePath: iconPath,
            height: iconSize,
            width: iconSize,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWithText(
    double iconSize,
    Color textColor,
    Color backgroundColor,
    double elevation,
    double borderRadius,
    EdgeInsets padding,
  ) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: iconPath,
                height: iconSize,
                width: iconSize,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 4),
              Text(
                text!,
                style: AppTextStyle.medium.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
