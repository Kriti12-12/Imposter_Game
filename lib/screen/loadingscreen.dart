import 'package:flutter/material.dart';
import '../ui/common.dart';
import '../screen/homescreen.dart';
import 'dart:ui';
import '../functions/audio_manager.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double progress = 0.0;

  Future<void> _initAudio() async {
    final audio = AudioManager();

    await audio.init();

    audio.setVolume(1.0); 
    audio.mute(false); 

    await audio.play();
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() {
            setState(() {
              progress = _controller.value;
            });
          });

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homescreen()),
          );
        });
      }
    });

    _initAudio();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildStep(String text, IconData icon, double threshold) {
    bool active = progress >= threshold;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: active ? 1 : 0.3,
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : Colors.white54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/imposterbg.png', fit: BoxFit.cover),

          Container(color: Colors.black.withValues(alpha: .5)),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AppSpacing.h60,

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      "IMPOSTER",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                        shadows: AppShadows.neonGlow,
                      ),
                    ),

                    GradientText(
                      "IMPOSTER",
                      size: 42,
                      weight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ],
                ),

                AppSpacing.h5,

                Text(
                  'CHALLENGE',
                  style: AppTextStyles.white70.copyWith(
                    letterSpacing: 4,
                    fontSize: 15,
                  ),
                ),

                const Spacer(),

                // GLASS CARD
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(24),
                        gradient: AppGradients.mainGradient,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'PARTY GAME FOR 3+ PLAYERS',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.white.copyWith(fontSize: 10),
                          ),
                          AppSpacing.h10,

                          GradientText(
                            "ONE OF THEM\nIS THE IMPOSTER",
                            size: 18,
                            weight: FontWeight.bold,
                            align: TextAlign.center,
                          ),

                          AppSpacing.h10,

                          Text(
                            'Can you find the imposter?',
                            style: AppTextStyles.white70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                AppSpacing.h100,

                // PROGRESS BELOW CARD
                Column(
                  children: [
                    GradientText(
                      progress < 0.5
                          ? "Initializing..."
                          : progress < 0.7
                          ? "Loading assets..."
                          : "Almost ready...",
                      size: 15,
                    ),
                    AppSpacing.h5,
                    Container(
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white12,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 5),
                            blurRadius: 50,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: ShaderMask(
                          shaderCallback: (bounds) =>
                              AppGradients.mainGradient.createShader(bounds),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
