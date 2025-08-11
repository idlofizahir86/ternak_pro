import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/custom_image_view.dart';
import '../../shared/widgets/onboarding_buttom.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

// Widget untuk Input Text
class CustomInputRekomendasiTernakField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardTipe;
  final bool isHarga;

  const CustomInputRekomendasiTernakField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.keyboardTipe = TextInputType.text,
    this.isHarga = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 3),
        TextField(
          maxLines: maxLines,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 14),
            prefixText: isHarga ? 'Rp. ' : '', // Menambahkan "Rp." jika isHarga true
            prefixStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          keyboardType: keyboardTipe,
          inputFormatters: [
            if (isHarga) _moneyFormatter(), // Format uang jika isHarga true
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Formatter untuk menambahkan pemisah ribuan otomatis
  TextInputFormatter _moneyFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      // Hapus semua karakter non-digit
      String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

      // Format angka dengan pemisah ribuan/jutaan/dst.
      final formatter = NumberFormat('#,##0', 'id_ID'); // Bisa panjang tak terbatas
      String formatted = '';
      if (digitsOnly.isNotEmpty) {
        try {
          formatted = formatter.format(int.parse(digitsOnly));
        } catch (e) {
          formatted = oldValue.text; // fallback jika parsing gagal
        }
      }

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });
  }
}

// Widget untuk Dropdown
class CustomDropdownInputTernak extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> options;
  final String selectedValue;
  final Function(String) onChanged;

  const CustomDropdownInputTernak({super.key, 
    required this.label,
    required this.hintText,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<CustomDropdownInputTernak> createState() => _CustomDropdownInputTernakState();
}

class _CustomDropdownInputTernakState
    extends State<CustomDropdownInputTernak> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    // Initialize selectedValue with the initial value from the parent widget
    selectedValue = widget.selectedValue;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyle.semiBold.copyWith(fontSize: 14, color: AppColors.black100),
        ),
        SizedBox(height: 3),
        GestureDetector(
          onTap: () {
            // Show the options as a dialog or bottom sheet
            _showOptionsDialog(context);
          },
          child: Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.black01),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedValue.isEmpty ? widget.hintText : widget.selectedValue,
                  style: AppTextStyle.medium.copyWith(
                    fontSize: 14,
                    color: widget.selectedValue.isEmpty ? AppColors.black01 : AppColors.black100, // Color based on selection
                  ),
                ),
                Image.asset(
                  'assets/home_assets/icons/ic_dropdown.png',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Function to show the options as a dialog or bottom sheet
  void _showOptionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.primaryWhite,
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        content: SingleChildScrollView(
          child: ListBody(
            children: widget.options.map((option) {
              return RadioListTile<String>(
                title: Text(
                  option,
                  style: AppTextStyle.medium.copyWith(fontSize: 16, color: AppColors.black100),
                ),
                value: option,
                groupValue: widget.selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value!;
                  });
                  widget.onChanged(value!); // Update selected value
                  Navigator.of(context).pop(); // Close the dialog
                },
                activeColor: AppColors.green01, // Color of the radio button's outer circle when selected
                visualDensity: VisualDensity.compact,
                toggleable: true, // Allows the radio button to be toggled between on/off state
                // Set the color of the inner dot when selected
                fillColor: WidgetStateProperty.all(AppColors.green01), 
              );

            }).toList(),
          ),
        ),
      );
    },
  );
}
}

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
                    'Rekomendasi Ternak Potensial',
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
class RekomendasiTernakPage extends StatefulWidget {
  const RekomendasiTernakPage({super.key});

  @override
  RekomendasiTernakPageState createState() => RekomendasiTernakPageState();
}

class RekomendasiTernakPageState extends State<RekomendasiTernakPage> {
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _panjangLahanController = TextEditingController();
  final TextEditingController _lebarLahanController = TextEditingController();
  final TextEditingController _modalController = TextEditingController();

  String _selectedPengalaman = '';
  String _selectedWaktuPerawatan = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
        child: _buildHeaderSection(context),  // Menggunakan header yang sudah dibuat
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Gambar (tidak pakai Expanded supaya tidak melar)
                Image.asset(
                  'assets/rekomendasi_ternak_assets/icons/ic_pin_location.png',
                  width: 30, // tambahkan kalau mau proporsional
                  fit: BoxFit.cover,
                ),

                const SizedBox(width: 8),

                // Dropdown tetap pakai Expanded supaya ambil sisa ruang
                Expanded(
                  child: CustomInputRekomendasiTernakField(
                    label: 'Lokasi Peternakan',
                    hintText: 'Isi dengan gmaps',
                    controller: _lokasiController,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                // Gambar (tidak pakai Expanded supaya tidak melar)
                Image.asset(
                  'assets/rekomendasi_ternak_assets/icons/ic_location_farm.png',
                  width: 30, // tambahkan kalau mau proporsional
                  fit: BoxFit.cover,
                ),

                const SizedBox(width: 8),

                // Dropdown tetap pakai Expanded supaya ambil sisa ruang
                Expanded(
                  child: CustomInputRekomendasiTernakField(
                    label: 'Panjang Lahan (Meter)',
                    hintText: '20',
                    controller: _panjangLahanController,
                    keyboardTipe: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 5),

                // Dropdown tetap pakai Expanded supaya ambil sisa ruang
                Expanded(
                  child: CustomInputRekomendasiTernakField(
                    label: 'Lebar Lahan (Meter)',
                    hintText: '20',
                    controller: _lebarLahanController,
                    keyboardTipe: TextInputType.number,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                // Gambar (tidak pakai Expanded supaya tidak melar)
                Image.asset(
                  'assets/rekomendasi_ternak_assets/icons/ic_money_banyak.png',
                  width: 30, // tambahkan kalau mau proporsional
                  fit: BoxFit.cover,
                ),

                const SizedBox(width: 8),

                // Dropdown tetap pakai Expanded supaya ambil sisa ruang
                Expanded(
                  child: CustomInputRekomendasiTernakField(
                    label: 'Modal Tersedia',
                    hintText: '2.000.000',
                    controller: _modalController,
                    isHarga: true,
                    keyboardTipe: TextInputType.number,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                // Gambar (tidak pakai Expanded supaya tidak melar)
                Image.asset(
                  'assets/rekomendasi_ternak_assets/icons/ic_clock.png',
                  width: 30, // tambahkan kalau mau proporsional
                  fit: BoxFit.cover,
                ),

                const SizedBox(width: 8),

                // Dropdown tetap pakai Expanded supaya ambil sisa ruang
                Expanded(
                  child: CustomDropdownInputTernak(
                    label: 'Waktu Perawatan Yang Dimiliki',
                    hintText: 'Pilih Salah Satu',
                    options: ['Siang', 'Malam', 'Pagi'], // Contoh pilihan
                    selectedValue: _selectedWaktuPerawatan,
                    onChanged: (value) => setState(() => _selectedWaktuPerawatan = value),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                // Gambar (tidak pakai Expanded supaya tidak melar)
                Image.asset(
                  'assets/rekomendasi_ternak_assets/icons/ic_farmer.png',
                  width: 30, // tambahkan kalau mau proporsional
                  fit: BoxFit.cover,
                ),

                const SizedBox(width: 8),

                // Dropdown tetap pakai Expanded supaya ambil sisa ruang
                Expanded(
                  child: CustomDropdownInputTernak(
                    label: 'Pengalaman Beternak',
                    hintText: 'Pilih Tingkatan',
                    options: ['Pemula', 'Menengah', 'Ahli'], // Contoh pilihan
                    selectedValue: _selectedPengalaman,
                    onChanged: (value) => setState(() => _selectedPengalaman = value),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomActionButton(),
    );
  }
}

class BottomActionButton extends StatelessWidget {
  const BottomActionButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ClipRect(
        child: Opacity(
          opacity: 1.0, // You can adjust this value for transparency, 1.0 = no transparency
          child:  OnboardingButton(
              previous: false,
              text: "Lihat Rekomendasi ➜",
              width: double.infinity,
              onClick: () => Navigator.pushNamed(
                context,
                '/hasil-rekomendasi-peternak',
                arguments: []
              ),
            ),
        ),
      ),
    );
  }
}