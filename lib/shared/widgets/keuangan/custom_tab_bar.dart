import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ternak_pro/cubit/tab_keuangan_cubit.dart';

import '../../theme.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final Function(int) onSwipe;

  const CustomTabBar({super.key, required this.controller, required this.onSwipe});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabKeuanganCubit, int>(
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
            context.read<TabKeuanganCubit>().setKeuanganTab(index);
          },
          tabs: [
            _buildTab(
              'Pendapatan',
              'assets/keuangan_assets/icons/ic_down.png',
              'assets/keuangan_assets/icons/ic_down_active.png',
              0,
              selectedIndex,
            ),
            _buildTab(
              'Pengeluaran',
              'assets/keuangan_assets/icons/ic_up.png',
              'assets/keuangan_assets/icons/ic_up_active.png',
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
    int index,
    int selectedIndex,
  ) {
    final bool isSelected = selectedIndex == index;

    Color activeColorForIndex(int i) {
      if (i == 0) return AppColors.blue02;
      if (i == 1) return AppColors.red600;
      return AppColors.blue02; // default untuk index lain
    }

    final Color textColor = isSelected ? activeColorForIndex(index) : AppColors.black01;
    final Color underlineColor = isSelected ? activeColorForIndex(index) : AppColors.transparent;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isSelected ? iconActivePath : iconPath,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            height: 2,
            color: underlineColor,
          ),
        ],
      ),
    );
  }

}