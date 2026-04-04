import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Central constants for Gram Setu app.
/// Change [_lanIp] below to your laptop's local Wi-Fi IP when testing on a physical device.
class AppConstants {
  AppConstants._(); // prevent instantiation

  // ── API ────────────────────────────────────────────────────────────────────
  /// Your laptop's LAN IP for physical device testing (e.g., 192.168.1.x).
  /// Run `ipconfig` on Windows to find it.
  static const String _lanIp = '192.168.52.31';

  /// Base URL is resolved automatically per platform:
  ///   • Flutter Web          → http://localhost:3000
  ///   • Android Emulator     → http://10.0.2.2:3000
  ///   • Physical Device      → http://<_lanIp>:3000
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://$_lanIp:3000';
  }

  // ── Timeouts ───────────────────────────────────────────────────────────────
  static const Duration kRequestTimeout = Duration(seconds: 15);

  // ── Asset Paths ────────────────────────────────────────────────────────────
  /// Correct path for the app logo.
  /// In pubspec.yaml declare:  assets: - assets/images/
  static const String kLogoPath = 'assets/images/logo.png';
}
