import 'package:flutter/material.dart';

import '../../theme.dart';
import '../onboarding_buttom.dart';
import 'custom_drop_down_sehat.dart';
import 'custom_weight_field.dart';

class DataTernakList extends StatelessWidget {
  final List<Map<String, String>> ternakList;

  const DataTernakList(this.ternakList, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ternakList.length,
      itemBuilder: (context, index) {
        return CustomTernakItem(
          id: ternakList[index]['id']!,
          jenis: ternakList[index]['jenis']!,
          berat: ternakList[index]['berat']!,
          status: ternakList[index]['status']!,
        );
      },
    );
  }
}


class CustomTernakItem extends StatelessWidget {
  final String id;
  final String jenis;
  final String berat;
  final String status;

  const CustomTernakItem({super.key, 
    required this.id,
    required this.jenis,
    required this.berat,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              // Panggil fungsi untuk membuka modal saat item ditekan
              showDataTernakDialog(context, id, jenis, berat, status);
            },
            child: Image.asset('assets/data_ternak_assets/icons/ic_cow_hd.png', width: 50, height: 50)),
          InkWell(
            onTap: () {
              // Panggil fungsi untuk membuka modal saat item ditekan
              showDataTernakDialog(context, id, jenis, berat, status);
            },
            child: Text(id, style: AppTextStyle.extraBold.copyWith(fontSize: 14, color: Colors.black))),
          InkWell(
            onTap: () {
              // Panggil fungsi untuk membuka modal saat item ditekan
              showDataTernakDialog(context, id, jenis, berat, status);
            },
            child: Text(
              jenis,
              style: AppTextStyle.semiBold.copyWith(
                fontSize: 14,
                color: (jenis == 'Jantan') ? AppColors.green01 : AppColors.purple,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // Panggil fungsi untuk membuka modal saat item ditekan
              showDataTernakDialog(context, id, jenis, berat, status);
            },
            child: Text(
              "$berat Kg",
              style: AppTextStyle.semiBold.copyWith(
                fontSize: 14,
                color: AppColors.blue01,
              ),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                },
                child: Image.asset(status == 'Sehat' ? 'assets/home_assets/icons/ic_check_green.png' : 'assets/home_assets/icons/ic_check_yellow.png', width: 14, height: 14)),
              SizedBox(width: 4),
              InkWell(
                onTap: () {
                },
                child: Text(
                  status,
                  style: AppTextStyle.semiBold.copyWith(
                    fontSize: 14,
                    color: status == 'Sehat'
                        ? AppColors.green01
                        : (status == 'Sakit' ? AppColors.primaryRed : AppColors.yellow500),
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {
                },
                child: Image.asset('assets/home_assets/icons/ic_dropdown.png', width: 14, height: 14)
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {
                },
                child: Image.asset('assets/home_assets/icons/ic_more.png', width: 18, height: 18)
              ),
            ],
          ),
        ],
      ),
    );
  }
}


void showDataTernakDialog(BuildContext context, String id, String jenis, String berat, String status) {
  TextEditingController noteController = TextEditingController();
  

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.bgLight,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
        contentPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Container(
          width: double.maxFinite,
          height: 600,
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and title section (close button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                // Cow image section with reduced padding
                Center(
                  child: Image.asset(
                    'assets/data_ternak_assets/icons/ic_cow_hd.png',
                    height: 100,
                  ),
                ),
            
                // Ternak ID, Gender, and Age
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      id,
                      style: AppTextStyle.extraBold.copyWith(fontSize: 24, color: Colors.black),
                    ),
                    SizedBox(width: 8),
                    Text(
                      jenis,
                      style: AppTextStyle.semiBold.copyWith(
                        fontSize: 24,
                        color: jenis == 'Jantan' ? AppColors.green01 : AppColors.purple,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "$berat Kg",
                      style: AppTextStyle.extraBold.copyWith(fontSize: 24, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 16),
            
                // Kondisi Section
                CustomDropdownSehat(status: status),
                SizedBox(height: 16),
            
                // Berat Badan Section
                CustomWeightField(berat: berat),
                SizedBox(height: 16),
            
                // Catatan Section (Optional)
                Text(
                  'Catatan (Opsional)',
                  style: AppTextStyle.semiBold.copyWith(
                    fontSize: 14,
                    color: AppColors.black100,
                  ),
                ),
                SizedBox(height: 3),
                TextField(
                  controller: noteController,  // Bind controller to manage input
                  decoration: InputDecoration(
                    hintText: 'Tulis Catatan Di sini',
                    hintMaxLines: 4,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Set border radius to 6
                      borderSide: BorderSide(color: AppColors.white06), // Set border color to AppColors.white06
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  minLines: 3, // Minimum number of lines
                  maxLines: 3, // Maximum number of lines
                ),
                SizedBox(height: 16),
            
                // Save button section
                Center(
                  child: OnboardingButton(
                      previous: false,
                      text: "Simpan Perubahan",
                      width: double.infinity,
                      onClick: () => Navigator.of(context).pop(),
                      // Navigator.pushNamed(context, '/login'),
                      ),
                    ),
              ],
            ),
          ),
        ),
      );
    },
  );
}