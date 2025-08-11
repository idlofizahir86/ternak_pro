import 'package:flutter/material.dart';

import '../theme.dart';
import 'custom_image_view.dart';


class FeaturedServiceCardWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final LinearGradient gradient;
  final VoidCallback? onTap;

  const FeaturedServiceCardWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(8),
          // border: Border.all(color: AppColors.grey2, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomImageView(
                  imagePath: iconPath,
                  height: 36,
                  width: 36,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.medium
                        .copyWith(color: AppColors.primaryWhite, height: 18/14, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyle.medium
                        .copyWith(color: AppColors.white50, height: 12/10, fontSize: 10),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            CustomImageView(
              imagePath: 'assets/home_assets/icons/ic_arrow.svg',
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }
}
