import 'package:bloc/bloc.dart';

// State untuk menyimpan nilai bulan
class YearState {
  final int selectedYear;

  YearState(this.selectedYear);
}

// Cubit untuk mengelola nilai bulan
class YearCubit extends Cubit<YearState> {
  YearCubit() : super(YearState(DateTime.now().year));  // Inisialisasi dengan bulan saat ini

  // Fungsi untuk mengubah bulan
  void changeYear(int newYear) {
    emit(YearState(newYear));  // Mengubah state dengan bulan yang baru
  }
}
