import 'package:flutter/material.dart';

import '../../theme.dart';

class HubungiButton extends StatelessWidget {
  final String text;
  final VoidCallback? onClick;
  final bool isActive;
  final double? height;
  final double? width;

  const HubungiButton({
    super.key,
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
        double verticalPadding = (maxWidth * 0.025).clamp(6.0, 14.0);
        double fontSize = (maxWidth * 0.045).clamp(12.0, 16.0);

        BoxDecoration decoration;
        TextStyle textStyle;

        decoration = BoxDecoration(
          color: disabledColor,
          borderRadius: BorderRadius.circular(10),
        );
        textStyle = AppTextStyle.medium.copyWith(
          color: disabledTextColor,
          fontSize: fontSize,
        );
        decoration = BoxDecoration(
          gradient: AppColors.gradasi01,
          borderRadius: BorderRadius.circular(10),
        );
        textStyle = AppTextStyle.medium.copyWith(
          color: AppColors.white100,
          fontSize: fontSize,
        );

        return GestureDetector(
          onTap: isActive ? onClick : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 35, // maksimal tinggi tombol
            ),
            child: Container(
              width: width ?? double.infinity,
              padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
              ),
              decoration: decoration,
              child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/supplier_pakan_assets/icons/ic_message.png',
                height: fontSize + 8, // icon size relative to font
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
              ),
            ),
          ),
        );
      },
    );
  }
}
