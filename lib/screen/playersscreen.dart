import 'package:flutter/material.dart';
import '../functions/players.dart';
import '../ui/common.dart';
import '../ui/buttiondesign.dart';
import '../functions/startgamefunctions.dart';
import '../functions/game_storage.dart';

class PlayersScreen extends StatefulWidget {
  final List<Player> players;

  const PlayersScreen({super.key, required this.players});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  late List<Player> players;

  @override
  void initState() {
    super.initState();
    players = [];

    _loadPlayers();
  }

  void _loadPlayers() async {
    final saved = await GameStorage.loadPlayers();

    if (saved.isNotEmpty) {
      setState(() {
        players = saved;
      });
    } else {
      players = List<Player>.from(widget.players);
    }
  }

  // ➕ ADD
  void _addPlayer() async {
    final name = await openAddPlayerSheet(context);

    if (name != null && name.trim().isNotEmpty) {
      setState(() {
        players.add(Player(name: name.trim(), avatar: Icons.face));
      });
    }
  }

  // ✏️ EDIT
  void _editPlayer(int index) async {
    final result = await openEditPlayerDialog(context, players[index].name);

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        players[index] = Player(
          name: result.trim(),
          avatar: players[index].avatar,
        );
      });
    }
  }

  // ❌ DELETE
  void _deletePlayer(int index) async {
    final confirm = await confirmDeletePlayer(context);

    if (confirm == true) {
      setState(() {
        players.removeAt(index);
      });
    }
  }

  // 💾 SAVE + RETURN
  void _saveAndExit() async {
    await GameStorage.saveGameData(
      time: 120,
      imposterCount: 1,
      showHint: false,
      showCategory: false,
      players: players,
    );

    if (!mounted) return;

    Navigator.pop(context, players);
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 50,
      left: 20,
      child: InkWell(
        onTap: _saveAndExit,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          child: const Icon(Icons.arrow_left_outlined, color: Colors.white),
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
          BackgroundBlur(imagePath: 'images/imposterbg.png'),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
                  SizedBox(height: 20),
                  Center(
                    child: GradientText(
                      "PLAYERS",
                      size: 26,
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 140, 20, 20),
            itemCount: players.length,
            itemBuilder: (_, index) {
              return ListTile(
                leading: Icon(
                  players[index].avatar,
                  color: const Color(0xFF00D1FF),
                ),
                title: Text(
                  players[index].name,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(
                  Icons.edit,
                  color: Color.fromARGB(92, 255, 59, 154),
                ),
                onTap: () => _editPlayer(index),
                onLongPress: () => _deletePlayer(index),
              );
            },
          ),

          _buildBackButton(),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: gradientButton("ADD PLAYER", _addPlayer),
      ),
    );
  }
}
