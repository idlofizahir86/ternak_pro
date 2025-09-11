import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/custom_image_view.dart';
import '../../shared/widgets/onboarding_buttom.dart';
import 'hasil_biaya_pakan_page.dart';

class CustomInputBiayaPakanField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardTipe;
  final bool isHarga;

  const CustomInputBiayaPakanField({
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



class CustomDropdownInputTernak extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> options;
  final List<String> iconOptions;  // Menambahkan parameter untuk ikon
  final String selectedValue;
  final Function(String) onChanged;
  final bool isNeedIcon;  // Menambahkan parameter untuk menentukan apakah ikon diperlukan

  const CustomDropdownInputTernak({
    super.key,
    required this.label,
    required this.hintText,
    required this.options,
    required this.iconOptions,  // Menerima daftar ikon
    required this.selectedValue,
    required this.onChanged,
    this.isNeedIcon = false,  // Default false, ikon tidak ditampilkan
  });

  @override
  State<CustomDropdownInputTernak> createState() =>
      _CustomDropdownInputTernakState();
}

class _CustomDropdownInputTernakState extends State<CustomDropdownInputTernak> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    // Initialize selectedValue with the initial value from the parent widget
    selectedValue = widget.selectedValue;
  }
  

  @override
  Widget build(BuildContext context) {
    String imageUrl = widget.iconOptions[widget.options.indexOf(selectedValue)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 14, color: Colors.black),
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
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menampilkan ikon sesuai dengan opsi yang dipilih jika isNeedIcon true
              if (widget.isNeedIcon)
                Row(
                  children: [
                    // Memastikan selectedValue ada dalam options sebelum mencoba mengakses index
                    if (widget.options.contains(selectedValue))
                      imageUrl.startsWith('http')
                      ? Image.network(
                          imageUrl,
                          width: 16,
                          height: 16,
                        )
                      : Image.asset(
                          imageUrl,
                          width: 16,
                          height: 16,
                        )
                    else
                      SizedBox(width: 16), // Placeholder jika selectedValue tidak ada dalam options
                    SizedBox(width: 8),
                    // Menampilkan nilai yang dipilih atau hintText jika kosong
                    Text(
                      selectedValue.isEmpty ? widget.hintText : selectedValue,
                      style: TextStyle(fontSize: 14, color: selectedValue.isEmpty ? Colors.grey : Colors.black),
                    ),
                  ],
                )
              else
                Text(
                  selectedValue.isEmpty ? widget.hintText : selectedValue,
                  style: TextStyle(fontSize: 14, color: selectedValue.isEmpty ? Colors.grey : Colors.black),
                ),
              
              // Ikon dropdown
              Image.asset(
                'assets/biaya_pakan_assets/icons/ic_dropdown.png', 
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

  // Fungsi untuk menampilkan dialog atau bottom sheet dengan opsi
  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          content: SingleChildScrollView(
            child: ListBody(
              children: widget.options.asMap().entries.map((entry) {
                int index = entry.key;
                String imageUrl = widget.iconOptions[index];
                String option = entry.value;
                return RadioListTile<String>(
                  title: Row(
                    children: [
                      // Menampilkan ikon hanya jika isNeedIcon true
                      if (widget.isNeedIcon)
                        imageUrl.startsWith('http')
                        ? Image.network(
                            imageUrl,
                            width: 16,
                            height: 16,
                          )
                        : Image.asset(
                            imageUrl,
                            width: 16,
                            height: 16,
                          ),
                      SizedBox(width: 10),
                      Text(
                        option,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  value: option,
                  groupValue: selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value!;
                    });
                    widget.onChanged(value!); // Update selected value
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  activeColor: Colors.green, // Color of the radio button's outer circle when selected
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
class PerkiraanBiayaPakanPage extends StatefulWidget {
  const PerkiraanBiayaPakanPage({super.key});

  @override
  PerkiraanBiayaPakanPageState createState() => PerkiraanBiayaPakanPageState();
}

class PerkiraanBiayaPakanPageState extends State<PerkiraanBiayaPakanPage> {
  final TextEditingController _usiaTernakController = TextEditingController();
  final TextEditingController _jumlahTernakController = TextEditingController();

  final List<String> _selectedPakanList = []; // List untuk menyimpan selected value untuk setiap row
  final List<TextEditingController> _hargaControllers = []; // List untuk menyimpan controllers

  String _selectedTernak = '';

  @override
  void initState() {
    super.initState();

    // Inisialisasi row pertama dengan controller dan selected value kosong
    _hargaControllers.add(TextEditingController()); 
    _selectedPakanList.add(''); // Entry kosong untuk selected value

    
  }

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
            CustomDropdownInputTernak(
              label: 'Jenis Ternak',
              hintText: 'Pilih jenis ternak',
              options: ['Ayam', 'Sapi', 'Dinosaurus'],
              iconOptions: ['assets/biaya_pakan_assets/icons/ayam.png','assets/biaya_pakan_assets/icons/sapi.png','assets/biaya_pakan_assets/icons/ayam.png',],
              isNeedIcon: true,
              selectedValue: _selectedTernak,
              onChanged: (value) => setState(() {
                _selectedTernak = value;
              }),
            ),

            CustomInputBiayaPakanField(
              label: 'Jumlah Ternak',
              hintText: 'Masukkan Jumlah Ternak Yang Dimiliki',
              controller: _jumlahTernakController,
              keyboardTipe: TextInputType.number,
            ),

            CustomInputBiayaPakanField(
              label: 'Usia Ternak (Bulan)',
              hintText: 'Masukkan Usia Ternak Yang Dimiliki',
              controller: _usiaTernakController,
              keyboardTipe: TextInputType.number,
            ),

            // Menampilkan Row Pakan
            Column(
              children: List.generate(_selectedPakanList.length, (index) {
                return Row(
                  children: [
                    Expanded(
                      child: CustomDropdownInputTernak(
                        label: 'Jenis Pakan',
                        hintText: 'Pilih jenis pakan',
                        options: ['Dedak', 'Nasi', 'Steak'],
                        iconOptions: ['assets/biaya_pakan_assets/icons/ayam.png','assets/biaya_pakan_assets/icons/sapi.png','assets/biaya_pakan_assets/icons/ayam.png',],
                        isNeedIcon: false,
                        selectedValue: _selectedPakanList[index],
                        onChanged: (value) => setState(() {
                          _selectedPakanList[index] = value;
                        }),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: CustomInputBiayaPakanField(
                        label: 'Harga Pakan Per Kg',
                        hintText: '40.000.000',
                        controller: _hargaControllers[index], // Menggunakan controller untuk row tertentu
                        isHarga: true,
                        keyboardTipe: TextInputType.number,
                      ),
                    ),
                  ],
                );
              }),
            ),

            OnboardingButton(
              previous: true,
              text: "+ Tambah Pakan",
              width: double.infinity,
              onClick: () {
                setState(() {
                  // Tambahkan controller baru untuk harga pakan
                  TextEditingController newController = TextEditingController();
                  _hargaControllers.add(newController); // Menyimpan controller baru
                  _selectedPakanList.add(''); // Menambahkan entry kosong untuk selected value

                  // Menambahkan row baru
                });
              },
            ),

            SizedBox(height: 10),
            OnboardingButton(
              previous: false,
              text: "Hitung Sekarang",
              width: double.infinity,
              onClick: () {
                // Navigasi ke halaman HasilBiayaPakanPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HasilBiayaPakanPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}