import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_sample/data/count_data.dart';
import 'package:riverpod_sample/logic/count_data_changed_notifier.dart';

class SoundLogic with CountDataChangedNotifier {
  static const soundDataUp = 'sounds/up.mp3';
  static const soundDataDown = 'sounds/down.mp3';
  static const soundDataReset = 'sounds/reset.mp3';

  final AudioCache _cache = AudioCache(
    fixedPlayer: AudioPlayer(),
  );

  void load() {
    _cache.loadAll([
      soundDataUp,
      soundDataDown,
      soundDataReset,
    ]);
  }

  @override
  void valueChanged(
    CountData oldData,
    CountData newData,
  ) {
    if (newData.countUp == 0 && newData.countDown == 0) {
      playResetSound();
    } else if (oldData.countUp + 1 == newData.countUp) {
      playUpSound();
    } else if (oldData.countDown + 1 == newData.countDown) {
      playDownSound();
    }
  }

  void playUpSound() {
    _cache.play(soundDataUp);
  }

  void playDownSound() {
    _cache.play(soundDataDown);
  }

  void playResetSound() {
    _cache.play(soundDataReset);
  }
}
