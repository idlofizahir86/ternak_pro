import 'package:bloc/bloc.dart';

class TabTernakCubit extends Cubit<int> {
  
  TabTernakCubit([super.initial = 0]);

  void setTab(int newTab) {
    emit(newTab);  // Emit new page index when tab is changed
  }

  void setIndex(int i) => emit(i);
}
