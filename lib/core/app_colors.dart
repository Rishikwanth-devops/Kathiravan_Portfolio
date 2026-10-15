import 'package:flutter/material.dart';

/// Midnight-ink background with a violet -> cyan brand gradient and a warm
/// amber accent. Dark, calm and professional, with enough energy to stand out.
abstract final class AppColors {
  static const Color bg = Color(0xFF070B1A);
  static const Color surface = Color(0xFF0B1124);
  static const Color card = Color(0xFF111832);

  static const Color primary = Color(0xFF7C5CFF);
  static const Color secondary = Color(0xFF22D3EE);
  static const Color accent = Color(0xFFFFB86B);

  static const Color text = Color(0xFFF1F4FF);
  static const Color muted = Color(0xFF9AA4C7);

  static const Color border = Color(0x1FFFFFFF);
  static const Color borderStrong = Color(0x40FFFFFF);

  static const Color whatsapp = Color(0xFF25D366);
  static const Color linkedin = Color(0xFF0A66C2);
  static const Color gmail = Color(0xFFEA4335);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, secondary],
  );
}
