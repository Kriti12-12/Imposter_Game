import 'package:flutter/material.dart';
import 'package:imposter/functions/audio_manager.dart';

// Custom gradient button
Widget gradientButton(String text, VoidCallback onPressed) {
  return Container(
    width: 250,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF00D1FF), Color(0xFF7B61FF), Color(0xFFFF3B9A)],
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF7B61FF).withValues(alpha: 0.5),
          blurRadius: 20,
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: () async {
        AudioManager().playClick();
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}
