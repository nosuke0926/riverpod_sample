import 'package:riverpod_sample/data/count_data.dart';

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
