import 'package:flutter/material.dart';
import 'dart:ui';

class AppGradients {
  static const mainGradient = LinearGradient(
    colors: [Color(0xFF00D1FF), Color(0xFF7B61FF), Color(0xFFFF3B9A)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class GradientText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final double letterSpacing;
  final TextAlign? align;

  const GradientText(
    this.text, {
    super.key,
    this.size = 16,
    this.weight = FontWeight.normal,
    this.letterSpacing = 0,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          AppGradients.mainGradient.createShader(bounds),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          letterSpacing: letterSpacing,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AppSpacing {
  static const h5 = SizedBox(height: 5);
  static const h10 = SizedBox(height: 10);
  static const h20 = SizedBox(height: 20);
  static const h60 = SizedBox(height: 60);
  static const h100 = SizedBox(height: 100);
  static const h30 = SizedBox(height: 30);
  static const h16 = SizedBox(height: 16);
}

class AppTextStyles {
  static const white = TextStyle(color: Colors.white);
  static const white70 = TextStyle(color: Colors.white70);
}

class AppShadows {
  static const neonGlow = [
    Shadow(color: Color(0xFF00D1FF), blurRadius: 25),
    Shadow(color: Color(0xFF7B61FF), blurRadius: 35),
    Shadow(color: Color(0xFFFF3B9A), blurRadius: 60),
  ];
}

class BackgroundBlur extends StatelessWidget {
  final String imagePath;
  final double blurSigma;
  final double opacity;

  const BackgroundBlur({
    super.key,
    required this.imagePath,
    this.blurSigma = 20,
    this.opacity = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: Container(color: Colors.black.withValues(alpha: 0.4)),
            ),
          ],
        ),
      ),
    );
  }
}

class sectionTitle extends StatelessWidget {
  final String text;
  const sectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class bullet extends StatelessWidget {
  final String text;
  const bullet(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 6, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final String words;

  const CategoryCard({
    super.key,
    required this.title,
    required this.image,
    required this.words,
  });

  @override
  Widget build(BuildContext context) {
    return glassCard(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyles.white.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.h10,
            ClipOval(
              child: Image.asset(
                image,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            AppSpacing.h10,
            Text(words, style: AppTextStyles.white70),
          ],
        ),
      ),
    );
  }
}

class startCard extends StatelessWidget {
  final IconData icon;
  final String words;
  final Color color;

  const startCard({
    super.key,
    required this.icon,
    required this.words,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return glassCard(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            AppSpacing.h10,
            Text(
              words,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget glassCard({Widget? child, Key? key}) {
  return ClipRRect(
    key: key,
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: child,
      ),
    ),
  );
}
