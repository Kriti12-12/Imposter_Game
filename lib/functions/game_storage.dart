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

  // 🔊 AUDIO KEYS
  static const _keyVolume = "music_volume";
  static const _keyMute = "music_mute";
  static const _keyClick = "click_sound";

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

    final encodedPlayers = players
        .map(
          (p) => {
            "name": p.name,
            "avatar": p.avatar.codePoint, // ✔ safe storage
          },
        )
        .toList();

    await prefs.setString(_keyPlayers, jsonEncode(encodedPlayers));
  }

  // 📥 LOAD GAME DATA
  static Future<Map<String, dynamic>> loadGameData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "time": prefs.getInt(_keyTime) ?? 120,
      "imposterCount": prefs.getInt(_keyImposter) ?? 1,
      "showHint": prefs.getBool(_keyHint) ?? false,
      "showCategory": prefs.getBool(_keyCategory) ?? false,
    };
  }

  // 👥 LOAD PLAYERS (FIXED)
  static Future<List<Player>> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyPlayers);

    if (raw == null) return [];

    final data = jsonDecode(raw) as List;

    return data.map((p) {
      final codePoint = (p["avatar"] as num).toInt();

      return Player(
        name: p["name"],
        avatar: IconData(codePoint, fontFamily: 'MaterialIcons'),
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

  // 🧹 CLEAR ALL DATA
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // 🔊 SAVE AUDIO SETTINGS
  static Future<void> saveAudioSettings({
    required double volume,
    required bool isMuted,
    required bool clickSound,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(_keyVolume, volume);
    await prefs.setBool(_keyMute, isMuted);
    await prefs.setBool(_keyClick, clickSound);
  }

  // 📥 LOAD AUDIO SETTINGS
  static Future<Map<String, dynamic>> loadAudioSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "volume": prefs.getDouble(_keyVolume) ?? 1.0,
      "isMuted": prefs.getBool(_keyMute) ?? false,
      "clickSound": prefs.getBool(_keyClick) ?? true,
    };
  }
}
