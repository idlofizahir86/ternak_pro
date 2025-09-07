import 'package:bloc/bloc.dart';

// State untuk menyimpan nilai bulan
class MonthState {
  final int selectedMonth;

  MonthState(this.selectedMonth);
}

// Cubit untuk mengelola nilai bulan
class MonthCubit extends Cubit<MonthState> {
  MonthCubit() : super(MonthState(DateTime.now().month));  // Inisialisasi dengan bulan saat ini

  // Fungsi untuk mengubah bulan
  void changeMonth(int newMonth) {
    emit(MonthState(newMonth));  // Mengubah state dengan bulan yang baru
  }
}
