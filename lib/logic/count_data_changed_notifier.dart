import 'package:riverpod_sample/data/count_data.dart';

// typedefで関数型に別名の型をつけることが可能
typedef ValueChangedCondition = bool Function(
  CountData oldData,
  CountData newData,
);

abstract class CountDataChangedNotifier {
  valueChanged(
    CountData oldData,
    CountData newData,
  );
}
