import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../cubit/page_cubit.dart';
import '../theme.dart';

class CustomBottomNavigationItem extends StatelessWidget {
  final int index;
  final String menuName;

  const CustomBottomNavigationItem({
    required this.index,
    super.key,
    required this.menuName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PageCubit>().setPage(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Image.asset(
            context.read<PageCubit>().state == index
                ? "assets/icons/menu/ic_menu_${menuName}_selected.png"
                : "assets/icons/menu/ic_menu_${menuName}_unselected.png",
            height: 40,
            width: 40,
          ),
          Container(
            width: 35,
            height: 2,
            decoration: BoxDecoration(
              color: context.read<PageCubit>().state == index
                  ? AppColors.bgLight
                  : AppColors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ],
      ),
    );
  }
}
