import 'package:flutter/material.dart';
import 'package:ternak_pro/shared/custom_loading.dart';
import '../../services/api_service.dart';
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
  final TextInputType? keyboardType;

  const CustomInputTernakField({super.key, 
    required this.label,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.isCalendar = false, // Default false
    this.keyboardType,
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

class CustomDropdownInputTernak extends StatefulWidget {
  final String label;
  final String hintText;
  final List<Map<String, dynamic>> options;
  final String selectedValue;
  final Function(String) onChanged;

  const CustomDropdownInputTernak({
    super.key,
    required this.label,
    required this.hintText,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<CustomDropdownInputTernak> createState() => _CustomDropdownInputTernakState();
}

class _CustomDropdownInputTernakState extends State<CustomDropdownInputTernak> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyle.semiBold.copyWith(fontSize: 14, color: AppColors.black100),
        ),
        const SizedBox(height: 3),
        GestureDetector(
          onTap: () => _showOptionsDialog(context),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.black01),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedValue.isEmpty ? widget.hintText : widget.options.firstWhere(
                    (option) => option['id'].toString() == widget.selectedValue,
                    orElse: () => {'nama': widget.hintText},
                  )['nama'],
                  style: AppTextStyle.medium.copyWith(
                    fontSize: 14,
                    color: widget.selectedValue.isEmpty ? AppColors.black01 : AppColors.black100,
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
        const SizedBox(height: 16),
      ],
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.primaryWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          content: SingleChildScrollView(
            child: ListBody(
              children: widget.options.map((option) {
                return RadioListTile<String>(
                  title: Text(
                    option['nama'],
                    style: AppTextStyle.medium.copyWith(fontSize: 16, color: AppColors.black100),
                  ),
                  value: option['id'].toString(),
                  groupValue: widget.selectedValue,
                  onChanged: (String? value) {
                    setState(() {
                      widget.onChanged(value!);
                    });
                    Navigator.of(context).pop();
                  },
                  activeColor: AppColors.green01,
                  visualDensity: VisualDensity.compact,
                  toggleable: true,
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
  String _selectedRas = '';
  String _selectedTujuanTernak = '';
  String _selectedUsia = '';
  String _selectedKondisi = '';
  String _selectedJenisKelamin = '';

  List<Map<String, dynamic>> _optionsHewan = [];
  List<Map<String, dynamic>> _optionsRas = [];
  List<Map<String, dynamic>> _optionsTujuanTernak = [];
  bool _isLoading = true;
  String? _errorMessage;

  final ApiService _apiService = ApiService();
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await loadUserId();
      final hewan = await _apiService.getHewan();
      final ras = await _apiService.getRas();
      final tujuanTernak = await _apiService.getTujuanTernakListByUserId(userId);
      setState(() {
        _optionsHewan = hewan;
        _optionsRas = ras;
        _optionsTujuanTernak = tujuanTernak;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> loadUserId() async {
    final credential = await _apiService.loadCredentials();
    setState(() {
      userId = credential['user_id'];
    });
  }

  Future<void> _saveData() async {
    try {
      final data = {
        'user_id': userId,
        'nama_peternakan': _namaPeternakanController.text,
        'tanggal_mulai': _tanggalMulaiController.text,
        'hewan': _selectedHewan,
        'ras': _selectedRas,
        'tujuan_ternak': _selectedTujuanTernak,
        'usia': _selectedUsia,
        'catatan': _catatanController.text,
        'is_individu': _isChecked,
        if (_isChecked) ...{
          'nomor_ternak': _jumlahHewanController.text,
          'kondisi': _selectedKondisi,
          'jenis_kelamin': _selectedJenisKelamin,
          'berat': _beratController.text,
        } else ...{
          'jumlah_hewan': _jumlahController.text,
        },
      };

      // Kirim data ke API (misalnya endpoint POST /ternak)
      // await _apiService.createTernak(data);

      // Navigasi ke halaman daftar setelah sukses
      Navigator.pushNamed(context, '/list-data-ternak-tugas');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: TernakProBoxLoading()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _loadData();
                },
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
        child: _buildHeaderSection(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
            // Pilih Hewan dan Ras
            Row(
              children: [
                Expanded(
                  child: CustomDropdownInputTernak(
                    label: 'Pilih Hewan',
                    hintText: 'Pilih salah satu',
                    options: _optionsHewan,
                    selectedValue: _selectedHewan,
                    onChanged: (value) => setState(() => _selectedHewan = value),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDropdownInputTernak(
                    label: 'Pilih Ras',
                    hintText: 'Masukkan Ras',
                    options: _optionsRas,
                    selectedValue: _selectedRas,
                    onChanged: (value) => setState(() => _selectedRas = value),
                  ),
                ),
              ],
            ),
            // Dibesarkan untuk dan Usia
            Row(
              children: [
                Expanded(
                  child: CustomDropdownInputTernak(
                    label: 'Dibesarkan untuk',
                    hintText: 'Pilih salah satu',
                    options: _optionsTujuanTernak,
                    selectedValue: _selectedTujuanTernak,
                    onChanged: (value) => setState(() => _selectedTujuanTernak = value),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomDropdownInputTernak(
                    label: 'Usia',
                    hintText: 'Pilih salah satu',
                    options: const [
                      {'id': '1', 'nama': '0-6 bulan'},
                      {'id': '2', 'nama': '6-12 bulan'},
                      {'id': '3', 'nama': '1-2 tahun'},
                      {'id': '4', 'nama': '>2 tahun'},
                    ],
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
                const Text('Saya ingin mencatat ternak secara individu'),
              ],
            ),
            // Jika checkbox dicentang
            if (_isChecked) ...[
              CustomInputTernakField(
                label: 'Nomer Ternak (Tag)',
                hintText: 'Ketikan nomor ternak',
                controller: _jumlahHewanController,
              ),
              CustomDropdownInputTernak(
                label: 'Kondisi',
                hintText: 'Pilih salah satu',
                options: const [
                  {'id': 'Sehat', 'nama': 'Sehat'},
                  {'id': 'Sakit', 'nama': 'Sakit'},
                ],
                selectedValue: _selectedKondisi,
                onChanged: (value) => setState(() => _selectedKondisi = value),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdownInputTernak(
                      label: 'Jenis Kelamin',
                      hintText: 'Pilih salah satu',
                      options: const [
                        {'id': 'Jantan', 'nama': 'Jantan'},
                        {'id': 'Betina', 'nama': 'Betina'},
                      ],
                      selectedValue: _selectedJenisKelamin,
                      onChanged: (value) => setState(() => _selectedJenisKelamin = value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomInputTernakField(
                      label: 'Berat (Kg)',
                      hintText: 'Ex: 6',
                      controller: _beratController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ] else ...[
              CustomInputTernakField(
                label: 'Jumlah Hewan',
                hintText: 'Ketik Jumlah',
                controller: _jumlahController,
                keyboardType: TextInputType.number,
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
              text: "➞ Simpan", // Menggunakan emoji panah tebal dari respons sebelumnya
              width: double.infinity,
              onClick: _saveData,
            ),
          ],
        ),
      ),
    );
  }
}