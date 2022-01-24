import 'package:flutter/material.dart';
import 'package:riverpod_sample/data/count_data.dart';
import 'package:riverpod_sample/logic/count_data_changed_notifier.dart';
import 'dart:math' as math;

class ButtonAnimationLogic with CountDataChangedNotifier {
  late AnimationController _animationController;
  late Animation<double> _animationScale; // 拡大縮小のアニメーション
  late Animation<double> _animationRotation; // 回転のアニメーション

  late AnimationCombination _animationCombination;

  get animationCombination => _animationCombination;

  ValueChangedCondition startCondition;

  // どのWidgetに対してAnimationするかを引数に指定（Stateful Widgetを渡す）
  ButtonAnimationLogic(TickerProvider tickerProvider, this.startCondition) {
    _animationController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 500),
    );

    // 拡大縮小を設定
    _animationScale = _animationController
        .drive(
          CurveTween(
            curve: const Interval(0.1, 0.7),
          ), // どの区間でアニメーションを行うか（500msの10%でアニメーションが始まり、70%目で終わる）
        )
        .drive(
          Tween(begin: 1, end: 1.8), // どんな感じで変化するかを記述
        );

    _animationRotation = _animationController
        .drive(
          CurveTween(
            curve: Interval(0.4, 1, curve: ButtonRotateCurve()),
          ), // どの区間でアニメーションを行うか
        )
        .drive(
          Tween(begin: 0, end: 1), // どんな感じで変化するかを記述
        );

    _animationCombination =
        AnimationCombination(_animationScale, _animationRotation);
  }

  void dispose() {
    _animationController.dispose();
  }

  void start() {
    _animationController.forward().whenComplete(
          () => _animationController.reset(),
        );
  }

  @override
  void valueChanged(
    CountData oldData,
    CountData newData,
  ) {
    if (startCondition(oldData, newData)) {
      start();
    }
  }
}

class ButtonRotateCurve extends Curve {
  @override
  double transform(double t) {
    return math.sin(2 * math.pi * t) / 12;
  }
}

class AnimationCombination {
  final Animation<double> animationScale; // 拡大縮小のアニメーション
  final Animation<double> animationRotation; // 回転のアニメーション
  AnimationCombination(
    this.animationScale,
    this.animationRotation,
  );
}
