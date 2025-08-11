import 'package:bloc/bloc.dart';

class TabKeuanganCubit extends Cubit<int> {
  
  TabKeuanganCubit([super.initial = 0]);

  void setKeuanganTab(int newTab) {
    emit(newTab);  // Emit new page index when tab is changed
  }

  void setKeuanganIndex(int i) => emit(i);
}
