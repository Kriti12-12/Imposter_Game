import 'package:flutter/material.dart';
import '../functions/players.dart';
import '../ui/common.dart';
import '../ui/buttiondesign.dart';

class FinalResultScreen extends StatelessWidget {
  final List<Player> players;
  final List<int> imposterIndexes;
  final List<int> eliminatedIndexes; // 👈 change here

  const FinalResultScreen({
    super.key,
    required this.players,
    required this.imposterIndexes,
    required this.eliminatedIndexes,
  });

  List<String> get imposterNames =>
      imposterIndexes.map((i) => players[i].name).toList();

  List<String> get eliminatedNames =>
      eliminatedIndexes.map((i) => players[i].name).toList();

  int get correctCatches {
    int count = 0;
    for (var i in eliminatedIndexes) {
      if (imposterIndexes.contains(i)) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    String resultText;
    Color resultColor;

    if (correctCatches == imposterIndexes.length) {
      resultText = "🎉 All imposters caught!";
      resultColor = const Color(0xFF00D1FF);
    } else if (correctCatches > 0) {
      resultText = "😐 You caught $correctCatches imposter(s)";
      resultColor = Color(0xFF7B61FF);
    } else {
      resultText = "💀 All imposters escaped!";
      resultColor = const Color(0xFFFF3B9A);
    }

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
                  GradientText(
                    "🎭 RESULT 🎭",
                    size: 30,
                    weight: FontWeight.bold,
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Eliminated: ${eliminatedNames.join(', ')}",
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
                    resultText,
                    style: TextStyle(
                      color: resultColor,
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
