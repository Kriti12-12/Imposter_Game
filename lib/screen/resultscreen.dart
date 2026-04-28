import 'dart:async';
import 'package:flutter/material.dart';
import '../ui/common.dart';
import '../ui/buttiondesign.dart';
import '../functions/players.dart';

class ResultScreen extends StatefulWidget {
  final List<Player> players;
  final List<int> imposterIndexes;
  final int selectedTime;

  const ResultScreen({
    super.key,
    required this.players,
    required this.imposterIndexes,
    required this.selectedTime,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late int timeLeft;
  bool showResult = false;

  Timer? timer;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    timeLeft = widget.selectedTime;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.95,
      upperBound: 1.1,
    );

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;

      if (timeLeft > 0) {
        setState(() => timeLeft--);

        if (timeLeft <= 10) {
          _controller.repeat(reverse: true);
        }
      } else {
        _showResult();
        t.cancel();
      }
    });
  }

  void _showResult() {
    setState(() => showResult = true);
    _controller.stop();
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // ⏳ TIMER
  Widget _timer() {
    final urgent = timeLeft <= 10;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.scale(
          scale: urgent ? _controller.value : 1,
          child: Text(
            "$timeLeft",
            style: TextStyle(
              color: urgent ? const Color(0xFFFF3B9A) : Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  // 😈 RESULT LIST
  Widget _imposterList() {
    return Column(
      children: widget.imposterIndexes.map((i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "😈 ${widget.players[i].name}",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      }).toList(),
    );
  }

  void _buttonAction() {
    if (showResult) {
      Navigator.popUntil(context, (r) => r.isFirst);
    } else {
      timer?.cancel();
      _showResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 🌫 FULL BACKGROUND
          Positioned.fill(
            child: BackgroundBlur(imagePath: 'images/imposterbg.png'),
          ),

          SafeArea(
            child: SizedBox.expand(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  /// 🎭 TITLE
                  GradientText(
                    showResult ? "🎭 RESULT 🎭" : "🗳️ VOTING TIME 🗳️",
                    size: 26,
                    weight: FontWeight.bold,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    showResult
                        ? "Every choice matters \n truth revealed"
                        : "Analyze carefully \n & \n find imposters",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 25),

                  /// 📦 INSTRUCTIONS
                  if (!showResult)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: glassCard(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            "🕵️ Discuss with players\n"
                            "👀 Observe behavior\n"
                            "🧠 Ask smart questions\n"
                            "🎭 Find the imposter\n"
                            "⚡ Decide before time ends\n"
                            "🎯 Vote wisely!",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 25),

                  const Text(
                    "Time Left",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 10),

                  _timer(),

                  const SizedBox(height: 25),

                  /// 😈 RESULT
                  if (showResult) ...[
                    const Text(
                      "Imposters were:",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    _imposterList(),
                  ],

                  const Spacer(),

                  /// 🔘 BUTTON
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: gradientButton(
                        showResult ? "NEW GAME" : "REVEAL",
                        _buttonAction,
                      ),
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