import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme.dart';

// ---------- MODEL ----------
enum TxType { income, expense }

class FinanceRecord {
  final DateTime date;
  final String title;
  final String subtitle;
  final int amount; // rupiah (positif)
  final TxType type;

  const FinanceRecord({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
  });
}

// ---------- WIDGET SECTION ----------
class KeuanganRiwayatSection extends StatefulWidget {
  const KeuanganRiwayatSection({super.key});

  @override
  State<KeuanganRiwayatSection> createState() => _KeuanganRiwayatSectionState();
}

class _KeuanganRiwayatSectionState extends State<KeuanganRiwayatSection> {
  // dummy data (beberapa bulan supaya filter kebukti)
  final List<FinanceRecord> _all = [
    // Feb 2025
    FinanceRecord(
      date: DateTime(2025, 2, 7),
      title: 'Beli Pakan Ternak',
      subtitle: 'Pakan Dedak Konsentrat Sapi',
      amount: 1200000,
      type: TxType.expense,
    ),
    FinanceRecord(
      date: DateTime(2025, 2, 8),
      title: 'Hasil Penjualan Susu',
      subtitle: 'Susu Sapi Perah',
      amount: 6000000,
      type: TxType.income,
    ),
    FinanceRecord(
      date: DateTime(2025, 2, 11),
      title: 'Vitamin Ternak',
      subtitle: 'Vitamin A & Mineral',
      amount: 240000,
      type: TxType.expense,
    ),
    FinanceRecord(
      date: DateTime(2025, 2, 15),
      title: 'Jual Anak Sapi',
      subtitle: 'Sapi PO umur 6 bulan',
      amount: 3500000,
      type: TxType.income,
    ),
    // Jan 2025
    FinanceRecord(
      date: DateTime(2025, 1, 12),
      title: 'Beli Jerami',
      subtitle: 'Jerami Kering 100 Ikat',
      amount: 800000,
      type: TxType.expense,
    ),
    FinanceRecord(
      date: DateTime(2025, 1, 20),
      title: 'Penjualan Kotoran Sapi',
      subtitle: 'Pupuk Organik 300 Kg',
      amount: 900000,
      type: TxType.income,
    ),
    // Mar 2025
    FinanceRecord(
      date: DateTime(2025, 3, 2),
      title: 'Perbaikan Kandang',
      subtitle: 'Per kayu & atap seng',
      amount: 1100000,
      type: TxType.expense,
    ),
    FinanceRecord(
      date: DateTime(2025, 3, 9),
      title: 'Hasil Penjualan Susu',
      subtitle: 'Susu Sapi Perah',
      amount: 5200000,
      type: TxType.income,
    ),
  ];

  late int _selectedMonth;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    // default: bulan berjalan (atau set ke 2/2025 kalau mau persis contoh)
    _selectedMonth = 2; // now.month;
    _selectedYear = 2025; // now.year;
  }

  String _formatMonthYear(int m, int y) {
    final date = DateTime(y, m, 1);
    return DateFormat('MMM yyyy', 'id_ID').format(date); // “Feb 2025”
  }

  Future<void> _pickMonthYear() async {
    // dialog sederhana: pilih bulan & tahun
    int tempMonth = _selectedMonth;
    int tempYear = _selectedYear;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Pilih Bulan'),
          content: Row(
            children: [
              // Dropdown bulan
              Expanded(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: tempMonth,
                  items: List.generate(12, (i) => i + 1)
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(DateFormat('MMM', 'id_ID')
                                .format(DateTime(2000, m, 1))),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => tempMonth = val);
                    // paksa rebuild dialog
                    (ctx as Element).markNeedsBuild();
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Dropdown tahun (range ±5 tahun)
              Expanded(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: tempYear,
                  items: List.generate(11, (i) => (_selectedYear - 5) + i)
                      .map((y) =>
                          DropdownMenuItem(value: y, child: Text(y.toString())))
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => tempYear = val);
                    (ctx as Element).markNeedsBuild();
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _selectedMonth = tempMonth;
                  _selectedYear = tempYear;
                });
                Navigator.pop(ctx);
              },
              child: const Text('Pilih'),
            ),
          ],
        );
      },
    );
  }

  List<FinanceRecord> get _filtered {
    return _all
        .where((e) => e.date.month == _selectedMonth && e.date.year == _selectedYear)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date)); // urut tanggal naik (sesuai contoh)
  }

  String _fmtDate(DateTime d) => DateFormat('dd MMM yyyy', 'id_ID').format(d);

  String _fmtRupiah(int v, {bool withSign = true, required TxType type}) {
    final f = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
    final s = f.format(v);
    if (!withSign) return s;
    return type == TxType.income ? '+$s' : '-$s';
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Row(
          children: [
            Text(
              'Riwayat',
              style: AppTextStyle.semiBold.copyWith(fontSize: 16),
            ),
            const Spacer(),
            InkWell(
              onTap: _pickMonthYear,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatMonthYear(_selectedMonth, _selectedYear),
                    style: AppTextStyle.semiBold.copyWith(fontSize: 16, color: Colors.teal),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                ],
              ),
            ),
          ],
        ),
        // const SizedBox(height: 8),

        // LIST
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Tidak ada catatan untuk bulan ini.',
              style: AppTextStyle.regular.copyWith(color: AppColors.greyText),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(color: AppColors.divider, height: 16),
            itemBuilder: (_, i) {
              final it = items[i];
              final isIncome = it.type == TxType.income;
              final color = isIncome ? AppColors.blue : AppColors.red;
              final chipBg = isIncome ? AppColors.chipBgBlue : AppColors.chipBgRed;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // leading icon
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: chipBg, shape: BoxShape.circle),
                    child: Center(
                      child: Image.asset(
                      it.type == TxType.income  
                          ? 'assets/keuangan_assets/icons/ic_wallet.png'
                          : 'assets/keuangan_assets/icons/ic_cart.png',
                      width: 18,
                      height: 18,
                      fit: BoxFit.contain,
                    ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // title & subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(it.title,
                            style: AppTextStyle.semiBold.copyWith(fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(
                          it.subtitle,
                          style: AppTextStyle.regular.copyWith(
                            color: AppColors.greyText,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // right: date & amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _fmtDate(it.date),
                        style: AppTextStyle.regular.copyWith(
                          color: AppColors.greyText,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _fmtRupiah(it.amount, type: it.type),
                        style: AppTextStyle.semiBold.copyWith(
                          color: color,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

        const SizedBox(height: 8),
        const Divider(color: AppColors.divider, height: 16),
      ],
    );
  }
}
