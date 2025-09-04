import 'package:flutter/material.dart';
import 'package:ternak_pro/services/api_service.dart';
import 'package:ternak_pro/shared/widgets/data_ternak/custom_drop_down_kelamin.dart';

import '../../theme.dart';
import '../onboarding_buttom.dart';
import 'custom_drop_down_sehat.dart';
import 'custom_weight_field.dart';

class DataTernakList extends StatefulWidget {
  final List<Map<String, dynamic>> ternakList;
  final VoidCallback onRefresh;

  const DataTernakList(this.ternakList,  {super.key,  required this.onRefresh});

  @override
  State<DataTernakList> createState() => _DataTernakListState();
}

class _DataTernakListState extends State<DataTernakList> {
  late List<Map<String, dynamic>> _ternakList;

  @override
  void initState() {
    super.initState();
    _ternakList = List.from(widget.ternakList); // Salin daftar untuk state lokal
  }

  void _updateTernakItem(int index, Map<String, dynamic> updatedData) {
    setState(() {
      _ternakList[index] = updatedData; // Perbarui item di daftar
    });
    widget.onRefresh(); // Memaksa FutureBuilder untuk memuat ulang data
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.ternakList.length,
      itemBuilder: (context, index) {
        return CustomTernakItem(
          idTernak: widget.ternakList[index]['id_ternak'],
          id: widget.ternakList[index]['tag_id'],
          jenis: widget.ternakList[index]['jenis_kelamin'],
          berat: widget.ternakList[index]['berat']!.toString(),
          status: widget.ternakList[index]['kondisi_ternak'],
          onUpdate: (updatedData) => _updateTernakItem(index, updatedData),
        );
      },
    );
  }
}


class CustomTernakItem extends StatelessWidget {
  final String id;
  final int idTernak;
  final String jenis;
  final String berat;
  final String status;
  final Function(Map<String, dynamic>) onUpdate;

  const CustomTernakItem({super.key, 
    required this.id,
    required this.idTernak,
    required this.jenis,
    required this.berat,
    required this.status,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final updatedData = await showDataTernakDialog(context, id, idTernak, jenis, berat, status);
        if (updatedData != null) {
          onUpdate(updatedData); // Perbarui daftar di parent
        }
      },
      child: Container(
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
              onTap: () async{
                // Panggil fungsi untuk membuka modal saat item ditekan
                final updatedData = await showDataTernakDialog(context, id, idTernak, jenis, berat, status);
                if (updatedData != null) {
                  onUpdate(updatedData); // Perbarui daftar di parent
                }
              },
              child: Image.asset('assets/data_ternak_assets/icons/ic_cow_hd.png', width: 50, height: 50)),
            InkWell(
              onTap: () async {
                final updatedData = await showDataTernakDialog(context, id, idTernak, jenis, berat, status);
                if (updatedData != null) {
                  onUpdate(updatedData); // Perbarui daftar di parent
                }
              },
              child: Text(id, style: AppTextStyle.extraBold.copyWith(fontSize: 14, color: Colors.black))),
            InkWell(
              onTap: () async {
                final updatedData = await showDataTernakDialog(context, id, idTernak, jenis, berat, status);
                if (updatedData != null) {
                  onUpdate(updatedData); // Perbarui daftar di parent
                }
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
              onTap: () async {
                final updatedData = await showDataTernakDialog(context, id, idTernak, jenis, berat, status);
                if (updatedData != null) {
                  onUpdate(updatedData); // Perbarui daftar di parent
                }
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
      ),
    );
  }
}


Future<Map<String, dynamic>?> showDataTernakDialog(
  BuildContext context,
  String tagId,
  int idTernak,
  String jenis,
  String berat,
  String status,
  ) async {
    TextEditingController noteController = TextEditingController();
    ValueNotifier<String> jenisKelaminNotifier = ValueNotifier(jenis);
    ValueNotifier<String> kondisiTernakNotifier = ValueNotifier(status);
    ValueNotifier<String> beratNotifier = ValueNotifier(berat);

  

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
                      tagId,
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
                CustomDropDownKelamin(
                  status: jenis,
                  onChanged: (value) {
                    jenisKelaminNotifier.value = value;
                  },
                ),
                SizedBox(height: 16),
                // Kondisi Section
                CustomDropdownSehat(
                  status: status,
                  onChanged: (value) {
                    kondisiTernakNotifier.value = value;
                  },
                ),
                SizedBox(height: 16),
                // Berat Badan Section
                CustomWeightField(
                  berat: berat,
                  onChanged: (value) {
                    beratNotifier.value = value;
                  },
                ),
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
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: 'Tulis Catatan Di sini',
                    hintMaxLines: 4,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.white06),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  minLines: 3,
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Center(
                child: OnboardingButton(
                  previous: false,
                  text: "Simpan Perubahan",
                  width: double.infinity,
                  onClick: () async {
                    try {
                      // Panggil API untuk menyimpan perubahan
                      await ApiService().updateDataTernak(
                        userId: (await ApiService().loadCredentials())['user_id'],
                        idTernak: idTernak,
                        jenisKelamin: jenisKelaminNotifier.value,
                        kondisiTernak: kondisiTernakNotifier.value,
                        berat: beratNotifier.value,
                        catatan: noteController.text.isEmpty ? null : noteController.text,
                      );

                      // Kembalikan data yang diperbarui untuk refresh
                      final updatedData = {
                        'id_ternak': idTernak,
                        'tag_id': tagId,
                        'jenis_kelamin': jenisKelaminNotifier.value,
                        'berat': double.parse(beratNotifier.value),
                        'kondisi_ternak': kondisiTernakNotifier.value,
                        'catatan': noteController.text.isEmpty ? null : noteController.text,
                      };

                      Navigator.of(context).pop(updatedData);
                      Navigator.pushReplacementNamed(context, '/list-data-ternak-tugas');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal menyimpan perubahan: $e'),
                          backgroundColor: AppColors.primaryRed,
                        ),
                      );
                    }
                  },
                ),
              ),
              ],
            ),
          ),
        ),
      );
    },
  );
  return null;
}