import 'package:flutter/material.dart';
import '../ui/common.dart';
import '../functions/audio_manager.dart';
import '../functions/game_storage.dart';
import '../screen/homescreen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final audio = AudioManager();

    return Scaffold(
      body: Stack(
        children: [
          BackgroundBlur(
            imagePath: 'images/imposterbg.png',
            blurSigma: 20,
            opacity: 0.4,
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔙 HEADER (UNCHANGED)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Homescreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            child: const Icon(
                              Icons.arrow_left_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      AppSpacing.h10,

                      Center(
                        child: GradientText(
                          "SETTINGS",
                          size: 30,
                          weight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                AppSpacing.h30,

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: const [
                      Icon(Icons.volume_up, color: Colors.white70),
                      SizedBox(width: 10),
                      Text(
                        "Audio Settings",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                AppSpacing.h10,

                // 🎧 MUSIC SETTINGS CARD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: glassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // 🔇 MUTE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.volume_off, color: Colors.white70),
                                  SizedBox(width: 10),
                                  Text(
                                    "Mute",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),

                              Switch(
                                value: audio.isMuted,
                                activeColor: const Color(0xFFFF3B9A),
                                onChanged: (value) {
                                  setState(() {
                                    audio.mute(value);

                                    GameStorage.saveAudioSettings(
                                      volume: audio.volume,
                                      isMuted: value,
                                      clickSound: audio.clickSoundEnabled,
                                    );
                                  });
                                },
                              ),
                            ],
                          ),

                          AppSpacing.h20,

                          // 🎚️ VOLUME SLIDER (UNCHANGED UI)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Volume :",
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 12),

                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = constraints.maxWidth;

                                  return Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Container(
                                        height: 4,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          color: Colors.white24,
                                        ),
                                      ),

                                      Container(
                                        height: 4,
                                        width: width * audio.volume,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          gradient: AppGradients.mainGradient,
                                        ),
                                      ),

                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackHeight: 0,
                                          activeTrackColor: Colors.transparent,
                                          inactiveTrackColor:
                                              Colors.transparent,
                                          thumbColor: Colors.white70,
                                          overlayColor: const Color(
                                            0xFFFF3B9A,
                                          ).withValues(alpha: 0.2),
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                enabledThumbRadius: 8,
                                              ),
                                        ),
                                        child: Slider(
                                          value: audio.volume,
                                          min: 0,
                                          max: 1,
                                          onChanged: (value) {
                                            setState(() {
                                              audio.setVolume(value);

                                              GameStorage.saveAudioSettings(
                                                volume: value,
                                                isMuted: audio.isMuted,
                                                clickSound:
                                                    audio.clickSoundEnabled,
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                AppSpacing.h20,

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: const [
                      Icon(Icons.touch_app, color: Colors.white70),
                      SizedBox(width: 10),
                      Text(
                        "Button Audio Settings",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                AppSpacing.h10,

                // 🔘 CLICK SOUND SETTINGS (SEPARATE CARD)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: glassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Text(
                                "Button Sound",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),

                          Switch(
                            value: audio.clickSoundEnabled,
                            activeColor: const Color(0xFFFF3B9A),
                            onChanged: (value) {
                              setState(() {
                                audio.toggleClick(value);

                                GameStorage.saveAudioSettings(
                                  volume: audio.volume,
                                  isMuted: audio.isMuted,
                                  clickSound: value,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
