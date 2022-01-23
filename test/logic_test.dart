import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_sample/logic/logic.dart';

void main() {
  Logic target = Logic();
  // テストが実行される前に実行する内容を記載
  setUp(() async {
    target = Logic(); // 毎回初期化
  });

  test('init', () async {
    expect(target.countData.count, 0);
    expect(target.countData.countUp, 0);
    expect(target.countData.countDown, 0);
  });
  test('increase', () async {
    target.increase();
    expect(target.countData.count, 1);
    expect(target.countData.countUp, 1);
    expect(target.countData.countDown, 0);
  });
  test('decrease', () async {
    target.decrease();
    expect(target.countData.count, -1);
    expect(target.countData.countUp, 0);
    expect(target.countData.countDown, 1);

    target.decrease();
    target.decrease();

    expect(target.countData.count, -3);
    expect(target.countData.countUp, 0);
    expect(target.countData.countDown, 3);
  });
  test('reset', () async {
    expect(target.countData.count, 0);
    expect(target.countData.countUp, 0);
    expect(target.countData.countDown, 0);

    target.increase();
    target.decrease();
    target.decrease();

    expect(target.countData.count, -1);
    expect(target.countData.countUp, 1);
    expect(target.countData.countDown, 2);

    target.reset();
    expect(target.countData.count, 0);
    expect(target.countData.countUp, 0);
    expect(target.countData.countDown, 0);
  });
}
