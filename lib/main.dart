import 'package:flutter/material.dart';
import 'screen/loadingscreen.dart';
import 'functions/audio_manager.dart';
import 'functions/game_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AudioManager().init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final audio = AudioManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    audio.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      audio.pause();
    } else if (state == AppLifecycleState.resumed) {
      _resumeAudio();
    }
  }

  Future<void> _resumeAudio() async {
    final settings = await GameStorage.loadAudioSettings();

    if (settings["isMuted"] == true) return;

    audio.setVolume(settings["volume"]);
    audio.play();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}
