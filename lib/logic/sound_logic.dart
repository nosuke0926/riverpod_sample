import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_sample/data/count_data.dart';

class SoundLogic {
  static const soundDataUp = 'assets/sounds/up.mp3';
  static const soundDataDown = 'assets/sounds/down.mp3';
  static const soundDataReset = 'assets/sounds/reset.mp3';

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
