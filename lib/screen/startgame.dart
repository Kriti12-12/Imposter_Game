import 'package:flutter/material.dart';
import 'package:imposter/functions/startgamefunctions.dart';
import '../ui/common.dart';
import '../screen/homescreen.dart';
import '../ui/buttiondesign.dart';
import '../screen/playersscreen.dart';
import '../functions/categoryfunc.dart';
import '../functions/players.dart';
import '../screen/gamescreen.dart';
import '../functions/game_storage.dart';
import 'dart:math';

class Startgame extends StatefulWidget {
  const Startgame({super.key});

  @override
  State<Startgame> createState() => _StartgameState();
}

class _StartgameState extends State<Startgame> {
  int selectedTime = 120;

  bool showCategoryToImposter = false;
  bool showHintToImposter = false;

  int imposterCount = 1;

  List<Player> players = [
    Player(name: "Player 1", avatar: Icons.face),
    Player(name: "Player 2", avatar: Icons.face),
    Player(name: "Player 3", avatar: Icons.face),
  ];

  List<String> selectedCategories = [];

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // 💾 LOAD SAFE
  void _loadSavedData() async {
    final data = await GameStorage.loadGameData();
    final cats = await GameStorage.loadCategory();
    final savedPlayers = await GameStorage.loadPlayers();

    if (!mounted) return;

    setState(() {
      selectedTime = data["time"] ?? 120;
      imposterCount = data["imposterCount"] ?? 1;
      showHintToImposter = data["showHint"] ?? false;
      showCategoryToImposter = data["showCategory"] ?? false;
      selectedCategories = cats;

      if (savedPlayers.isNotEmpty) {
        players = savedPlayers;
      }
    });
  }

  // 💾 SAVE SAFE
  Future<void> _saveSettings() async {
    await GameStorage.saveGameData(
      time: selectedTime,
      imposterCount: imposterCount,
      showHint: showHintToImposter,
      showCategory: showCategoryToImposter,
      players: players,
    );

    await GameStorage.saveCategory(selectedCategories);
  }

  // ⏱ TIME
  Future<void> _pickTime() async {
    final result = await openTimeSelector(context);

    if (result != null && mounted) {
      setState(() => selectedTime = result);
      await _saveSettings();
    }
  }

  // ▶ START GAME 
  void _startGame() {
    if (_loading) return;

    final categoryList = selectedCategories.isNotEmpty
        ? selectedCategories
        : CategoryData.categories.map((e) => e.title).toList();

    final filtered = CategoryData.categories
        .where((c) => categoryList.contains(c.title))
        .toList();

    if (filtered.isEmpty || players.length < 2) return;

    final category = filtered[Random().nextInt(filtered.length)];
    final wordItem = GameHelper.getRandomWord(category);

    final safeImposterCount = imposterCount.clamp(1, players.length - 1);

    final imposterIndexes = GameHelper.getRandomImposters(
      players.length,
      safeImposterCount,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Gamescreen(
          players: players,
          category: category.title,
          word: wordItem.word,
          hint: wordItem.hint,
          imposterIndexes: imposterIndexes,
          showCategoryToImposter: showCategoryToImposter,
          showHintToImposter: showHintToImposter,
          selectedTime: selectedTime,
        ),
      ),
    );
  }

  void _goBack() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Homescreen()),
      (route) => false,
    );
  }

  Widget _buildPlayersCard() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PlayersScreen(players: players)),
        );

        if (result != null && mounted) {
          setState(() => players = result);
          await _saveSettings();
        }
      },
      child: glassCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              const Icon(Icons.people_alt_rounded, size: 40, color: Color(0xFF00D1FF)),
              const SizedBox(height: 10),
              const Text("Players", style: TextStyle(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 8),
              Text("${players.length}", style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImposterCard() {
    return glassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            const Icon(Icons.discord_rounded, size: 40, color: Color(0xFFFF3B9A)),
            const SizedBox(height: 10),
            const Text("Imposter", style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (imposterCount > 1) {
                      setState(() => imposterCount--);
                      await _saveSettings();
                    }
                  },
                  child: const Icon(Icons.remove_circle, color: Colors.white70),
                ),

                const SizedBox(width: 10),
                Text("$imposterCount", style: const TextStyle(color: Colors.white70)),

                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    if (imposterCount < players.length - 1) {
                      setState(() => imposterCount++);
                      await _saveSettings();
                    }
                  },
                  child: const Icon(Icons.add_circle, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCard() {
    return glassCard(
      child: Row(
        children: [
          const Icon(Icons.watch_later_outlined, size: 40, color: Color(0xFF00D1FF)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              children: [
                const Text("Time Left", style: TextStyle(color: Colors.white70)),
                Text("${selectedTime ~/ 60} Minutes",
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
            onPressed: _pickTime,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.category, color: Color(0xFF00D1FF), size: 20),
            SizedBox(width: 8),
            Text("Categories", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),

        AppSpacing.h10,

        glassCard(
          child: Column(
            children: [
              SwitchListTile(
                value: showCategoryToImposter,
                title: const Text("Show Category To Imposter",
                    style: TextStyle(color: Colors.white70)),
                    activeColor: Color(0xFFFF3B9A),
                onChanged: (val) async {
                  setState(() => showCategoryToImposter = val);
                  await _saveSettings();
                },
              ),

              SwitchListTile(
                value: showHintToImposter,
                title: const Text("Show Hint To Imposter",
                    style: TextStyle(color: Colors.white70)),
                    activeColor: Color(0xFFFF3B9A),
                onChanged: (val) async {
                  setState(() => showHintToImposter = val);
                  await _saveSettings();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 50,
      left: 20,
      child: InkWell(
        onTap: _goBack,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const GradientText("GAME SETUP", size: 30, weight: FontWeight.bold),

                  AppSpacing.h20,

                  Row(
                    children: [
                      Expanded(child: _buildPlayersCard()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildImposterCard()),
                    ],
                  ),

                  AppSpacing.h20,
                  _buildTimeCard(),
                  AppSpacing.h20,
                  _buildCategorySection(),
                ],
              ),
            ),
          ),
          _buildBackButton(),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: gradientButton("START", _startGame),
      ),
    );
  }
}