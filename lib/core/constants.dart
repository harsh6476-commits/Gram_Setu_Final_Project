import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Central constants for Gram Setu app.
class AppConstants {
  AppConstants._(); // prevent instantiation

  // ── API ────────────────────────────────────────────────────────────────────
  // Live Render Backend
  static String get baseUrl => 'https://gram-setu-backend.onrender.com';



  // ── Timeouts ───────────────────────────────────────────────────────────────
  static const Duration kRequestTimeout = Duration(seconds: 15);

  // ── Asset Paths ────────────────────────────────────────────────────────────
  /// Correct path for the app logo.
  static const String kLogoPath = 'assets/images/logo.png';

  // ── Common API Headers ───────────────────────────────────────────────────────
  static Map<String, String> get apiHeaders => {
    'Content-Type': 'application/json',
  };
}
