import 'dart:async';
import 'package:flutter/material.dart';
import '../ui/common.dart';
import '../ui/buttiondesign.dart';
import '../functions/players.dart';
import 'votingscreen.dart';

class GameTimerScreen extends StatefulWidget {
  final List<Player> players;
  final List<int> imposterIndexes;
  final int selectedTime;

  const GameTimerScreen({
    super.key,
    required this.players,
    required this.imposterIndexes,
    required this.selectedTime,
  });

  @override
  State<GameTimerScreen> createState() => _GameTimerScreenState();
}

class _GameTimerScreenState extends State<GameTimerScreen>
    with SingleTickerProviderStateMixin {
  late int timeLeft;
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
      }
    });
  }

  void goToVoting() {
    timer?.cancel();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VotingScreen(
          players: widget.players,
          imposterIndexes: widget.imposterIndexes,
          selectedTime: widget.selectedTime,
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

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
                  const SizedBox(height: 20),

                  GradientText(
                    "⏳ DISCUSSION TIME ⏳",
                    size: 26,
                    weight: FontWeight.bold,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Talk, analyze and decide wisely",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Time Left",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 10),

                  _timer(),

                  const SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: gradientButton("🗳️ VOTE", goToVoting),
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
