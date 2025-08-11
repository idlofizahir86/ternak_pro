import 'package:bloc/bloc.dart';

class KonsultasiPageCubit extends Cubit<int> {
  
  KonsultasiPageCubit([super.initial = 0]);

  void setKonsultasiPage(int newPage) {
    emit(newPage);  // Emit new page index when tab is changed
  }

  void setIndex(int i) => emit(i);
}
