import 'package:just_audio/just_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _clickPlayer = AudioPlayer();

  double volume = 1.0;
  bool isMuted = false;
  bool clickSoundEnabled = true;

  bool _initialized = false;

  // 🎧 INIT AUDIO
  Future<void> init() async {
    if (_initialized) return;

    try {
      // BACKGROUND MUSIC
      await _bgPlayer.setLoopMode(LoopMode.one);
      await _bgPlayer.setVolume(volume);
      await _bgPlayer.setAsset('assets/audio/bgmusic.mp3');

      // CLICK SOUND
      await _clickPlayer.setAsset('assets/audio/click.mp3');
      await _clickPlayer.setVolume(volume);

      _initialized = true;

      print("✅ Audio initialized");
    } catch (e) {
      print("❌ Audio init error: $e");
    }
  }

  // 🎵 BACKGROUND PLAY
  Future<void> play() async {
    if (isMuted) return;

    try {
      await _bgPlayer.setVolume(volume);
      await _bgPlayer.play();
    } catch (e) {
      print("BG play error: $e");
    }
  }

  Future<void> pause() async => _bgPlayer.pause();
  Future<void> stop() async => _bgPlayer.stop();

  // 🔊 VOLUME CONTROL
  void setVolume(double v) {
    volume = v;
    _bgPlayer.setVolume(v);
    _clickPlayer.setVolume(v);
  }

  // 🔇 MUTE
  void mute(bool value) {
    isMuted = value;
    _bgPlayer.setVolume(value ? 0 : volume);
  }

  // 🎯 CLICK SOUND (IMPORTANT FIXED VERSION)
  Future<void> playClick() async {
    if (!clickSoundEnabled || isMuted) return;

    try {
      await _clickPlayer.stop();
      await _clickPlayer.seek(Duration.zero);
      await _clickPlayer.setVolume(volume);
      await _clickPlayer.play();
    } catch (e) {
      print("❌ Click sound error: $e");
    }
  }

  void toggleClick(bool value) {
    clickSoundEnabled = value;
  }
}
