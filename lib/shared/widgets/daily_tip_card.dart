import 'package:flutter/material.dart';
import 'package:ternak_pro/shared/theme.dart';

import 'custom_image_view.dart';

class DailyTipCardWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String author;
  final VoidCallback? ontTap;

  const DailyTipCardWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.author, 
    this.ontTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontTap,
      child: Container(
        width: 176,
        margin: EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageView(
              imagePath: imagePath,
              height: 80,
              width: 176,
              fit: BoxFit.cover,
              radius: BorderRadius.circular(8),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyle.semiBold.copyWith(
                fontSize: 10,
                height: 12/10,
                color: AppColors.black100,),
              textAlign: TextAlign.justify,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              author,
              style: AppTextStyle.regular.copyWith(
                color: AppColors.grey2,
                fontSize: 10,
                height: 12/8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
