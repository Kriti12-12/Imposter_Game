import 'package:flutter/material.dart';
import '../functions/players.dart';
import '../ui/common.dart';
import '../ui/buttiondesign.dart';

class FinalResultScreen extends StatelessWidget {
  final List<Player> players;
  final List<int> imposterIndexes;
  final int eliminatedIndex;

  const FinalResultScreen({
    super.key,
    required this.players,
    required this.imposterIndexes,
    required this.eliminatedIndex,
  });

  bool get isCorrectCatch => imposterIndexes.contains(eliminatedIndex);

  List<String> get imposterNames =>
      imposterIndexes.map((i) => players[i].name).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackgroundBlur(imagePath: 'images/imposterbg.png'),
          ),

          SafeArea(
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GradientText("🎭 RESULT", size: 30, weight: FontWeight.bold),

                  const SizedBox(height: 30),

                  Text(
                    "Eliminated: ${players[eliminatedIndex].name}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Imposters were: ${imposterNames.join(', ')}",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    isCorrectCatch
                        ? "🎉 You caught the Imposter!"
                        : "😵 Wrong vote!",
                    style: TextStyle(
                      color: isCorrectCatch
                          ? Color(0xFF00D1FF)
                          : Color(0xFFFF3B9A),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 50),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: gradientButton(
                      "NEW GAME",
                      () => Navigator.popUntil(context, (r) => r.isFirst),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
