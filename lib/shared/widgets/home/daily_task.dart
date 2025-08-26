import 'package:flutter/material.dart';

import '../../../models/DailyTaskItem.dart';
import '../../custom_loading.dart';
import '../../theme.dart';
import '../custom_image_view.dart';
import '../data_ternak/show_tugas_edit_modal.dart';
import '../onboarding_buttom.dart';



Widget buildDailyTasks(BuildContext context, List<DailyTaskItem>? tasks, bool isLoading) {
  return Container(
    margin: EdgeInsets.only(left: 24, right: 24, top: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tugas Hari Ini',
              style: AppTextStyle.semiBold.copyWith(fontSize: 16),
            ),
            GestureDetector(
              onTap: () {
                 Navigator.pushNamed(
                  context,
                  '/list-data-ternak-tugas',
                  arguments: {'initialIndex': 1},
                );
              },
              child: Row(
                children: [
                  Text(
                    'Lihat Semua',
                    style: AppTextStyle.semiBold.copyWith(
                      color: AppColors.green01,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (isLoading) 
          Center(child: TernakProBoxLoading()),
        if (tasks == null || tasks.isEmpty && !isLoading)
          SizedBox(height: 8),
        if (tasks == null || tasks.isEmpty && !isLoading)
          Container(
            padding: EdgeInsets.all(32),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.green02,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomImageView(
                      imagePath: "assets/home_assets/icons/ic_task.png",
                      height: 36,
                      width: 36,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Belum Ada Tugas',
                  style: AppTextStyle.semiBold.copyWith(
                    color: AppColors.blackText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        else
          ...tasks.map((task) => buildTaskItem(context, task)),
        SizedBox(height: 16),
        // GestureDetector(
        //   onTap: () {
        //     Navigator.pushNamed(context, '/tambah-data-tugas');
        //   },
        //   child: Container(
        //     width: double.infinity,
        //     padding: EdgeInsets.all(12),
        //     decoration: BoxDecoration(
        //       gradient: AppColors.gradasi01WithOpacity20,
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         CustomImageView(
        //             imagePath: "assets/home_assets/icons/ic_plus.png",
        //             height: 20,
        //             width: 20,
        //           ),
        //           SizedBox(width: 4),
        //           Text(
        //             'Tambah Tugas',
        //             style: AppTextStyle.semiBold.copyWith(
        //               color: AppColors.black100,
        //               fontSize: 12,
        //             ),
        //           ),
        //       ],
        //     ),
        //   ),
        // ),
        OnboardingButton(
          previous: false,
          text: "+ Tambah Tugas",
          width: double.infinity,
          onClick: () => Navigator.pushNamed(context, '/tambah-data-tugas'),
        ),
      ],
    ),
  );
}


Widget buildTaskItem(BuildContext context, DailyTaskItem task) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double maxWidth = constraints.maxWidth;
      double iconSize = (maxWidth * 0.07).clamp(24.0, 36.0); // Responsif untuk ukuran ikon
      double fontSizeSmall = (maxWidth * 0.04).clamp(12.0, 14.0); // Responsif untuk font

      return Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradasi01WithOpacity20,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomImageView(
                      imagePath: task.iconPath,
                      height: iconSize * 0.8,
                      width: iconSize * 0.8,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppTextStyle.semiBold.copyWith(fontSize: fontSizeSmall),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Image.asset(
                          task.status == 'Sudah' 
                              ? 'assets/home_assets/icons/ic_check_green.png' 
                              : 'assets/home_assets/icons/ic_check_yellow.png',
                          width: 12,
                          height: 12, 
                        ),
                        SizedBox(width: 4),
                        Text(
                          task.status,
                          style: AppTextStyle.semiBold.copyWith(
                            fontSize: fontSizeSmall,
                            color: task.status == 'Tertunda' 
                                ? AppColors.yellow500 
                                : (task.status == 'Belum' 
                                    ? AppColors.primaryRed 
                                    : (task.status == 'Sudah' 
                                        ? AppColors.green01 
                                        : AppColors.primaryRed)),
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            showTugasEditModal(
                            context,
                            title: task.title,
                            status: task.status,
                            time: task.time,
                            catatan: task.catatan,
                            iconPath: task.iconPath,
                            onSave: ({required String status, required String time, required String catatan}) {
                              // TODO: simpan ke state/BLoC/API sesuai kebutuhanmu
                              // contoh:
                              // context.read<TugasCubit>().updateTugas(title, status, time, catatan);
                              // debugPrint('SAVE -> status:$status  time:$time  catatan:$catatan  title:$task.title');
                            },
                          );
                          },
                          child: Image.asset('assets/home_assets/icons/ic_dropdown.png', 
                            width: 14, height: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  task.status == 'Sudah' 
                      ? 'assets/home_assets/icons/ic_clock_green.png' 
                      : 'assets/home_assets/icons/ic_clock_red.png',
                  width: 12,
                  height: 12, 
                ),
                SizedBox(width: 4),
                Text(
                  task.time,
                  style: AppTextStyle.medium.copyWith(
                    fontSize: fontSizeSmall,
                    color: (task.status == 'Tertunda' || task.status == 'Belum') 
                        ? AppColors.primaryRed 
                        : (task.status == 'Sudah' 
                            ? AppColors.green01 
                            : AppColors.primaryRed),
                  ),
                ),
                Image.asset('assets/home_assets/icons/ic_more.png' ,
                  width: 18,
                  height: 18, 
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
