import 'package:flutter/material.dart';
import '../ui/buttiondesign.dart';
import '../ui/common.dart';
import '../screen/homescreen.dart';
import '../screen/startgame.dart';
import '../functions/categoryfunc.dart';
import '../functions/game_storage.dart';

class CategorySelectio extends StatefulWidget {
  const CategorySelectio({super.key});

  @override
  State<CategorySelectio> createState() => _CategorySelectioState();
}

class _CategorySelectioState extends State<CategorySelectio> {
  Set<String> selected = {};

  @override
  void initState() {
    super.initState();
    _loadSavedCategories();
  }

  // 📥 LOAD SAVED CATEGORY
  void _loadSavedCategories() async {
    final saved = await GameStorage.loadCategory();

    setState(() {
      selected = saved.toSet();
    });
  }

  void toggleCategory(String title) async {
    setState(() {
      if (selected.contains(title)) {
        selected.remove(title);
      } else {
        selected.add(title);
      }
    });

    // 💾 AUTO SAVE ON CHANGE
    await GameStorage.saveCategory(selected.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 120,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Homescreen()),
                    (route) => false,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: const Icon(
                    Icons.arrow_left_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Center(
              child: GradientText(
                "SELECT CATEGORY",
                size: 30,
                weight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          BackgroundBlur(
            imagePath: 'images/imposterbg.png',
            blurSigma: 20,
            opacity: 0.4,
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 20,
                  runSpacing: 20,

                  children: CategoryData.categories.map((cat) {
                    bool isSelected = selected.contains(cat.title);

                    return GestureDetector(
                      onTap: () => toggleCategory(cat.title),

                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: isSelected
                              ? const Color(0xFF7B61FF).withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.05),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF7B61FF)
                                : Colors.white24,
                          ),
                        ),

                        child: Column(
                          children: [
                            Text(
                              cat.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Image.asset(cat.image, height: 60),

                            const SizedBox(height: 10),

                            Text(
                              "${cat.words.length} words",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),

        child: gradientButton("GET STARTED", () async {
          await GameStorage.saveCategory(selected.toList());

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, _, _) => const Startgame(),
              transitionsBuilder: (_, animation, _, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        }),
      ),
    );
  }
}
