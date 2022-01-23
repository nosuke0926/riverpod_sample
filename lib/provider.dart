import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_sample/data/count_data.dart';

final titleProvider = Provider<String>((ref) => 'Riverpod');
final messageProvider = Provider<String>((ref) => 'This is Riverpod sample.');

final countProvider = StateProvider<int>((ref) {
  return 0;
});

final countDataProvider = StateProvider<CountData>((ref) {
  return const CountData(
    count: 0,
    countUp: 0,
    countDown: 0,
  );
});
