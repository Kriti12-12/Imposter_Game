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
  List<int> votes = [];
  List<bool> hasVoted = [];

  int currentVoter = 0;

  @override
  void initState() {
    super.initState();
    votes = List.filled(widget.players.length, 0);
    hasVoted = List.filled(widget.players.length, false);
  }

  void vote(int targetIndex) {
    if (hasVoted[currentVoter]) return;

    setState(() {
      votes[targetIndex]++;
      hasVoted[currentVoter] = true;

      if (currentVoter < widget.players.length - 1) {
        currentVoter++;
      }
    });
  }

  void showResult() {
    int maxVotes = votes.reduce((a, b) => a > b ? a : b);

    List<int> eliminatedIndexes = [];

    for (int i = 0; i < votes.length; i++) {
      if (votes[i] == maxVotes) {
        eliminatedIndexes.add(i);
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => FinalResultScreen(
          players: widget.players,
          imposterIndexes: widget.imposterIndexes,
          eliminatedIndex: eliminatedIndexes.first,
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

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: widget.players.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: glassCard(
                          child: ListTile(
                            title: Text(
                              widget.players[index].name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "Votes: ${votes[index]}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: SizedBox(
                              width: 100,
                              height: 50,
                              child: gradientButton("Vote", () => vote(index)),
                            ),
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
                    child: gradientButton("SHOW RESULT", showResult),
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
