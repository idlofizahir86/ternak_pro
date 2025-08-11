import 'package:flutter/material.dart';

import '../theme.dart';

class ProfileSettingItem extends StatelessWidget {
  final String imageUrl;
  final String menuName;
  final Color bgImage;
  final String placeHolder;
  final VoidCallback onTap;

  const ProfileSettingItem({
    super.key, required this.imageUrl, required this.menuName, required this.placeHolder, required this.onTap, required this.bgImage,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 5),
        margin: EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: bgImage,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset(imageUrl),
                ),
                SizedBox(width: 8),
                Text(menuName,
                  style: AppTextStyle.semiBold.copyWith(
                    fontSize: 14,
                    color: AppColors.blackText,
                  ),
                ),
                Spacer(),
                Text(placeHolder,
                  style: AppTextStyle.medium.copyWith(
                    fontSize: 14,
                    color: AppColors.grey2,
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 14,
                  height: 14,
                  child: Image.asset('assets/profile_assets/icons/ic_arrow_go.png'),
                ),
              ],
            ),
            // SizedBox(height: 1),
            Divider(
              color: AppColors.grey20,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}