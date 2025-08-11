import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ternak_pro/cubit/tab_ternak_cubit.dart';
import 'package:ternak_pro/shared/theme.dart';

import '../../shared/widgets/data_ternak/custom_app_bar.dart';
import '../../shared/widgets/data_ternak/custom_tab_bar.dart';
import '../../shared/widgets/data_ternak/data_ternak_list.dart';
import '../../shared/widgets/data_ternak/data_tugas_list.dart';
import '../../shared/widgets/onboarding_buttom.dart';

class ListDataTernakTugasPage extends StatefulWidget {
  const ListDataTernakTugasPage({super.key});

  @override
  ListDataTernakTugasPageState createState() => ListDataTernakTugasPageState();
}

class ListDataTernakTugasPageState extends State<ListDataTernakTugasPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Data ternak dan tugas
  final List<Map<String, String>> ternakList = [
    {'id': '001', 'jenis': 'Jantan', 'berat': '70', 'status': 'Sehat'},
    {'id': '002', 'jenis': 'Betina', 'berat': '70', 'status': 'Sehat'},
    {'id': '003', 'jenis': 'Jantan', 'berat': '70', 'status': 'Sehat'},
    {'id': '004', 'jenis': 'Betina', 'berat': '70', 'status': 'Sehat'},
    {'id': '005', 'jenis': 'Jantan', 'berat': '70', 'status': 'Sehat'},
    {'id': '006', 'jenis': 'Jantan', 'berat': '70', 'status': 'Sehat'},
    {'id': '007', 'jenis': 'Jantan', 'berat': '50', 'status': 'Sehat'},
    {'id': '012', 'jenis': 'Betina', 'berat': '70', 'status': 'Sehat'},
    {'id': '023', 'jenis': 'Betina', 'berat': '70', 'status': 'Sehat'},
    {'id': '007', 'jenis': 'Jantan', 'berat': '70', 'status': 'Sehat'},
    {'id': '012', 'jenis': 'Betina', 'berat': '120', 'status': 'Sakit'},
    {'id': '023', 'jenis': 'Betina', 'berat': '70', 'status': 'Sehat'},
    {'id': '007', 'jenis': 'Jantan', 'berat': '70', 'status': 'Sehat'},
    {'id': '012', 'jenis': 'Betina', 'berat': '70', 'status': 'Sehat'},
    {'id': '023', 'jenis': 'Betina', 'berat': '70', 'status': 'Sehat'},
  ];

  final List<Map<String, String>> tugasList = [
    {'title': 'Pemberian Pakan & Air', 'status': 'Sudah', 'time': '07:00 AM', 'iconPath': 'assets/home_assets/icons/ic_snack.png'},
    {'title': 'Vaksin Ternak', 'status': 'Tertunda', 'time': '07:00 AM', 'iconPath': 'assets/home_assets/icons/ic_shield.png'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ambil argumen; fallback ke 0 kalau null / tipe tidak sesuai
    final args = ModalRoute.of(context)?.settings.arguments;
    final int initialIndex = switch (args) {
      final Map m when m['initialIndex'] is int => m['initialIndex'] as int,
      _ => 0,
    };


    return BlocProvider(
      create: (_) => TabTernakCubit(initialIndex),
      child: BlocConsumer<TabTernakCubit, int>(
        listener: (context, selectedIndex) {
          if (_tabController.index != selectedIndex) {
            _tabController.animateTo(selectedIndex);
          }
        },
        builder: (context, selectedIndex) {
          return Scaffold(
            backgroundColor: AppColors.bgLight,
            appBar: CustomAppBar(),
            body: Column(
              children: [
                CustomTabBar(
                  controller: _tabController,
                  onSwipe: (index) {
                    context.read<TabTernakCubit>().setTab(index);
                  },
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      DataTernakList(ternakList),
                      TugasList(tugasList),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomActionButton(
              activePage: selectedIndex == 0 ? 'ternak' : 'tugas',
            ),
          );
        },
      ),
    );
  }
}


class TugasList extends StatelessWidget {
  final List<Map<String, String>> tugasList;

  const TugasList(this.tugasList, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tugasList.length,
      itemBuilder: (context, index) {
        return CustomTugasItem(
          title: tugasList[index]['title']!,
          status: tugasList[index]['status']!,
          time: tugasList[index]['time']!,
          iconPath: tugasList[index]['iconPath']!,
        );
      },
    );
  }
}

class BottomActionButton extends StatelessWidget {
  final String activePage;

  const BottomActionButton({super.key, required this.activePage});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ClipRect(
        child: Opacity(
          opacity: 1.0, // You can adjust this value for transparency, 1.0 = no transparency
          child: OnboardingButton(
            previous: false,
            text: "Tambahkan",
            width: double.infinity,
            height: 30,
            onClick: () => Navigator.pushNamed(context, "/tambah-data-$activePage"),
            
          ),
        ),
      ),
    );
  }
}
