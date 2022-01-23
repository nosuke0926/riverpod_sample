import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_sample/data/count_data.dart';
import 'package:riverpod_sample/logic/logic.dart';
import 'package:riverpod_sample/logic/sound_logic.dart';
import 'package:riverpod_sample/provider.dart';

class ViewModel {
  final Logic _logic = Logic();

  final _soundLogic = SoundLogic();

  late WidgetRef _ref; // riverpodのproviderにアクセスする用

  // 外からrefを渡す
  void setRef(WidgetRef ref) {
    _ref = ref;
    _soundLogic.load();
  }

  get count => _ref.watch(countDataProvider).count.toString();
  get countUp => _ref.watch(countDataProvider).countUp.toString();
  get countDown => _ref.watch(countDataProvider).countDown.toString();

  void onIncrease() {
    _logic.increase();
    update();
  }

  void onDecrease() {
    _logic.decrease();
    update();
  }

  void onReset() {
    _logic.reset();
    update();
  }

  void update() {
    CountData oldValue = _ref.watch(countDataProvider);
    _ref.watch(countDataProvider.state).update((state) => _logic.countData);
    CountData newValue = _ref.watch(countDataProvider);
    _soundLogic.valueChanged(oldValue, newValue);
  }
}
