import 'package:flutter/material.dart';
import '../../theme.dart';

class CustomAppBar extends PreferredSize {
  final String title;
  CustomAppBar(this.title, {super.key}) : super(child: AppBar(), preferredSize: Size.fromHeight(60));

  @override
  Widget build(BuildContext context) {
      return AppBar(
            backgroundColor: Colors.white,
            title: Text(
              title,
              style: AppTextStyle.medium.copyWith(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.green01),
              onPressed: () => Navigator.of(context).pop(),
            ),
          );
  }
}
