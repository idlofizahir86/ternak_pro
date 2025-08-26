import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ternak_pro/shared/custom_loading.dart';
import '../../../models/KeuanganItem.dart';
import '../../../services/api_service.dart';
import '../../theme.dart'; // Sesuaikan path ke model KeuanganItem

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

  // Konversi dari KeuanganItem ke FinanceRecord
  factory FinanceRecord.fromKeuanganItem(KeuanganItem item) {
    return FinanceRecord(
      date: item.tglKeuangan,
      title: item.dariTujuan.isNotEmpty ? item.dariTujuan : 'Transaksi',
      subtitle: item.namaAset.isNotEmpty ? item.namaAset : (item.catatan.isNotEmpty ? item.catatan : 'Tanpa catatan'),
      amount: item.nominalTotal,
      type: item.isPengeluaran ? TxType.expense : TxType.income,
    );
  }
}

// ---------- WIDGET SECTION ----------
class KeuanganRiwayatSection extends StatefulWidget {
  const KeuanganRiwayatSection({super.key});

  @override
  State<KeuanganRiwayatSection> createState() => _KeuanganRiwayatSectionState();
}

class _KeuanganRiwayatSectionState extends State<KeuanganRiwayatSection> {
  final ApiService _apiService = ApiService();
  late int _selectedMonth;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now().month;
    _selectedYear = DateTime.now().year;
  }

  String _formatMonthYear(int m, int y) {
    final date = DateTime(y, m, 1);
    return DateFormat('MMM yyyy', 'id_ID').format(date);
  }

  Future<void> _pickMonthYear() async {
    int tempMonth = _selectedMonth;
    int tempYear = _selectedYear;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Pilih Bulan'),
          content: Row(
            children: [
              Expanded(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: tempMonth,
                  items: List.generate(12, (i) => i + 1)
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(DateFormat('MMM', 'id_ID').format(DateTime(2000, m, 1))),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => tempMonth = val);
                    (ctx as Element).markNeedsBuild();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: tempYear,
                  items: List.generate(11, (i) => (_selectedYear - 5) + i)
                      .map((y) => DropdownMenuItem(value: y, child: Text(y.toString())))
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

  Future<List<FinanceRecord>> _fetchKeuanganData() async {
    final credential = await _apiService.loadCredentials();
    final userId = credential['user_id'];
    final keuanganItems = await _apiService.getDataKeuanganUser(userId);
    return keuanganItems.map((item) => FinanceRecord.fromKeuanganItem(item)).toList();
  }

  List<FinanceRecord> _filtered(List<FinanceRecord> items) {
    return items
        .where((e) => e.date.month == _selectedMonth && e.date.year == _selectedYear)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
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
        // LIST
        FutureBuilder<List<FinanceRecord>>(
          future: _fetchKeuanganData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: TernakProBoxLoading()),
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Text('Error: ${snapshot.error}', style: AppTextStyle.regular.copyWith(color: AppColors.greyText)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => setState(() {}), // Refresh FutureBuilder
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Tidak ada catatan untuk bulan ini.',
                  style: AppTextStyle.regular.copyWith(color: AppColors.greyText),
                ),
              );
            }

            final items = _filtered(snapshot.data!);

            return ListView.separated(
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
                      width: 36,
                      height: 36,
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
                          Text(
                            it.title,
                            style: AppTextStyle.semiBold.copyWith(fontSize: 16),
                          ),
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
            );
          },
        ),
        const SizedBox(height: 8),
        const Divider(color: AppColors.divider, height: 16),
      ],
    );
  }
}