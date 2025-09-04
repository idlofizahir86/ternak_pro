import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ternak_pro/cubit/tab_ternak_cubit.dart';
import 'package:ternak_pro/models/TernakItem.dart';
import 'package:ternak_pro/shared/theme.dart';

import '../../models/DailyTaskItem.dart';
import '../../services/api_service.dart';
import '../../shared/custom_loading.dart';
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
  final ApiService _apiService = ApiService();

  late Future<List<Map<String, dynamic>>> _ternakListFuture;
  late Future<List<Map<String, dynamic>>> _tugasListFuture;

  Future<List<Map<String, dynamic>>> fetchTernakList() async {
    final credential = await _apiService.loadCredentials();
    final userId = credential['user_id'];

    try {
      // Mapping data ternak yang sudah diambil ke dalam DailyTaskItem
      List<Ternakitem> ternakListData = await _apiService.getTernakUserAll(userId);

      List<Map<String, dynamic>> ternakListDataFinal = ternakListData.map((ternak) => ternak.toJson()).toList();

      // Menunggu 3 detik sebelum mematikan _isLoadingTasks
      await Future.delayed(const Duration(seconds: 3));

      return ternakListDataFinal;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchTugasList() async {
    final credential = await _apiService.loadCredentials();
    final userId = credential['user_id'];

    try {
      // Mapping data tugas yang sudah diambil ke dalam DailyTaskItem
      List<DailyTaskItem> tugasListData = await _apiService.getTugasUserAll(userId);

      List<Map<String, dynamic>> tugasListDataFinal = tugasListData.map((task) => task.toJson()).toList();

      // Menunggu 3 detik sebelum mematikan _isLoadingTasks
      await Future.delayed(const Duration(seconds: 3));

      return tugasListDataFinal;
    } catch (e) {
      rethrow;
    }
  }



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _ternakListFuture = fetchTernakList();
    _tugasListFuture = fetchTugasList();
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
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _ternakListFuture, // gunakan future dari state
                        builder: (context, snapshot) {
                          // Loading state
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: TernakProBoxLoading());
                          }

                          // Error handling
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  Text('Error: ${snapshot.error}'),
                                  Text('Error details: ${snapshot.error}'),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _ternakListFuture = fetchTernakList();
                                      });
                                    },
                                    child: Text('Coba lagi'),
                                  ),
                                ],
                              ),
                            );
                          }

                          // No data handling
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('Tidak ada tugas saat ini.'));
                          }

                          // Once data is ready, pass it to the TugasList widget
                          return DataTernakList(snapshot.data!, onRefresh: () {
                            setState(() {
                              _ternakListFuture = fetchTernakList();
                            });
                          },);
                        },
                      ),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _tugasListFuture, // gunakan future dari state
                        builder: (context, snapshot) {
                          // Loading state
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: TernakProBoxLoading());
                          }

                          // Error handling
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                children: [
                                  Text('Error: ${snapshot.error}'),
                                  Text('Error details: ${snapshot.error}'),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _tugasListFuture = fetchTugasList();
                                      });
                                    },
                                    child: Text('Coba lagi'),
                                  ),
                                ],
                              ),
                            );
                          }

                          // No data handling
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('Tidak ada tugas saat ini.'));
                          }

                          // Once data is ready, pass it to the TugasList widget
                          return TugasList(snapshot.data!);
                        },
                      ),
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
  final List<Map<String, dynamic>> tugasList;

  const TugasList(this.tugasList, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tugasList.length,
      itemBuilder: (context, index) {
        final task = tugasList[index];
        return CustomTugasItem(
          title: task['nama_tugas'] ?? 'No Title',
          status: task['status_tugas'] ?? 'No Status',
          time: task['waktu_tugas'] ?? 'No Time',
          catatan: task['catatan'] ?? 'No Catatan',
          iconPath: task['icon_path'] ?? 'assets/home_assets/icons/ic_default.png',
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
