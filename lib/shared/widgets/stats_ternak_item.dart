
import 'package:flutter/material.dart';

import '../theme.dart';
import 'custom_image_view.dart';

class StatsTernakItem extends StatelessWidget {

  final String title;
  final String keterangan;
  final String imagePath;

  const StatsTernakItem({
    super.key,
    required this.title,
    required this.keterangan,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 72,
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.white100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: imagePath,
                  height: 40,
                  width: 40,
                ),
                SizedBox(height: 2),
                Text(
                      keterangan,
                      style: AppTextStyle.extraBold.copyWith(
                        fontSize: 14,
                        color: AppColors.blackText,
                      ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 6),
          FittedBox(
  fit: BoxFit.scaleDown,
  child: Text(
            title,
            style: AppTextStyle.medium.copyWith(
              fontSize: 12,
              color: AppColors.blackText,
            ),
          
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.center,
  ),
),
          
        ],
      ),
    );
  }
}
