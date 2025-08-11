import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/tab_ternak_cubit.dart';
import '../../theme.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final Function(int) onSwipe;

  const CustomTabBar({super.key, required this.controller, required this.onSwipe});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabTernakCubit, int>(
      builder: (context, selectedIndex) {
        // Sinkronkan TabController dengan Cubit
        if (controller.index != selectedIndex) {
          controller.animateTo(selectedIndex);
        }

        return TabBar(
          controller: controller,
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          onTap: (index) {
            context.read<TabTernakCubit>().setTab(index);
          },
          tabs: [
            _buildTab(
              'Ternak',
              'assets/data_ternak_assets/icons/ic_ternak.png',
              'assets/data_ternak_assets/icons/ic_ternak_active.png',
              7,
              0,
              selectedIndex,
            ),
            _buildTab(
              'Tugas',
              'assets/data_ternak_assets/icons/ic_tugas.png',
              'assets/data_ternak_assets/icons/ic_tugas_active.png',
              2,
              1,
              selectedIndex,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTab(
    String label,
    String iconPath,
    String iconActivePath,
    int nData,
    int index,
    int selectedIndex,
  ) {
    bool isSelected = selectedIndex == index;

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isSelected ? iconActivePath : iconPath,
                width: 20,
                height: 20,
              ),
              SizedBox(width: 5),
              Text(
                "$label ($nData)",
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? AppColors.green01 : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
            height: 2,
            color: isSelected ? AppColors.green01 : AppColors.transparent,
          ),
        ],
      ),
    );
  }
}