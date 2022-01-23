import 'dart:async';

import 'package:golden_toolkit/golden_toolkit.dart';

// テスト実行前に読み込まれる設定ファイル
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await loadAppFonts(); // フォントの読み込み
  return testMain();
}
