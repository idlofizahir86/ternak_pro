import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/tab_ternak_cubit.dart';
import '../../theme.dart';

class CustomAppBar extends PreferredSize {
  CustomAppBar({super.key}) : super(child: AppBar(), preferredSize: Size.fromHeight(60));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabTernakCubit, int>(
      builder: (context, tabIndex) {
        String title = tabIndex == 0 ? 'Data Ternak' : 'Data Tugas';
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
            onPressed: () {
              Navigator.pushNamed(context, '/main');
            },
          ),
        );
      },
    );
  }
}
