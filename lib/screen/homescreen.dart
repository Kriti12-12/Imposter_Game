import 'package:flutter/material.dart';
import '../ui/common.dart';
import 'dart:ui';
import '../ui/buttiondesign.dart';
import '../screen/howtoplay.dart';
import '../screen/startgame.dart';
import '../screen/category.dart';
import '../screen/settings.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/imposterbg.png', fit: BoxFit.cover),

          // overlay
          Container(color: Colors.black.withValues(alpha: .5)),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AppSpacing.h60,

                // TITLE
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

                const SizedBox(height: 50),

                Column(
                  children: [
                    gradientButton("START GAME", () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, _, _) => const Startgame(),
                          transitionsBuilder: (_, animation, _, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    gradientButton("CATEGORY", () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, _, _) => const CategorySelectio(),
                          transitionsBuilder: (_, animation, _, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    gradientButton("HOW TO PLAY", () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, _, _) => const HowToPlayScreen(),
                          transitionsBuilder: (_, animation, _, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),

                const Spacer(),
              ],
            ),
          ),

          // settings button
          Positioned(
            top: 50,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Settings(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: const Icon(Icons.settings, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
