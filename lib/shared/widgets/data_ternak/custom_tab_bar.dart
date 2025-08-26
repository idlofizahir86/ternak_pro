import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/tab_ternak_cubit.dart';
import '../../../services/api_service.dart';
import '../../theme.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final Function(int) onSwipe;

  CustomTabBar({super.key, required this.controller, required this.onSwipe});

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
            // Menggunakan FutureBuilder untuk mendapatkan jumlah ternak
            FutureBuilder<int>(
              future: _getTernakUserCount(), // Memanggil fungsi untuk mendapatkan jumlah ternak
              builder: (context, snapshot) {
                int nData = 0;
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    nData = snapshot.data!;
                  } else if (snapshot.hasError) {
                    return _buildTab('Ternak', 'assets/data_ternak_assets/icons/ic_ternak.png', 'assets/data_ternak_assets/icons/ic_ternak_active.png', 0, 0, selectedIndex);
                  }
                }

                return _buildTab(
                  'Ternak',
                  'assets/data_ternak_assets/icons/ic_ternak.png',
                  'assets/data_ternak_assets/icons/ic_ternak_active.png',
                  nData,
                  0,
                  selectedIndex,
                );
              },
            ),
            FutureBuilder<int>(
              future: _getTugasUserCount(), // Memanggil fungsi untuk mendapatkan jumlah tugas
              builder: (context, snapshot) {
                int nData = 0;
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    nData = snapshot.data!;
                  } else if (snapshot.hasError) {
                    return _buildTab('Ternak', 'assets/data_ternak_assets/icons/ic_ternak.png', 'assets/data_ternak_assets/icons/ic_ternak_active.png', 0, 0, selectedIndex);
                  }
                }

                return _buildTab(
                  'Tugas',
                  'assets/data_ternak_assets/icons/ic_tugas.png',
                  'assets/data_ternak_assets/icons/ic_tugas_active.png',
                  nData,
                  1,
                  selectedIndex,
                );
              },
            ),
            
          ],
        );
      },
    );
  }


  final ApiService _apiService = ApiService(); // Initialize your ApiService
  
   // Fungsi untuk mendapatkan jumlah ternak
  Future<int> _getTernakUserCount() async {
    final credential = await _apiService.loadCredentials();
    final userId = credential['user_id'];

    try {
      final count = await _apiService.getTernakUserCount(userId);  // Panggil fungsi getTernakUserCount untuk mendapatkan jumlah data ternak
      return count;  // Mengembalikan jumlah data ternak
    } catch (e) {
      return 0;  // Mengembalikan 0 jika gagal
    }
  }
  
   // Fungsi untuk mendapatkan jumlah tugas
  Future<int> _getTugasUserCount() async {
    final credential = await _apiService.loadCredentials();
    final userId = credential['user_id'];

    try {
      final count = await _apiService.getTugasUserCount(userId);  // Panggil fungsi getTugasUserCount untuk mendapatkan jumlah data tugas
      return count;  // Mengembalikan jumlah data tugas
    } catch (e) {
      return 0;  // Mengembalikan 0 jika gagal
    }
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