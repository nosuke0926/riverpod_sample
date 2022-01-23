import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_sample/main.dart';
import 'package:riverpod_sample/provider.dart';
import 'package:riverpod_sample/view_model.dart';

// Mockを継承,実際のメソッドはViewModelから引っ張ってくる
class MockViewModel extends Mock implements ViewModel {}

void main() {
  // Golden testは事前に良好な参照データを用意する必要がある
  // flutter test --update-goldens ファイルパス で生成

  const iPhone55 = Device(
    size: Size(414, 736),
    name: 'iPhone55',
    devicePixelRatio: 3,
  );
  List<Device> devices = [iPhone55];

  testGoldens('nomal', (tester) async {
    ViewModel viewModel = ViewModel();

    // pumpWidgetBuilderで実際に何を出力するかを指定
    await tester.pumpWidgetBuilder(
      ProviderScope(
        child: MyHomePage(
          viewModel,
        ),
      ),
    );

    await multiScreenGolden(
      tester,
      'myHomePage_0init',
      devices: devices,
    );

    await tester.tap(find.byIcon(CupertinoIcons.plus));
    await tester.tap(find.byIcon(CupertinoIcons.plus));
    await tester.tap(find.byIcon(CupertinoIcons.minus));
    await tester.pump();

    await multiScreenGolden(
      tester,
      'myHomePage_1tapped',
      devices: devices,
    );
  });

// テストにはモックを入れ替える or provider自体を書き換える方法がある
  testGoldens('viewModelTest', (tester) async {
    final mock = MockViewModel();
    // countを使ったときに1223456789を返すよう指定
    when(() => mock.count).thenReturn(1223456789.toString());
    when(() => mock.countUp).thenReturn(1003456789.toString());
    when(() => mock.countDown).thenReturn(20023456789.toString());

    final mockTitleProvider = Provider<String>((ref) => 'mockTitle');

    await tester.pumpWidgetBuilder(
      ProviderScope(
        child: MyHomePage(
          mock,
        ),
        // overridesでprovider自体を書き換えて内容を入れ替えることも可能
        overrides: [
          titleProvider.overrideWithProvider(mockTitleProvider),
          messageProvider.overrideWithValue('mockMessage'),
        ],
      ),
    );

    await multiScreenGolden(
      tester,
      'myHomePage_mock',
      devices: devices,
    );

    // 一度も呼び出されない事を検証
    verifyNever(() => mock.onIncrease());
    verifyNever(() => mock.onDecrease());
    verifyNever(() => mock.onReset());

    // onIncreaseが一回呼ばれたことを確認
    await tester.tap(find.byIcon(CupertinoIcons.plus));
    verify(() => mock.onIncrease()).called(1);
    verifyNever(() => mock.onDecrease());
    verifyNever(() => mock.onReset());

    await tester.tap(find.byIcon(CupertinoIcons.minus));
    verifyNever(() => mock.onIncrease());
    verify(() => mock.onDecrease()).called(1);
    verifyNever(() => mock.onReset());

    // onIncreaseが一回呼ばれたことを確認
    await tester.tap(find.byIcon(CupertinoIcons.refresh));
    verifyNever(() => mock.onIncrease());
    verifyNever(() => mock.onDecrease());
    verify(() => mock.onReset()).called(1);
  });
}
