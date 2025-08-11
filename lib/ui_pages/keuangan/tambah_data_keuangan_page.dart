import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubit/tab_keuangan_cubit.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/keuangan/custom_app_bar.dart';
import '../../shared/widgets/keuangan/custom_tab_bar.dart';
import '../../shared/widgets/onboarding_buttom.dart';

class TambahDataKeuanganPage extends StatefulWidget {
  const TambahDataKeuanganPage({super.key});

  @override
  TambahDataKeuanganPageState createState() => TambahDataKeuanganPageState();
}

class TambahDataKeuanganPageState extends State<TambahDataKeuanganPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _dariController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();


  String _selectedAset = '';

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
      create: (_) => TabKeuanganCubit(initialIndex),
      child: BlocConsumer<TabKeuanganCubit, int>(
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
                    context.read<TabKeuanganCubit>().setKeuanganTab(index);
                  },
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            // Tanggal Mulai
                            CustomInputKeuanganField(
                              label: 'Tanggal Mulai',
                              hintText: 'HH/BB/TTTT',
                              controller: _tanggalController,
                              isCalendar: true,
                            ),

                            // Tanggal Mulai
                            CustomInputKeuanganField(
                              label: 'Total',
                              hintText: '2.000.000',
                              controller: _totalController,
                              isCalendar: false,
                              isHarga: true,
                              keyboardTipe: TextInputType.number,
                            ),
                            
                            CustomInputKeuanganField(
                              label: 'Dari',
                              hintText: 'Ex : Penjualan Susu',
                              controller: _dariController,
                              isCalendar: false,
                              isHarga: false,
                            ),

                            CustomDropdownInputKeuangan(
                              label: 'Aset',
                              hintText: 'Pilih Aset',
                              options: ['Tunai', 'Bank', 'E-Wallet'], // Contoh pilihan
                              selectedValue: _selectedAset,
                              onChanged: (value) => setState(() => _selectedAset = value),
                            ),

                            CustomInputKeuanganField(
                              label: 'Catatan (Opsional)',
                              hintText: 'Write a message',
                              controller: _catatanController,
                              maxLines: 4,
                            ),
                                  
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomActionButton(
              activePage: selectedIndex == 0 ? 'pendapatan' : 'pengeluaran',
            ),
          );
        },
      ),
    );
  }
}

// Widget untuk Dropdown
class CustomDropdownInputKeuangan extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> options;
  final String selectedValue;
  final Function(String) onChanged;

  const CustomDropdownInputKeuangan({super.key, 
    required this.label,
    required this.hintText,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<CustomDropdownInputKeuangan> createState() => _CustomDropdownInputKeuanganState();
}

class _CustomDropdownInputKeuanganState
    extends State<CustomDropdownInputKeuangan> {
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

class CustomInputKeuanganField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardTipe;
  final bool isCalendar; // Flag untuk menentukan apakah akan menampilkan DatePicker
  final bool isHarga; // Flag untuk menentukan apakah akan menampilkan DatePicker

  const CustomInputKeuanganField({super.key, 
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardTipe = TextInputType.text,
    this.maxLines = 1,
    this.isCalendar = false, // Default false
    this.isHarga = false, // Default false
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
          keyboardType: keyboardTipe,
          controller: controller,
          readOnly: isCalendar, // Make it read-only if it's a DatePicker
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 14),
            prefixText: isHarga ? 'Rp. ' : '', // Menambahkan "Rp." jika isHarga true
            suffixIcon: isCalendar
                ? IconButton(
                    icon: Image.asset(
                      'assets/data_ternak_assets/icons/ic_calendar.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () async {
                      _showDatePicker(context);
                    },
                  )
                : null, // No icon if it's not a calendar
          ),
          inputFormatters: [
            if (isHarga) moneyFormatter(), // Format uang jika isHarga true
          ],
          onTap: isCalendar
              ? () async {
                  _showDatePicker(context);
                }
              : null, // If it's a calendar, show DatePicker on tap
        ),
        SizedBox(height: 16),
      ],
    );
  }

  TextInputFormatter moneyFormatter() {
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

  
  // Function to show DatePicker dialog
  void _showDatePicker(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      // Format the selected date and set it in the controller
      String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      controller.text = formattedDate; // Update the text field with the selected date
    }
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
            text: "Menyimpan",
            width: double.infinity,
            height: 30,
            onClick: () => Navigator.pushNamed(context, "/tambah-data-$activePage"),
            
          ),
        ),
      ),
    );
  }
}
