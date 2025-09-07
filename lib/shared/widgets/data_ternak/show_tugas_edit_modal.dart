import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme.dart';

Future<void> showTugasEditModal(
  BuildContext context, {
  required String title,
  required int idTugas,
  required String status,
  required int statusId,
  required String catatan,
  required String time, // format "HH:mm"
  required String iconPath,
  required String tglTugas, // Added t重建
  required void Function({
    required String status,
    required int statusId,
    required String time,
    required String catatan,
    required String tglTugas, // Added
  }) onSave,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black.withAlpha(89), // dim belakang
    barrierColor: Colors.black.withAlpha(89),
    builder: (_) => _TugasEditModal(
      title: title,
      status: status,
      statusId: statusId,
      catatan: catatan,
      time: time,
      iconPath: iconPath,
      tglTugas: tglTugas, // Added
      onSave: onSave,
    ),
  );
}

class _TugasEditModal extends StatefulWidget {
  final String title;
  final String status;
  final int statusId;
  final String catatan;
  final String time;
  final String iconPath;
  final String tglTugas; // Added
  final void Function({
    required String status,
    required int statusId,
    required String time,
    required String catatan,
    required String tglTugas, // Added
  }) onSave;

  const _TugasEditModal({
    required this.title,
    required this.status,
    required this.statusId,
    required this.catatan,
    required this.time,
    required this.iconPath,
    required this.tglTugas, // Added
    required this.onSave,
  });

  @override
  State<_TugasEditModal> createState() => _TugasEditModalState();
}

class _TugasEditModalState extends State<_TugasEditModal> {
  late String _status;
  late TextEditingController _timeC;
  late TextEditingController _tglTugasC; // Added
  final TextEditingController _catatanC = TextEditingController();

  final Color _teal = const Color(0xFF00C4B4);
  final Color _tealDark = const Color(0xFF089E96);
  final Color _border = const Color(0xFF00C4B4);

  @override
  void initState() {
    super.initState();
    _status = widget.status;
    _timeC = TextEditingController(text: widget.time);
    _tglTugasC = TextEditingController(
      text: _formatDisplayDate(widget.tglTugas), // Format for display
    );
    _catatanC.text = widget.catatan;
  }

  @override
  void dispose() {
    _timeC.dispose();
    _tglTugasC.dispose(); // Added
    _catatanC.dispose();
    super.dispose();
  }

  // Format date for display (e.g., dd/MM/yyyy)
  String _formatDisplayDate(String? date) {
    try {
      final parsedDate = DateFormat('yyyy-MM-dd').parse(date ?? '');
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
  }

  // Format date for submission (e.g., yyyy-MM-dd)
  String _formatSubmissionDate(String? date) {
    try {
      final parsedDate = DateFormat('dd/MM/yyyy').parse(date ?? '');
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  // Function to show the custom dropdown dialog
  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 150,
            child: Column(
              children: <Widget>[
                _buildDialogOption('Tertunda'),
                _buildDialogOption('Sudah'),
                _buildDialogOption('Belum'),
              ],
            ),
          ),
        );
      },
    );
  }

  // Dialog option item
  Widget _buildDialogOption(String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _status = value; // Update the selected value
        });
        Navigator.pop(context); // Close the dialog
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          children: [
            Image.asset(
              value == 'Sudah'
                  ? 'assets/home_assets/icons/ic_check_green.png'
                  : (value == 'Tertunda'
                      ? 'assets/home_assets/icons/ic_check_yellow.png'
                      : 'assets/home_assets/icons/ic_check_yellow.png'),
              width: 16,
              height: 16,
            ),
            SizedBox(width: 10),
            Text(
              value,
              style: AppTextStyle.medium.copyWith(
                fontSize: 16,
                color: AppColors.blackText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _pillInput({Widget? prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _border, width: 1.6),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _teal, width: 2),
      ),
    );
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final init = () {
      try {
        final parts = _timeC.text.split(':');
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      } catch (_) {
        return now;
      }
    }();
    final picked = await showTimePicker(context: context, initialTime: init);
    if (picked != null) {
      final dt = DateTime(0, 1, 1, picked.hour, picked.minute);
      _timeC.text = DateFormat('HH:mm').format(dt);
      setState(() {});
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = () {
      try {
        return DateFormat('yyyy-MM-dd').parse(widget.tglTugas);
      } catch (_) {
        return now;
      }
    }();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _tglTugasC.text = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = MediaQuery.of(context).size.width;
      final scale = (w.clamp(320, 480)) / 360;

      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 60,
          left: 16,
          right: 16,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Material(
              color: Colors.white,
              elevation: 0,
              borderRadius: BorderRadius.circular(28),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: _border, width: 1.4),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 18,
                        offset: Offset(0, 8)),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(22 * scale, 22 * scale, 22 * scale,
                      22 * scale),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon header
                      Container(
                        width: 72 * scale,
                        height: 72 * scale,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7F7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Image.asset(widget.iconPath,
                              width: 40 * scale,
                              height: 40 * scale,
                              fit: BoxFit.contain),
                        ),
                      ),
                      SizedBox(height: 14 * scale),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22 * scale,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black100),
                      ),
                      SizedBox(height: 18 * scale),

                      // Label: Status Perawatan
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Status Perawatan',
                            style: TextStyle(
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 8 * scale),

                      // Status perawatan (custom dialog)
                      GestureDetector(
                        onTap: () => _showCustomDialog(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 14 * scale, horizontal: 14 * scale),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12 * scale),
                            border: Border.all(color: _teal),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                _status == 'Sudah'
                                    ? 'assets/home_assets/icons/ic_check_green.png'
                                    : (_status == 'Tertunda'
                                        ? 'assets/home_assets/icons/ic_check_yellow.png'
                                        : 'assets/home_assets/icons/ic_check_yellow.png'),
                                width: 16 * scale,
                                height: 16 * scale,
                              ),
                              SizedBox(width: 8),
                              Text(_status,
                                  style: TextStyle(
                                      fontSize: 16 * scale,
                                      color: AppColors.black100)),
                              const Spacer(),
                              Icon(Icons.arrow_drop_down, size: 24 * scale),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 18 * scale),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Tanggal Tugas',
                            style: TextStyle(
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 8 * scale),

                      // Input: Tanggal Tugas
                      TextFormField(
                        controller: _tglTugasC,
                        readOnly: true,
                        onTap: _pickDate,
                        decoration: _pillInput(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: _pickDate,
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 16 * scale, fontWeight: FontWeight.w500),
                      ),

                      SizedBox(height: 18 * scale),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Waktu',
                            style: TextStyle(
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 8 * scale),

                      // Input: Waktu
                      TextFormField(
                        controller: _timeC,
                        readOnly: true,
                        onTap: _pickTime,
                        decoration: _pillInput(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.schedule),
                            onPressed: _pickTime,
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 16 * scale, fontWeight: FontWeight.w500),
                      ),

                      SizedBox(height: 18 * scale),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Catatan (Opsional)',
                            style: TextStyle(
                                fontSize: 14 * scale,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 8 * scale),

                      // Catatan
                      TextField(
                        controller: _catatanC,
                        maxLines: 4,
                        minLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Write a message',
                          contentPadding: const EdgeInsets.all(14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
                          ),
                        ),
                      ),

                      SizedBox(height: 22 * scale),

                      // Tombol simpan gradien
                      SizedBox(
                        width: double.infinity,
                        height: (50 * scale).clamp(46, 56),
                        child: _GradientButton(
                          text: 'Simpan Perubahan',
                          start: _teal,
                          end: _tealDark,
                          radius: 16,
                          onTap: () {
                            widget.onSave(
                              status: _status,
                              statusId: _status == 'Sudah' ? 1 : (_status == 'Tertunda' ? 2 : 3), // Map status string to ID
                              time: _timeC.text,
                              catatan: _catatanC.text.trim(),
                              tglTugas: _formatSubmissionDate(_tglTugasC.text), // Added
                            );
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final Color start, end;
  final double radius;
  final VoidCallback onTap;
  const _GradientButton({
    required this.text,
    required this.start,
    required this.end,
    required this.onTap,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [start, end]),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [
            BoxShadow(
                color: Color(0x22000000), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: Center(
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
          ),
        ),
      ),
    );
  }
}