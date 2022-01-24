import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_sample/provider.dart';
import 'package:riverpod_sample/view_model.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(ViewModel()),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  // テストのためにViewModelは外から入れる（テストの方法としてはRiverpodを書き換える場合もある）
  const MyHomePage(
    this.viewModel, {
    Key? key,
  }) : super(key: key);

  final ViewModel viewModel;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage>
    with TickerProviderStateMixin {
  late ViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = widget.viewModel;
    _viewModel.setRef(ref, this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(titleProvider)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ref.watch(messageProvider),
            ),
            Text(
              _viewModel.count,
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // プラスボタン
                FloatingActionButton(
                  onPressed: _viewModel.onIncrease,
                  child: ScaleTransition(
                    scale: _viewModel.animationPlus,
                    child: const Icon(
                      CupertinoIcons.plus,
                    ),
                  ),
                ),

                // マイナスボタン
                FloatingActionButton(
                  onPressed: _viewModel.onDecrease,
                  child: ScaleTransition(
                    scale: _viewModel.animationMinus,
                    child: const Icon(
                      CupertinoIcons.minus,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(_viewModel.countUp),
                Text(_viewModel.countDown),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewModel.onReset,
        child: ScaleTransition(
          scale: _viewModel.animationReset,
          child: const Icon(
            CupertinoIcons.refresh,
          ),
        ),
      ),
    );
  }
}
