import 'package:flutter/material.dart';

import '../../theme.dart';
import '../custom_image_view.dart';
import 'show_tugas_edit_modal.dart';

class CustomTugasItem extends StatelessWidget {
  final String title;
  final String status;
  final String time;
  final String iconPath;

  const CustomTugasItem({super.key, 
    required this.title,
    required this.status,
    required this.time,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showTugasEditModal(
          context,
          title: title,
          status: status,
          time: time,
          iconPath: iconPath,
          onSave: ({required String status, required String time, required String note}) {
            // TODO: simpan ke state/BLoC/API sesuai kebutuhanmu
            // contoh:
            // context.read<TugasCubit>().updateTugas(title, status, time, note);
            debugPrint('SAVE -> status:$status  time:$time  note:$note  title:$title');
          },
        );
      },
      child: Container(
      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.gradasi01WithOpacity20,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomImageView(
                    imagePath: iconPath,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.semiBold.copyWith(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset(
                        status == 'Sudah' 
                            ? 'assets/home_assets/icons/ic_check_green.png' 
                            : 'assets/home_assets/icons/ic_check_yellow.png',
                        width: 12,
                        height: 12, 
                      ),
                      SizedBox(width: 4),
                      Text(
                        status,
                        style: AppTextStyle.semiBold.copyWith(
                          fontSize: 12,
                          color: 
                          status == 'Tertunda' 
                          ? AppColors.yellow500 
                          : (status == 'Belum' 
                              ? AppColors.primaryRed 
                              : (status == 'Sudah' 
                                  ? AppColors.green01 
                                  : AppColors.primaryRed)),
                              // Gunakan warna default jika status tidak cocok
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: (){},
                        child: Image.asset('assets/home_assets/icons/ic_dropdown.png', 
                          width: 14, 
                          height: 14,
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
                status == 'Sudah' 
                    ? 'assets/home_assets/icons/ic_clock_green.png' 
                    : 'assets/home_assets/icons/ic_clock_red.png',
                width: 12,
                height: 12, 
              ),
              SizedBox(width: 4),
              Text(
                time,
                style: AppTextStyle.medium.copyWith(
                  fontSize: 12,
                  color: (status == 'Tertunda' || status == 'Belum') 
                      ? AppColors.primaryRed 
                      : (status == 'Sudah' 
                          ? AppColors.green01 
                          : AppColors.primaryRed), // Gunakan warna default jika status tidak cocok
                ),
              ),
              // SizedBox(width: 2),
              Image.asset('assets/home_assets/icons/ic_more.png' ,
                width: 18,
                height: 18, 
              ),
            ],
          ),
        ],
      ),
        ),
    );
  }
}
