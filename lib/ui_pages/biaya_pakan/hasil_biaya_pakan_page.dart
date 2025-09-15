import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;  // Import ini untuk sqrt() dan math lainnya
import '../../shared/theme.dart';
import '../../shared/widgets/custom_image_view.dart';
import '../../shared/widgets/onboarding_buttom.dart';

// Header dengan ikon back
Widget _buildHeaderSection(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.12,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: AppColors.gradasi01,
    ),
    child: Stack(
      children: [
        CustomImageView(
          imagePath: "assets/home_assets/images/img_star.png",
          height: MediaQuery.of(context).size.height * 0.12,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 60,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Back Icon Button
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  'assets/data_ternak_assets/icons/ic_back.png',
                  width: 24,
                  height: 24,
                ),
              ),
              SizedBox(width: 10),
              // Title Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perkiraan Biaya Pakan',
                    style: AppTextStyle.medium.copyWith(fontSize: 20, color: AppColors.white100),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Halaman Utama
class HasilBiayaPakanPage extends StatefulWidget {
  final String selectedTernak;
  final int jumlahTernak;
  final int usiaBulan;
  final List<String> pakanList;
  final List<double> hargaList;

  const HasilBiayaPakanPage({
    super.key,
    required this.selectedTernak,
    required this.jumlahTernak,
    required this.usiaBulan,
    required this.pakanList,
    required this.hargaList,
  });

  @override
  State<HasilBiayaPakanPage> createState() => _HasilBiayaPakanPageState();
}

class _HasilBiayaPakanPageState extends State<HasilBiayaPakanPage> {
  late double totalHarian;
  late double totalMingguan;
  late double totalBulanan;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  // Fungsi perhitungan dinamis
  void _calculateTotals() {
    double total = 0.0;
    for (int i = 0; i < widget.pakanList.length; i++) {
      final kebutuhan = _getKebutuhanPerPakan(widget.selectedTernak, widget.usiaBulan);
      final harga = widget.hargaList[i];
      total += kebutuhan * harga * widget.jumlahTernak;
    }
    totalHarian = total;
    totalMingguan = total * 7;
    totalBulanan = total * 30;
  }

  // Estimasi kebutuhan harian per ternak (kg/hari, berdasarkan jenis dan usia)
  double _getKebutuhanPerPakan(String ternak, int usiaBulan) {
    double base;
    if (ternak == 'Ayam') {
      base = 0.12; // Base 120g/hari
      return base * (1 + usiaBulan / 120.0); // +10% per tahun
    } else if (ternak == 'Sapi') {
      base = 2.5; // Base 2.5kg/hari untuk muda
      return base * math.sqrt(usiaBulan / 12.0); // Skala dengan sqrt(usia tahun)
    } else {
      return 1.0; // Default
    }
  }

  // Format rupiah
  String _formatRupiah(double amount) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return 'Rp. ${formatter.format(amount.toInt())}';
  }

  // Format kebutuhan (contoh: "1,2 kg / Hari")
  String _formatKebutuhan(double kg) {
    return '${(kg * 10).round() / 10}, ${(kg * 1000).round() % 1000 == 0 ? 0 : ((kg * 1000).round() % 1000).toString().padLeft(3, '0')} kg / Hari';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
        child: _buildHeaderSection(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(14),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.green0110,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/biaya_pakan_assets/icons/ic_lamp.png",
                        width: 24,
                      ),
                      SizedBox(width: 10),
                      Text('Hasil Perhitungan Pakan',
                      style: AppTextStyle.extraBold.copyWith(fontSize: 16),)
                    ],
                  ),
                  SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/biaya_pakan_assets/icons/ayam.png", // Bisa dinamis berdasarkan ternak
                        width: 24,
                      ),
                      SizedBox(width: 10),
                      Text('Jenis Peternak : ${widget.selectedTernak}',
                      style: AppTextStyle.medium.copyWith(fontSize: 14),)
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/biaya_pakan_assets/icons/ic_plus.png",
                        width: 24,
                      ),
                      SizedBox(width: 10),
                      Text('Jumlah Ternak : ${widget.jumlahTernak} Ekor',
                      style: AppTextStyle.medium.copyWith(fontSize: 14),)
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        "assets/biaya_pakan_assets/icons/ic_calender.png",
                        width: 24,
                      ),
                      SizedBox(width: 10),
                      Text('Usia Ternak : ${widget.usiaBulan} Bulan',
                      style: AppTextStyle.medium.copyWith(fontSize: 14),)
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.only(
                top: 21,
                bottom: 21,
                left: 15,
                right: 15,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.black10,
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kebutuhan Pakan Harian (Estimasi)',
                    style: AppTextStyle.extraBold.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 13),
                  // Dinamis: Loop pakan
                  ...List.generate(widget.pakanList.length, (index) {
                    final kebutuhan = _getKebutuhanPerPakan(widget.selectedTernak, widget.usiaBulan);
                    final harga = widget.hargaList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0) ...[
                                Text('Jenis Pakan',
                                  style: AppTextStyle.extraBold.copyWith(fontSize: 14),
                                ),
                                SizedBox(height: 13),
                              ],
                              Text(widget.pakanList[index],
                                style: AppTextStyle.medium.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0) ...[
                                Text('Kebutuhan',
                                  style: AppTextStyle.extraBold.copyWith(fontSize: 14),
                                ),
                                SizedBox(height: 13),
                              ],
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/biaya_pakan_assets/icons/ic_plus_minus.png',
                                    width: 9,
                                  ),
                                  SizedBox(width: 2),
                                  Text(_formatKebutuhan(kebutuhan),
                                    style: AppTextStyle.medium.copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0) ...[
                                Text('Harga',
                                  style: AppTextStyle.extraBold.copyWith(fontSize: 14),
                                ),
                                SizedBox(height: 13),
                              ],
                              Text(_formatRupiah(harga),
                                style: AppTextStyle.medium.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  if (widget.pakanList.length > 1) const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Biaya Harian',
                            style: AppTextStyle.extraBold.copyWith(fontSize: 16),
                          ),
                          SizedBox(height: 13),
                          Text('Estimasi Biaya Mingguan',
                            style: AppTextStyle.medium.copyWith(fontSize: 14),
                          ),
                          SizedBox(height: 10),
                          Text('Estimasi Biaya Bulanan',
                            style: AppTextStyle.medium.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_formatRupiah(totalHarian),
                            style: AppTextStyle.extraBold.copyWith(fontSize: 16),
                          ),
                          SizedBox(height: 13),
                          Text(_formatRupiah(totalMingguan),
                            style: AppTextStyle.extraBold.copyWith(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(_formatRupiah(totalBulanan),
                            style: AppTextStyle.extraBold.copyWith(fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 30),

            OnboardingButton(
              previous: false,
              text: "Selesai",
              width: double.infinity,
              onClick: () {
                int count = 0;
                Navigator.popUntil(context, (_) => count++ >= 2);
              },
            ),
          ],
        ),
      ),
    );
  }
}