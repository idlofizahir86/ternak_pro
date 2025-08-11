import 'package:flutter/material.dart';
import '../../shared/theme.dart';
import '../../shared/widgets/custom_image_view.dart';
import '../../shared/widgets/onboarding_buttom.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal

// Widget untuk Input Text
class CustomInputTernakField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int maxLines;
  final bool isCalendar; // Flag untuk menentukan apakah akan menampilkan DatePicker

  const CustomInputTernakField({super.key, 
    required this.label,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.isCalendar = false, // Default false
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
          readOnly: isCalendar, // Make it read-only if it's a DatePicker
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black54),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 14),
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
                    'Tambah Data Ternak',
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
class TambahDataTernakPage extends StatefulWidget {
  const TambahDataTernakPage({super.key});

  @override
  TambahDataTernakPageState createState() => TambahDataTernakPageState();
}

class TambahDataTernakPageState extends State<TambahDataTernakPage> {
  final TextEditingController _namaPeternakanController = TextEditingController();
  final TextEditingController _tanggalMulaiController = TextEditingController();
  final TextEditingController _jumlahHewanController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _beratController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  bool _isChecked = false;
  String _selectedHewan = '';
  String _selectedBesarkan = '';
  String _selectedRas = '';
  String _selectedUsia = '';
  String _selectedKondisi = '';
  String _selectedJenisKelamin = '';

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
            // Nama Peternakan
            CustomInputTernakField(
              label: 'Nama Peternakan',
              hintText: 'Masukkan Nama Peternakanmu',
              controller: _namaPeternakanController,
            ),
            
            // Tanggal Mulai
            CustomInputTernakField(
              label: 'Tanggal Mulai',
              hintText: 'HH/BB/TTTT',
              controller: _tanggalMulaiController,
              isCalendar: true,
            ),
            
            Row(
              children: [
                // Pilih Hewan
                Expanded(
                  child: CustomDropdownInputTernak(
                    label: 'Pilih Hewan',
                    hintText: 'Pilih salah satu',
                    options: ['Hewan 1', 'Hewan 2', 'Hewan 3'], // Contoh pilihan
                    selectedValue: _selectedHewan,
                    onChanged: (value) => setState(() => _selectedHewan = value),
                  ),
                ),

                SizedBox(width: 8),
                
                // Pilih Ras
                Expanded(
                  child: CustomDropdownInputTernak(
                    label: 'Pilih Ras',
                    hintText: 'Masukkan Ras',
                    options: ['Ras 1', 'Ras 2', 'Ras 3'], // Contoh pilihan
                    selectedValue: _selectedRas,
                    onChanged: (value) => setState(() => _selectedRas = value),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                // Pilih Dibesarkan
                Expanded(
                  child: CustomDropdownInputTernak(
                    label: 'Dibesarkan untuk',
                    hintText: 'Pilih salah satu',
                    options: ['Sapi Peras', 'Peranak', 'Terbang'], // Contoh pilihan
                    selectedValue: _selectedBesarkan,
                    onChanged: (value) => setState(() => _selectedBesarkan = value),
                  ),
                ),

                SizedBox(width: 8),
                
                // Pilih Usia
                Expanded(
                  child: CustomDropdownInputTernak(
                      label: 'Usia',
                      hintText: 'Pilih salah satu',
                      options: ['h', 'Usia 2', 'Usia 3'], // Contoh pilihan
                      selectedValue: _selectedUsia,
                      onChanged: (value) => setState(() => _selectedUsia = value),
                    ),
                ),
              ],
            ),
           
            // Checkbox
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                Text('Saya ingin mencatat ternak secara individu'),
              ],
            ),
            
            // Nomer Ternak (Tag) jika checkbox dicentang
            if (_isChecked) ...[
              CustomInputTernakField(
                label: 'Nomer Ternak (Tag)',
                hintText: 'Ketikan nomor ternak',
                controller: _jumlahHewanController,
              ),
              // Pilih Kondisi
              CustomDropdownInputTernak(
                label: 'Kondisi',
                hintText: 'Pilih salah satu',
                options: ['Sehat', 'Sakit'],
                selectedValue: _selectedKondisi,
                onChanged: (value) => setState(() => _selectedKondisi = value),
              ),

              Row(
                children: [
                  // Jenis Kelamin
                  Expanded(
                    child: CustomDropdownInputTernak(
                      label: 'Jenis Kelamin',
                      hintText: 'Pilih salah satu',
                      options: ['Jantan', 'Betina'],
                      selectedValue: _selectedJenisKelamin,
                      onChanged: (value) => setState(() => _selectedJenisKelamin = value),
                    ),
                  ),

                  SizedBox(width: 8),
                  
                  // Berat
                  Expanded(
                    child: CustomInputTernakField(
                        label: 'Berat (Kg)',
                        hintText: 'Ex: 6',
                        controller: _beratController,
                      ),
                  ),
                ],
              ),
            ] else ...[
              // Jika _isChecked false, tampilkan CustomInputTernakField untuk "Jumlah Hewan"
              CustomInputTernakField(
                label: 'Jumlah Hewan',
                hintText: 'Ketik Jumlah',
                controller: _jumlahController,
              ),
            ],
            
            
                        
            // Catatan (Opsional)
            CustomInputTernakField(
              label: 'Catatan (Opsional)',
              hintText: 'Write a message',
              controller: _catatanController,
              maxLines: 4,
            ),
            
            // Simpan Button
            OnboardingButton(
              previous: false,
              text: "Simpan",
              width: double.infinity,
              onClick: () => Navigator.pushNamed(context, '/list-data-ternak-tugas'),
            ),
          ],
        ),
      ),
    );
  }
}
