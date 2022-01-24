import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_sample/data/count_data.dart';
import 'package:riverpod_sample/logic/button_animation_logic.dart';
import 'package:riverpod_sample/logic/count_data_changed_notifier.dart';
import 'package:riverpod_sample/logic/logic.dart';
import 'package:riverpod_sample/logic/sound_logic.dart';
import 'package:riverpod_sample/provider.dart';

class ViewModel {
  final Logic _logic = Logic();

  final _soundLogic = SoundLogic();
  late ButtonAnimationLogic _buttonAnimationLogicPlus;
  late ButtonAnimationLogic _buttonAnimationLogicMinus;
  late ButtonAnimationLogic _buttonAnimationLogicReset;

  late WidgetRef _ref; // riverpodのproviderにアクセスする用

  List<CountDataChangedNotifier> notifiers = [];

  // 外からrefを渡す
  void setRef(
    WidgetRef ref,
    TickerProvider tickerProvider,
  ) {
    _ref = ref;

    _buttonAnimationLogicPlus = ButtonAnimationLogic(
      tickerProvider,
      (oldData, newData) => oldData.countUp + 1 == newData.countUp,
    );
    _buttonAnimationLogicMinus = ButtonAnimationLogic(
      tickerProvider,
      (CountData oldData, CountData newData) {
        return oldData.countDown + 1 == newData.countDown;
      },
    );
    _buttonAnimationLogicReset = ButtonAnimationLogic(
      tickerProvider,
      (oldData, newData) => newData.countUp == 0 && newData.countDown == 0,
    );
    _soundLogic.load();

    notifiers = [
      _soundLogic,
      _buttonAnimationLogicPlus,
      _buttonAnimationLogicMinus,
      _buttonAnimationLogicReset
    ];
  }

  get count => _ref.watch(countDataProvider).count.toString();
  get countUp => _ref.watch(countDataProvider).countUp.toString();
  get countDown => _ref.watch(countDataProvider).countDown.toString();

  get animationPlusCombination =>
      _buttonAnimationLogicPlus.animationCombination;

  get animationMinusCombination =>
      _buttonAnimationLogicMinus.animationCombination;

  get animationResetCombination =>
      _buttonAnimationLogicReset.animationCombination;

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

    notifiers.forEach((element) => element.valueChanged(oldValue, newValue));
  }
}
