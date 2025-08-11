import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ternak_pro/cubit/page_cubit.dart';

void main() { group('PageCubit', () { late PageCubit pageCubit;

setUp(() {
  pageCubit = PageCubit();
});

tearDown(() {
  pageCubit.close();
});

test('initial state is 0', () {
  expect(pageCubit.state, 0);
});

blocTest<PageCubit, int>(
  'emits [1] when setPage is called with index 1',
  build: () => pageCubit,
  act: (cubit) => cubit.setPage(1),
  expect: () => [1],
);

blocTest<PageCubit, int>(
  'emits [2] when setPage is called with index 2',
  build: () => pageCubit,
  act: (cubit) => cubit.setPage(2),
  expect: () => [2],
);

}); }