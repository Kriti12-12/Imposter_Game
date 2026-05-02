import 'package:flutter/material.dart';
import '../functions/players.dart';
import '../ui/common.dart';
import '../ui/buttiondesign.dart';
import '../screen/resultscreen.dart';

class VotingScreen extends StatefulWidget {
  final List<Player> players;
  final List<int> imposterIndexes;
  final int selectedTime;

  const VotingScreen({
    super.key,
    required this.players,
    required this.imposterIndexes,
    required this.selectedTime,
  });

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int currentVoter = 0;

  Map<int, Set<int>> votes = {};
  Set<int> selectedIndexes = {};

  int get imposterCount => widget.imposterIndexes.length;

  void toggleSelection(int index) {
    if (index == currentVoter) return;

    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        if (selectedIndexes.length < imposterCount) {
          selectedIndexes.add(index);
        }
      }
    });
  }

  void nextPlayer() {
    votes[currentVoter] = Set.from(selectedIndexes);

    selectedIndexes.clear();

    if (currentVoter < widget.players.length - 1) {
      setState(() {
        currentVoter++;
      });
    } else {
      showResult();
    }
  }

  void showResult() {
    Map<int, int> voteCount = {};

    votes.forEach((voter, selectedList) {
      for (var index in selectedList) {
        voteCount[index] = (voteCount[index] ?? 0) + 1;
      }
    });

    int maxVotes = voteCount.values.isNotEmpty
        ? voteCount.values.reduce((a, b) => a > b ? a : b)
        : 0;

    List<int> eliminatedIndexes = [];

    voteCount.forEach((index, count) {
      if (count == maxVotes) {
        eliminatedIndexes.add(index);
      }
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => FinalResultScreen(
          players: widget.players,
          imposterIndexes: widget.imposterIndexes,
          eliminatedIndexes: eliminatedIndexes,
        ),
      ),
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
            child: Column(
              children: [
                const SizedBox(height: 20),

                GradientText(
                  "🗳️ VOTING PHASE 🗳️",
                  size: 26,
                  weight: FontWeight.bold,
                ),

                const SizedBox(height: 10),

                Text(
                  "Now Voting: ${widget.players[currentVoter].name}",
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 5),

                Text(
                  "Select up to $imposterCount imposters",
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: widget.players.length,
                    itemBuilder: (context, index) {
                      if (index == currentVoter) {
                        return const SizedBox();
                      }

                      final isSelected = selectedIndexes.contains(index);

                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: glassCard(
                          child: ListTile(
                            title: Text(
                              widget.players[index].name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: isSelected
                                  ? Color(0xFFFF3B9A)
                                  : Colors.white70,
                            ),
                            onTap: () => toggleSelection(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: gradientButton("NEXT", nextPlayer),
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
