import 'package:flutter/material.dart';
import '../ui/common.dart';
import '../functions/players.dart';
import '../ui/buttiondesign.dart';
import '../screen/resultscreen.dart';
import '../screen/playersscreen.dart';
import '../functions/game_storage.dart';

class Gamescreen extends StatefulWidget {
  final List<Player> players;
  final String word;
  final String hint;
  final List<int> imposterIndexes;
  final String category;
  final int selectedTime;

  final bool showCategoryToImposter;
  final bool showHintToImposter;

  const Gamescreen({
    super.key,
    required this.players,
    required this.word,
    required this.hint,
    required this.imposterIndexes,
    required this.category,
    required this.showCategoryToImposter,
    required this.showHintToImposter,
    required this.selectedTime,
  });

  @override
  State<Gamescreen> createState() => _GamescreenState();
}

class _GamescreenState extends State<Gamescreen> {
  int index = 0;
  bool revealed = false;

  late List<Player> players;

  @override
  void initState() {
    super.initState();
    players = [];

    _loadPlayers();
  }

  void _loadPlayers() async {
    final savedPlayers = await GameStorage.loadPlayers();

    setState(() {
      players = savedPlayers.isNotEmpty
          ? savedPlayers
          : List.from(widget.players);
    });
  }

  bool get isLast => index == players.length - 1;

  bool isImposter(int i) => widget.imposterIndexes.contains(i);

  void reveal() {
    setState(() => revealed = true);
  }

  // 🔥 OPEN PLAYER SCREEN
  void openPlayersScreen() async {
    final updatedPlayers = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlayersScreen(players: players)),
    );

    if (updatedPlayers != null) {
      setState(() {
        players = updatedPlayers;

        // safety reset
        if (index >= players.length) {
          index = 0;
        }

        revealed = false;
      });
    }
  }

  void nextPlayer() {
    if (isLast) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      index++;
      revealed = false;
    });
  }

  // 🌟 FRONT
  Widget frontCard(Player p) {
    return glassCard(
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(p.avatar, color: Colors.white, size: 55),
            const SizedBox(height: 15),
            Text(p.name, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            const Text(
              "Don’t show this to others 🤫",
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tap to reveal",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 BACK
  Widget backCard(Player p, bool imp) {
    final showCategory = widget.showCategoryToImposter;
    final showHint = widget.showHintToImposter;

    return glassCard(
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imp)
              const Text(
                "😈 YOU ARE IMPOSTER",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 14),

            if (!imp)
              Text(
                widget.word,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 12),

            if (imp && showCategory)
              Text(
                "Category: ${widget.category}",
                style: const TextStyle(color: Colors.white70),
              ),

            const SizedBox(height: 8),

            if (imp && showHint)
              Text(
                "Hint: ${widget.hint}",
                style: const TextStyle(color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }

  Widget cardView(Player p, int i) {
    final imp = isImposter(i);

    return GestureDetector(
      onTap: revealed ? null : reveal,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: revealed ? backCard(p, imp) : frontCard(p),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = players[index];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          BackgroundBlur(imagePath: 'images/imposterbg.png'),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                const GradientText(
                  "IMPOSTER GAME",
                  size: 28,
                  weight: FontWeight.bold,
                ),

                const SizedBox(height: 10),

                // 👇 Hidden trigger (no UI change visually)
                GestureDetector(
                  onLongPress: openPlayersScreen,
                  child: Text(
                    "Player ${index + 1}/${players.length}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      cardView(player, index),

                      const SizedBox(height: 15),

                      gradientButton(isLast ? "SEE RESULT" : "GOT IT", () {
                        if (isLast) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ResultScreen(
                                players: players,
                                imposterIndexes: widget.imposterIndexes,
                                selectedTime: widget.selectedTime,
                              ),
                            ),
                          );
                        } else {
                          nextPlayer();
                        }
                      }),
                    ],
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
