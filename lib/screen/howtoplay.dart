import 'package:flutter/material.dart';
import '../ui/common.dart';
import '../screen/homescreen.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  BackgroundBlur(
                    imagePath: 
                        'images/imposterbg.png',
                    blurSigma: 20, 
                    opacity: 0.4,
                  ),
                ],
              ),
            ),
          ),

          /// 📜 CONTENT
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AppSpacing.h20,

                  GradientText(
                    "HOW TO PLAY",
                    size: 42,
                    weight: FontWeight.bold,
                    letterSpacing: 2,
                  ),

                  AppSpacing.h30,

                  /// 🧊 CARD 1
                  glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        sectionTitle("Role Distribution"),
                        AppSpacing.h10,
                        bullet("Each player receives a hidden role"),
                        bullet("Most players get the same word"),
                        bullet("One player is the Imposter"),
                        bullet("Imposter does NOT know the word"),
                      ],
                    ),
                  ),

                  AppSpacing.h16,

                  /// 🧊 CARD 2
                  glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        sectionTitle("Questions & Answers"),
                        AppSpacing.h10,
                        bullet("Players take turns asking questions"),
                        bullet("Answer carefully"),
                        bullet("Observe others"),
                      ],
                    ),
                  ),

                  AppSpacing.h16,

                  /// 🧊 CARD 3
                  glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        sectionTitle("Final Move"),
                        AppSpacing.h10,
                        bullet("Discuss suspicious players"),
                        bullet("Vote to eliminate"),
                        bullet("Find the Imposter"),
                      ],
                    ),
                  ),

                  AppSpacing.h16,

                  /// 🧊 CARD 4
                  glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        sectionTitle("💡 Pro Tip"),
                        AppSpacing.h10,
                        bullet("Be smart, not obvious"),
                        bullet("Blend in if you're the Imposter"),
                        bullet("Watch reactions"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ❌ CLOSE BUTTON
          Positioned(
            top: 50,
            left: 20,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Homescreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}