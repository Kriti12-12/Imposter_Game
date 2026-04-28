import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../functions/players.dart';
import 'package:flutter/material.dart';

class GameStorage {
  static const _keyTime = "time";
  static const _keyImposter = "imposter";
  static const _keyHint = "hint";
  static const _keyCategory = "category";
  static const _keyCategoryList = "category_list";
  static const _keyPlayers = "players";

  // 💾 SAVE GAME DATA
  static Future<void> saveGameData({
    required int time,
    required int imposterCount,
    required bool showHint,
    required bool showCategory,
    required List<Player> players,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_keyTime, time);
    await prefs.setInt(_keyImposter, imposterCount);
    await prefs.setBool(_keyHint, showHint);
    await prefs.setBool(_keyCategory, showCategory);

    // 👥 SAVE PLAYERS
    final encodedPlayers = players
        .map((p) => {"name": p.name, "avatar": p.avatar.codePoint})
        .toList();

    await prefs.setString(_keyPlayers, jsonEncode(encodedPlayers));
  }

  // 📥 LOAD GAME SETTINGS
  static Future<Map<String, dynamic>> loadGameData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "time": prefs.getInt(_keyTime) ?? 120,
      "imposterCount": prefs.getInt(_keyImposter) ?? 1,
      "showHint": prefs.getBool(_keyHint) ?? false,
      "showCategory": prefs.getBool(_keyCategory) ?? false,
    };
  }

  // 👥 LOAD PLAYERS
  static Future<List<Player>> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyPlayers);

    if (raw == null) return [];

    final data = jsonDecode(raw) as List;

    return data.map((p) {
      return Player(
        name: p["name"],
        avatar: IconData(
          (p["avatar"] as num).toInt(),
          fontFamily: 'MaterialIcons',
        ),
      );
    }).toList();
  }

  // 📂 SAVE CATEGORY
  static Future<void> saveCategory(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCategoryList, categories);
  }

  // 📂 LOAD CATEGORY
  static Future<List<String>> loadCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyCategoryList) ?? [];
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
