import 'package:audioplayers/audioplayers.dart';

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
